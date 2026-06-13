#!/usr/bin/env -S deno run --allow-read --allow-write
/**
 * twinsies — keep entries in lockstep across multiple agent config files.
 *
 * Source: twinsies.toml in the same dir. Each [<domain>.<channel>] table
 * holds entries every supporting agent should have. Adapters translate
 * source entries into each agent's native wire format and reconcile the
 * regions they own: missing entries added, extras removed, mode drift
 * resolved source-wins. Entries outside the owned regions (Claude's
 * `WebFetch(…)` / `Skill` / `mcp__*`, OpenCode's catch-all `"*": "ask"`
 * inside `permission.bash`, sibling scalar keys under `permission`) are
 * left alone.
 *
 * Usage:
 *   deno run --allow-read --allow-write twinsies.ts   # reconcile in place
 *   deno run --allow-read twinsies.ts --dry-run       # rich diff + proposed file contents, exit 0
 *   deno run --allow-read twinsies.ts --check         # terse drift report, exit 1 on drift
 *   deno run --allow-read twinsies.ts --target claude # limit to one adapter
 */

import { parse as parseToml } from "@std/toml";
import { parse as parseJsonc } from "@std/jsonc";
import { bold, cyan, dim, green, red, yellow } from "@std/fmt/colors";
import { dirname, fromFileUrl, resolve } from "@std/path";

// ── Types ──────────────────────────────────────────────────────────────

export type Mode = "allow" | "ask" | "deny";

export type Channel = "bash" | "edit";

export const CHANNELS: readonly Channel[] = ["bash", "edit"];

export interface SourceConfig {
  permissions: Partial<Record<Channel, Record<string, Mode>>>;
}

export interface Missing {
  channel: Channel;
  pattern: string;
  mode: Mode;
}

export interface Extra {
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
  extras: Extra[];
  conflicts: Conflict[];
}

interface Adapter {
  readonly name: string;
  readonly path: string;
  readonly supports: ReadonlySet<Channel>;
  diff(source: SourceConfig): Promise<TargetDiff>;
  apply(source: SourceConfig): Promise<string>; // returns new file contents
}

// ── Source loading ─────────────────────────────────────────────────────

const SCRIPT_DIR = dirname(fromFileUrl(import.meta.url));
const REPO_ROOT = resolve(SCRIPT_DIR, "..");

export async function loadSource(path: string): Promise<SourceConfig> {
  const text = await Deno.readTextFile(path);
  const data = parseToml(text) as { permissions?: Record<string, unknown> };
  const perms: SourceConfig["permissions"] = {};
  for (const channel of CHANNELS) {
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

// ── Shared diff machinery ──────────────────────────────────────────────

/**
 * Compute the three-way diff between a source channel map and a target
 * channel map (both `pattern → mode`). Pure — no I/O, no encoding.
 */
function diffChannel(
  channel: Channel,
  source: Record<string, Mode>,
  target: Record<string, Mode>,
): { missing: Missing[]; extras: Extra[]; conflicts: Conflict[] } {
  const missing: Missing[] = [];
  const extras: Extra[] = [];
  const conflicts: Conflict[] = [];
  for (const [pattern, mode] of Object.entries(source)) {
    const current = target[pattern];
    if (current === undefined) {
      missing.push({ channel, pattern, mode });
    } else if (current !== mode) {
      conflicts.push({
        channel,
        pattern,
        sourceMode: mode,
        targetMode: current,
      });
    }
  }
  for (const [pattern, mode] of Object.entries(target)) {
    if (source[pattern] === undefined) {
      extras.push({ channel, pattern, mode });
    }
  }
  return { missing, extras, conflicts };
}

// ── Claude adapter ────────────────────────────────────────────────────

export function encodeClaude(channel: Channel, pattern: string): string {
  switch (channel) {
    case "bash":
      return `Bash(${pattern})`;
    case "edit":
      return `Edit(${pattern})`;
  }
}

const CLAUDE_WIRE_RE = /^(Bash|Edit)\((.+)\)$/;

/**
 * Decode a Claude wire-format entry back into (channel, pattern), or null
 * if it isn't twinsies-owned (e.g. `WebFetch(domain:…)`, `Skill`,
 * `mcp__server__tool`, `Read(…)` sandbox roots).
 */
export function decodeClaude(
  wire: string,
): { channel: Channel; pattern: string } | null {
  const m = CLAUDE_WIRE_RE.exec(wire);
  if (!m) return null;
  const kind = m[1] as "Bash" | "Edit";
  const channel: Channel = kind === "Bash" ? "bash" : "edit";
  return { channel, pattern: m[2] };
}

/** Pull twinsies-owned entries out of Claude's allow/ask/deny arrays. */
function readClaudeOwned(
  data: {
    permissions?: { allow?: string[]; ask?: string[]; deny?: string[] };
  },
): Record<Channel, Record<string, Mode>> {
  const owned: Record<Channel, Record<string, Mode>> = {
    bash: {},
    edit: {},
  };
  for (const mode of MODE_ORDER) {
    for (const wire of data.permissions?.[mode] ?? []) {
      const decoded = decodeClaude(wire);
      if (decoded) owned[decoded.channel][decoded.pattern] = mode;
    }
  }
  return owned;
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
  const owned = readClaudeOwned(data);

  const missing: Missing[] = [];
  const extras: Extra[] = [];
  const conflicts: Conflict[] = [];
  for (const channel of supports) {
    const sourceMap = source.permissions[channel] ?? {};
    const targetMap = owned[channel];
    const d = diffChannel(channel, sourceMap, targetMap);
    missing.push(...d.missing);
    extras.push(...d.extras);
    conflicts.push(...d.conflicts);
  }
  return { target: targetName, missing, extras, conflicts };
}

export function applyClaudeText(text: string, source: SourceConfig): string {
  const data = JSON.parse(text) as {
    permissions?: { allow?: string[]; ask?: string[]; deny?: string[] };
  };
  data.permissions ??= {};
  for (const m of MODE_ORDER) data.permissions[m] ??= [];

  // Strip all twinsies-owned entries; leave WebFetch/Skill/mcp__* in place.
  for (const m of MODE_ORDER) {
    data.permissions[m] = data.permissions[m]!.filter(
      (wire) => decodeClaude(wire) === null,
    );
  }

  // Re-add owned entries from source under the correct mode.
  for (const channel of CHANNELS) {
    const entries = source.permissions[channel];
    if (!entries) continue;
    for (const [pattern, mode] of Object.entries(entries)) {
      data.permissions[mode]!.push(encodeClaude(channel, pattern));
    }
  }

  for (const m of MODE_ORDER) {
    data.permissions[m] = [...new Set(data.permissions[m])].sort();
  }
  return JSON.stringify(data, null, "\t") + "\n";
}

class ClaudeAdapter implements Adapter {
  readonly name = "claude";
  readonly path = resolve(REPO_ROOT, "symsource_claude/settings.json");
  readonly supports = new Set<Channel>(CHANNELS);

  async diff(source: SourceConfig): Promise<TargetDiff> {
    const text = await Deno.readTextFile(this.path);
    return diffClaudeText(text, source, this.supports, this.name);
  }

  async apply(source: SourceConfig): Promise<string> {
    const text = await Deno.readTextFile(this.path);
    return applyClaudeText(text, source);
  }
}

// ── OpenCode adapter ──────────────────────────────────────────────────

/**
 * Entries that live inside an owned `permission.<channel>` block but are
 * intentionally not in the source manifest — they're agent-specific and
 * should survive a full reconciliation. Keep this list short and obvious.
 */
const OPENCODE_PRESERVED: Partial<Record<Channel, ReadonlySet<string>>> = {
  bash: new Set(["*"]), // OpenCode-only catch-all ask floor
};

function isPreserved(channel: Channel, pattern: string): boolean {
  return OPENCODE_PRESERVED[channel]?.has(pattern) ?? false;
}

export function diffOpencodeText(
  text: string,
  source: SourceConfig,
  supports: ReadonlySet<Channel>,
  targetName = "opencode",
): TargetDiff {
  const data = parseJsonc(text) as { permission?: Record<string, unknown> };
  const missing: Missing[] = [];
  const extras: Extra[] = [];
  const conflicts: Conflict[] = [];

  for (const channel of supports) {
    const block = data.permission?.[channel];
    const targetMap: Record<string, Mode> = {};
    if (block && typeof block === "object") {
      for (const [k, v] of Object.entries(block as Record<string, unknown>)) {
        if (typeof v === "string" && !isPreserved(channel, k)) {
          targetMap[k] = v as Mode;
        }
      }
    }
    const sourceMap = source.permissions[channel] ?? {};
    const d = diffChannel(channel, sourceMap, targetMap);
    missing.push(...d.missing);
    extras.push(...d.extras);
    conflicts.push(...d.conflicts);
  }
  return { target: targetName, missing, extras, conflicts };
}

export function applyOpencodeText(text: string, source: SourceConfig): string {
  const permBlock = findObjectBlock(text, "permission");
  if (!permBlock) throw new Error("opencode: 'permission' block not found");

  for (const channel of CHANNELS) {
    text = reconcileOpencodeBlock(text, permBlock.openBrace, channel, source);
  }
  return text;
}

class OpencodeAdapter implements Adapter {
  readonly name = "opencode";
  readonly path = resolve(
    REPO_ROOT,
    "private_dot_config/opencode/opencode.jsonc",
  );
  readonly supports = new Set<Channel>(CHANNELS);

  async diff(source: SourceConfig): Promise<TargetDiff> {
    const text = await Deno.readTextFile(this.path);
    return diffOpencodeText(text, source, this.supports, this.name);
  }

  async apply(source: SourceConfig): Promise<string> {
    const text = await Deno.readTextFile(this.path);
    return applyOpencodeText(text, source);
  }
}

/**
 * Rebuild the `permission.<channel>` block from source, preserving any
 * adapter-specific keys flagged via `OPENCODE_PRESERVED`. Pure text rewrite
 * — assumes the block contains no JSONC comments (true for our perm
 * blocks today; doc this contract upstream).
 */
function reconcileOpencodeBlock(
  text: string,
  parentOpenBrace: number,
  channel: Channel,
  source: SourceConfig,
): string {
  const block = findObjectBlock(text, channel, parentOpenBrace);
  if (!block) {
    throw new Error(`opencode: '${channel}' block not found inside permission`);
  }
  const body = text.slice(block.openBrace + 1, block.closeBrace);
  const parsed = parseJsonc(`{${body}}`) as Record<string, Mode>;

  const entries: Array<[string, Mode]> = [];
  for (const [k, v] of Object.entries(parsed)) {
    if (isPreserved(channel, k)) entries.push([k, v]);
  }
  for (const [pattern, mode] of Object.entries(source.permissions[channel] ?? {})) {
    entries.push([pattern, mode]);
  }
  const sorted = sortEntries(entries);

  const innerIndent = detectBlockIndent(text, block.openBrace, "\t\t");
  const outerIndent = detectOuterIndent(text, block.openBrace);

  const lines = sorted.map(([pattern, mode]) =>
    `${innerIndent}"${pattern}": "${mode}"`
  );
  const joined = lines
    .map((l, i) => (i === lines.length - 1 ? l : l + ","))
    .join("\n");

  const newBlock = sorted.length === 0
    ? `{}`
    : `{\n${joined}\n${outerIndent}}`;
  return text.slice(0, block.openBrace) + newBlock +
    text.slice(block.closeBrace + 1);
}

// ── CLI ────────────────────────────────────────────────────────────────

const ADAPTERS: Adapter[] = [new ClaudeAdapter(), new OpencodeAdapter()];

function printHelp() {
  console.log(`twinsies — reconcile agent config entries to twinsies.toml

Usage:
  deno task twinsies            apply (full sync inside owned regions)
  deno task twinsies:check      drift report, exit 1 on drift
  deno task twinsies:preview    rich diff + proposed file contents, exit 0

Options:
  --check         report drift tersely and exit 1 if any, no write
  --dry-run       print full diff and proposed file contents, exit 0, no write
  --target <n>    limit to one adapter (claude | opencode); repeatable
  --source <p>    override source TOML path (default: ./twinsies.toml)
  --help          show this help`);
}

function hasDrift(diff: TargetDiff): boolean {
  return diff.missing.length > 0 || diff.extras.length > 0 ||
    diff.conflicts.length > 0;
}

function reportDiff(diff: TargetDiff, verbose: boolean) {
  const head = bold(diff.target);
  if (!hasDrift(diff)) {
    console.log(`${green("✓")} ${head}  in sync`);
    return;
  }
  console.log(`${yellow("·")} ${head}`);
  if (!verbose) {
    const parts: string[] = [];
    if (diff.missing.length) parts.push(`${diff.missing.length} missing`);
    if (diff.extras.length) parts.push(`${diff.extras.length} extra`);
    if (diff.conflicts.length) parts.push(`${diff.conflicts.length} drifted`);
    console.log(`    ${parts.join(", ")}`);
    return;
  }
  for (const m of diff.missing) {
    console.log(
      `    ${green("+")} ${cyan(m.channel)}  ${m.pattern}  ${dim("=")} ${m.mode}`,
    );
  }
  for (const e of diff.extras) {
    console.log(
      `    ${red("-")} ${cyan(e.channel)}  ${e.pattern}  ${dim("(was ")}${e.mode}${dim(")")}`,
    );
  }
  for (const c of diff.conflicts) {
    console.log(
      `    ${yellow("~")} ${cyan(c.channel)}  ${c.pattern}  ${
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

  let anyDrift = false;

  for (const adapter of adapters) {
    const diff = await adapter.diff(source);
    reportDiff(diff, !checkOnly);
    if (!hasDrift(diff)) continue;
    anyDrift = true;

    if (dryRun) {
      const newText = await adapter.apply(source);
      console.log(dim(`── ${adapter.path} ──`));
      console.log(newText);
    } else if (!checkOnly) {
      const newText = await adapter.apply(source);
      await Deno.writeTextFile(adapter.path, newText);
      console.log(`  ${green("→")} wrote ${dim(adapter.path)}`);
    }
  }

  console.log();
  if (!anyDrift) {
    console.log(green("All targets in sync."));
    return;
  }
  if (checkOnly) {
    console.log(yellow("Drift detected — run `deno task twinsies` to fix."));
    Deno.exit(1);
  }
  if (!dryRun) console.log(green("Reconciled."));
}

if (import.meta.main) {
  main();
}
