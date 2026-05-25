#!/usr/bin/env -S deno run --allow-read --allow-write
/**
 * twinsies — keep entries in lockstep across multiple agent config files.
 *
 * Source: twinsies.toml in the same dir. Each [<domain>.<channel>] table
 * holds entries every supporting agent should have. Adapters translate
 * source entries into each agent's native wire format and merge them in
 * additively (existing entries are never removed).
 *
 * Usage:
 *   deno run --allow-read --allow-write twinsies.ts            # apply fixes
 *   deno run --allow-read twinsies.ts --check                  # lint, exit 1 on drift
 *   deno run --allow-read twinsies.ts --dry-run                # print proposed writes
 *   deno run --allow-read twinsies.ts --target claude          # limit to one adapter
 */

import { parse as parseToml } from "@std/toml";
import { parse as parseJsonc } from "@std/jsonc";
import { bold, cyan, dim, green, red, yellow } from "@std/fmt/colors";
import { dirname, fromFileUrl, resolve } from "@std/path";

// ── Types ──────────────────────────────────────────────────────────────

export type Mode = "allow" | "ask" | "deny";

export type Channel = "bash" | "read" | "edit" | "scalars";

export interface SourceConfig {
  permissions: Partial<Record<Channel, Record<string, Mode>>>;
}

export interface Missing {
  channel: Channel;
  pattern: string;
  mode: Mode;
}

export interface Conflict {
  channel: Channel;
  pattern: string;
  sourceMode: Mode;
  targetMode: Mode;
}

export interface TargetDiff {
  target: string;
  missing: Missing[];
  conflicts: Conflict[];
}

interface Adapter {
  readonly name: string;
  readonly path: string;
  readonly supports: ReadonlySet<Channel>;
  diff(source: SourceConfig): Promise<TargetDiff>;
  apply(diff: TargetDiff): Promise<string>; // returns new file contents
}

// ── Source loading ─────────────────────────────────────────────────────

const SCRIPT_DIR = dirname(fromFileUrl(import.meta.url));
const REPO_ROOT = resolve(SCRIPT_DIR, "..");

export async function loadSource(path: string): Promise<SourceConfig> {
  const text = await Deno.readTextFile(path);
  const data = parseToml(text) as { permissions?: Record<string, unknown> };
  const perms: SourceConfig["permissions"] = {};
  for (const channel of ["bash", "read", "edit", "scalars"] as Channel[]) {
    const block = data.permissions?.[channel];
    if (block && typeof block === "object") {
      perms[channel] = block as Record<string, Mode>;
    }
  }
  return { permissions: perms };
}

// ── JSONC block editing (no external dep) ─────────────────────────────

/**
 * Find an object value `"<key>": { ... }` and return the indices of its
 * opening `{` and matching closing `}`. Tolerates nested braces and string
 * literals; does not strip JSONC comments (none expected inside our
 * permission blocks). Returns null if not found.
 */
export function findObjectBlock(
  text: string,
  key: string,
  fromIndex = 0,
): { openBrace: number; closeBrace: number } | null {
  const escapedKey = key.replace(/[.*+?^${}()|[\]\\]/g, "\\$&");
  const pattern = new RegExp(`"${escapedKey}"\\s*:\\s*\\{`, "g");
  pattern.lastIndex = fromIndex;
  const match = pattern.exec(text);
  if (!match) return null;

  const openBrace = match.index + match[0].length - 1;
  let depth = 1;
  let inString = false;
  let escape = false;
  let i = openBrace + 1;
  while (i < text.length && depth > 0) {
    const c = text[i];
    if (escape) {
      escape = false;
    } else if (c === "\\" && inString) {
      escape = true;
    } else if (c === '"') {
      inString = !inString;
    } else if (!inString) {
      if (c === "{") depth++;
      else if (c === "}") depth--;
    }
    i++;
  }
  if (depth !== 0) return null;
  return { openBrace, closeBrace: i - 1 };
}

/** Detect the indent used for a block's contents (the indent of its first child). */
function detectBlockIndent(
  text: string,
  openBrace: number,
  fallback: string,
): string {
  // Look at the first non-whitespace, non-newline character after the `{`.
  const after = text.slice(openBrace + 1);
  const m = after.match(/\n([ \t]*)\S/);
  return m ? m[1] : fallback;
}

/** Detect indent of the line containing `index` (outer indent). */
function detectOuterIndent(text: string, index: number): string {
  const lineStart = text.lastIndexOf("\n", index - 1) + 1;
  const slice = text.slice(lineStart, index);
  const m = slice.match(/^[ \t]*/);
  return m ? m[0] : "";
}

/**
 * Sort entries by mode group, alphabetical within. Order is ask → allow →
 * deny because sequential evaluators (OpenCode) read top-down: the
 * default-ask floor goes first, specific allows layer on top, deny sits
 * above as the hard block. `*` is ASCII 42, so the alpha tiebreaker pins
 * any bare-glob catch-all to position 0 in its group automatically.
 */
const MODE_ORDER: Mode[] = ["ask", "allow", "deny"];
export function sortEntries(
  entries: Array<[string, Mode]>,
): Array<[string, Mode]> {
  return [...entries].sort((a, b) => {
    const ma = MODE_ORDER.indexOf(a[1]);
    const mb = MODE_ORDER.indexOf(b[1]);
    if (ma !== mb) return ma - mb;
    return a[0].localeCompare(b[0]);
  });
}

// ── Claude adapter ────────────────────────────────────────────────────

export function encodeClaude(channel: Channel, pattern: string): string {
  switch (channel) {
    case "bash":
      return `Bash(${pattern})`;
    case "read":
      return `Read(${pattern})`;
    case "edit":
      return `Edit(${pattern})`;
    case "scalars":
      // Claude uses bare capitalized capability names (e.g. "Skill").
      return pattern.charAt(0).toUpperCase() + pattern.slice(1);
  }
}

export function diffClaudeText(
  text: string,
  source: SourceConfig,
  supports: ReadonlySet<Channel>,
  targetName = "claude",
): TargetDiff {
  const data = JSON.parse(text) as {
    permissions?: { allow?: string[]; ask?: string[]; deny?: string[] };
  };
  const buckets = {
    allow: new Set(data.permissions?.allow ?? []),
    ask: new Set(data.permissions?.ask ?? []),
    deny: new Set(data.permissions?.deny ?? []),
  };

  const missing: Missing[] = [];
  const conflicts: Conflict[] = [];

  for (const channel of supports) {
    const entries = source.permissions[channel];
    if (!entries) continue;
    for (const [pattern, mode] of Object.entries(entries)) {
      const wire = encodeClaude(channel, pattern);
      if (buckets[mode].has(wire)) continue;
      let conflictMode: Mode | null = null;
      for (const m of MODE_ORDER) {
        if (m !== mode && buckets[m].has(wire)) {
          conflictMode = m;
          break;
        }
      }
      if (conflictMode) {
        conflicts.push({
          channel,
          pattern,
          sourceMode: mode,
          targetMode: conflictMode,
        });
      } else {
        missing.push({ channel, pattern, mode });
      }
    }
  }

  return { target: targetName, missing, conflicts };
}

export function applyClaudeText(text: string, diff: TargetDiff): string {
  const data = JSON.parse(text) as {
    permissions?: { allow?: string[]; ask?: string[]; deny?: string[] };
  };
  data.permissions ??= {};
  for (const m of MODE_ORDER) {
    data.permissions[m] ??= [];
  }
  for (const entry of diff.missing) {
    const wire = encodeClaude(entry.channel, entry.pattern);
    data.permissions[entry.mode]!.push(wire);
  }
  for (const m of MODE_ORDER) {
    data.permissions[m] = [...new Set(data.permissions[m])].sort();
  }
  return JSON.stringify(data, null, "\t") + "\n";
}

class ClaudeAdapter implements Adapter {
  readonly name = "claude";
  readonly path = resolve(REPO_ROOT, "symsource_claude/settings.json");
  readonly supports = new Set<Channel>(["bash", "read", "edit", "scalars"]);

  async diff(source: SourceConfig): Promise<TargetDiff> {
    const text = await Deno.readTextFile(this.path);
    return diffClaudeText(text, source, this.supports, this.name);
  }

  async apply(diff: TargetDiff): Promise<string> {
    const text = await Deno.readTextFile(this.path);
    return applyClaudeText(text, diff);
  }
}

// ── OpenCode adapter ──────────────────────────────────────────────────

function lookupOpencode(
  data: { permission?: Record<string, unknown> },
  channel: Channel,
  pattern: string,
): Mode | undefined {
  if (channel === "scalars") {
    const v = data.permission?.[pattern];
    return typeof v === "string" ? (v as Mode) : undefined;
  }
  const block = data.permission?.[channel];
  if (!block || typeof block !== "object") return undefined;
  const v = (block as Record<string, unknown>)[pattern];
  return typeof v === "string" ? (v as Mode) : undefined;
}

export function diffOpencodeText(
  text: string,
  source: SourceConfig,
  supports: ReadonlySet<Channel>,
  targetName = "opencode",
): TargetDiff {
  const data = parseJsonc(text) as { permission?: Record<string, unknown> };
  const missing: Missing[] = [];
  const conflicts: Conflict[] = [];
  for (const channel of supports) {
    const entries = source.permissions[channel];
    if (!entries) continue;
    for (const [pattern, mode] of Object.entries(entries)) {
      const current = lookupOpencode(data, channel, pattern);
      if (current === mode) continue;
      if (current !== undefined) {
        conflicts.push({
          channel,
          pattern,
          sourceMode: mode,
          targetMode: current,
        });
      } else {
        missing.push({ channel, pattern, mode });
      }
    }
  }
  return { target: targetName, missing, conflicts };
}

export function applyOpencodeText(text: string, diff: TargetDiff): string {
  const byChannel = new Map<Channel, Missing[]>();
  for (const m of diff.missing) {
    if (m.channel === "scalars") continue;
    const arr = byChannel.get(m.channel) ?? [];
    arr.push(m);
    byChannel.set(m.channel, arr);
  }

  const permBlock = findObjectBlock(text, "permission");
  if (!permBlock) throw new Error("opencode: 'permission' block not found");

  for (const [channel, entries] of byChannel) {
    text = rewriteJsoncObjectBlock(text, permBlock.openBrace, channel, entries);
  }

  for (const m of diff.missing.filter((m) => m.channel === "scalars")) {
    text = upsertScalarInBlock(text, "permission", m.pattern, m.mode);
  }

  return text;
}

class OpencodeAdapter implements Adapter {
  readonly name = "opencode";
  readonly path = resolve(
    REPO_ROOT,
    "private_dot_config/opencode/opencode.jsonc",
  );
  readonly supports = new Set<Channel>(["bash", "read", "edit", "scalars"]);

  async diff(source: SourceConfig): Promise<TargetDiff> {
    const text = await Deno.readTextFile(this.path);
    return diffOpencodeText(text, source, this.supports, this.name);
  }

  async apply(diff: TargetDiff): Promise<string> {
    const text = await Deno.readTextFile(this.path);
    return applyOpencodeText(text, diff);
  }
}

/**
 * Merge `additions` into the JSONC object at `"<channel>": { ... }` inside
 * the block that starts at `parentOpenBrace`. Rewrites the entire child
 * block contents — assumes the block has no comments (true for our perm
 * blocks today; doc this contract upstream).
 */
function rewriteJsoncObjectBlock(
  text: string,
  parentOpenBrace: number,
  channel: string,
  additions: Missing[],
): string {
  const block = findObjectBlock(text, channel, parentOpenBrace);
  if (!block) {
    throw new Error(`opencode: '${channel}' block not found inside permission`);
  }
  const body = text.slice(block.openBrace + 1, block.closeBrace);
  const existing: Array<[string, Mode]> = [];
  // Parse via JSONC of the synthetic `{ <body> }` so we get clean kv pairs.
  const parsed = parseJsonc(`{${body}}`) as Record<string, Mode>;
  for (const [k, v] of Object.entries(parsed)) {
    existing.push([k, v]);
  }
  for (const a of additions) {
    existing.push([a.pattern, a.mode]);
  }
  const sorted = sortEntries(existing);

  const innerIndent = detectBlockIndent(text, block.openBrace, "\t\t");
  const outerIndent = detectOuterIndent(text, block.openBrace);

  // Format: blank line between mode groups for readability.
  const lines: string[] = [];
  let prevMode: Mode | null = null;
  for (const [pattern, mode] of sorted) {
    if (prevMode !== null && mode !== prevMode) lines.push("");
    lines.push(`${innerIndent}"${pattern}": "${mode}"`);
    prevMode = mode;
  }
  // Add trailing commas (JSONC tolerates them, but we'll match strict JSON style).
  const joined = lines
    .map((l, i) => (l === "" ? l : i === lines.length - 1 ? l : l + ","))
    .join("\n");

  const newBlock = `{\n${joined}\n${outerIndent}}`;
  return text.slice(0, block.openBrace) + newBlock +
    text.slice(block.closeBrace + 1);
}

/**
 * Insert or update a scalar key inside the named parent block. If the key
 * already exists with a different mode, replaces its value; otherwise
 * inserts before the closing brace.
 */
function upsertScalarInBlock(
  text: string,
  parentKey: string,
  key: string,
  mode: Mode,
): string {
  const parent = findObjectBlock(text, parentKey);
  if (!parent) throw new Error(`opencode: '${parentKey}' block not found`);
  const body = text.slice(parent.openBrace + 1, parent.closeBrace);
  const keyRe = new RegExp(
    `("${key.replace(/[.*+?^${}()|[\]\\]/g, "\\$&")}"\\s*:\\s*)"[^"]*"`,
  );
  const m = keyRe.exec(body);
  if (m) {
    const replaced = body.replace(keyRe, `$1"${mode}"`);
    return text.slice(0, parent.openBrace + 1) + replaced +
      text.slice(parent.closeBrace);
  }
  // Insert before close brace.
  const innerIndent = detectBlockIndent(text, parent.openBrace, "\t");
  const insertion = `${innerIndent}"${key}": "${mode}",\n`;
  // Find the closing brace's line start.
  const closeLineStart = text.lastIndexOf("\n", parent.closeBrace) + 1;
  return text.slice(0, closeLineStart) + insertion + text.slice(closeLineStart);
}

// ── CLI ────────────────────────────────────────────────────────────────

const ADAPTERS: Adapter[] = [new ClaudeAdapter(), new OpencodeAdapter()];

function printHelp() {
  console.log(`twinsies — sync agent config entries from twinsies.toml

Usage:
  deno task twinsies            apply (additive merge into each target)
  deno task check-twinsies      lint only, exit 1 on drift
  deno task preview-twinsies    print proposed writes to stdout

Options:
  --check         report drift without writing
  --dry-run       print proposed file contents to stdout
  --target <n>    limit to one adapter (claude | opencode); repeatable
  --source <p>    override source TOML path (default: ./twinsies.toml)
  --help          show this help`);
}

function reportDiff(diff: TargetDiff) {
  const head = bold(diff.target);
  if (diff.missing.length === 0 && diff.conflicts.length === 0) {
    console.log(`${green("✓")} ${head}  in sync`);
    return;
  }
  console.log(`${yellow("·")} ${head}`);
  for (const m of diff.missing) {
    console.log(
      `    ${dim("+")} ${cyan(m.channel)}  ${m.pattern}  ${dim("=")} ${m.mode}`,
    );
  }
  for (const c of diff.conflicts) {
    console.log(
      `    ${red("!")} ${cyan(c.channel)}  ${c.pattern}  ${
        dim("source=")
      }${c.sourceMode} ${dim("target=")}${c.targetMode}`,
    );
  }
}

async function main() {
  const args = Deno.args;
  if (args.includes("--help") || args.includes("-h")) {
    printHelp();
    return;
  }
  const checkOnly = args.includes("--check");
  const dryRun = args.includes("--dry-run");

  const sourcePath = (() => {
    const i = args.indexOf("--source");
    if (i >= 0 && args[i + 1]) return resolve(args[i + 1]);
    return resolve(SCRIPT_DIR, "twinsies.toml");
  })();

  const targetFilter = new Set<string>();
  for (let i = 0; i < args.length; i++) {
    if (args[i] === "--target" && args[i + 1]) targetFilter.add(args[i + 1]);
  }
  const adapters = targetFilter.size
    ? ADAPTERS.filter((a) => targetFilter.has(a.name))
    : ADAPTERS;

  const source = await loadSource(sourcePath);

  let totalMissing = 0;
  let totalConflicts = 0;

  for (const adapter of adapters) {
    const diff = await adapter.diff(source);
    reportDiff(diff);
    totalMissing += diff.missing.length;
    totalConflicts += diff.conflicts.length;

    if (diff.missing.length === 0) continue;

    if (dryRun) {
      const newText = await adapter.apply(diff);
      console.log(dim(`── ${adapter.path} ──`));
      console.log(newText);
    } else if (!checkOnly) {
      const newText = await adapter.apply(diff);
      await Deno.writeTextFile(adapter.path, newText);
      console.log(`  ${green("→")} wrote ${dim(adapter.path)}`);
    }
  }

  console.log();
  if (totalConflicts > 0) {
    console.log(
      red(
        `${totalConflicts} conflict(s) found — resolve in source or target before re-running.`,
      ),
    );
    Deno.exit(2);
  }
  if (totalMissing === 0) {
    console.log(green("All targets in sync."));
    return;
  }
  if (checkOnly) {
    console.log(
      yellow(
        `${totalMissing} missing entr${
          totalMissing === 1 ? "y" : "ies"
        } — run \`deno task twinsies\` to fix.`,
      ),
    );
    Deno.exit(1);
  }
  console.log(
    green(`Added ${totalMissing} entr${totalMissing === 1 ? "y" : "ies"}.`),
  );
}

if (import.meta.main) {
  main();
}
