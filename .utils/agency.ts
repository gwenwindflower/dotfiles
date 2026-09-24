#!/usr/bin/env -S deno run --allow-read
/**
 * agency — probe the agent permission configs declared in this repo.
 *
 * Probes live in `agency.toml`. `agency_test.ts` turns each one into a test:
 *   - [[sandbox]] probes run a command under `codex sandbox -P <profile>` with the
 *     repo's `symsources/codex/config.toml` and expect it to succeed or be blocked.
 *   - [[rule]] cases check the strongest `codex execpolicy` decision across
 *     `dot_codex/rules/*.rules`.
 *
 * Run through the utils test runner: `deno task test agency`, or the `agency`
 * fish function. See docs/agency.md.
 */

import { parse as parseToml } from "@std/toml";
import { dirname, fromFileUrl, join } from "@std/path";

export type SandboxExpectation = "ok" | "deny";
export type RuleDecision = "allow" | "prompt" | "forbidden" | "none";

export interface SandboxProbe {
  name: string;
  expect: SandboxExpectation;
  cmd: string;
}

export interface RuleCase {
  cmd: string;
  expect: RuleDecision;
}

export interface Probes {
  sandbox: SandboxProbe[];
  rule: RuleCase[];
}

const SANDBOX_EXPECTATIONS: readonly string[] = ["ok", "deny"];
const RULE_DECISIONS: readonly string[] = [
  "allow",
  "prompt",
  "forbidden",
  "none",
];

/** Repo root: the parent of the `.utils` directory holding this file. */
export function repoRoot(): string {
  return dirname(dirname(fromFileUrl(import.meta.url)));
}

/** Parses and validates `agency.toml` text; errors name the table index and field. */
export function parseProbes(text: string, source = "agency.toml"): Probes {
  const data = parseToml(text) as Record<string, unknown>;
  const sandbox = asTables(data.sandbox, "sandbox", source).map((t, i) => {
    const where = `${source}: [[sandbox]] #${i + 1}`;
    const probe = {
      name: requireString(t, "name", where),
      expect: requireString(t, "expect", where),
      cmd: requireString(t, "cmd", where),
    };
    if (!SANDBOX_EXPECTATIONS.includes(probe.expect)) {
      throw new Error(
        `${where}: expect must be "ok" or "deny", got "${probe.expect}"`,
      );
    }
    return probe as SandboxProbe;
  });
  const rule = asTables(data.rule, "rule", source).map((t, i) => {
    const where = `${source}: [[rule]] #${i + 1}`;
    const c = {
      cmd: requireString(t, "cmd", where),
      expect: requireString(t, "expect", where),
    };
    if (!RULE_DECISIONS.includes(c.expect)) {
      throw new Error(
        `${where}: expect must be one of ${
          RULE_DECISIONS.join(", ")
        }, got "${c.expect}"`,
      );
    }
    return c as RuleCase;
  });
  return { sandbox, rule };
}

function asTables(
  value: unknown,
  key: string,
  source: string,
): Record<string, unknown>[] {
  if (value === undefined) return [];
  if (!Array.isArray(value)) {
    throw new Error(
      `${source}: "${key}" must be an array of tables ([[${key}]])`,
    );
  }
  return value as Record<string, unknown>[];
}

function requireString(
  table: Record<string, unknown>,
  key: string,
  where: string,
): string {
  const value = table[key];
  if (typeof value !== "string" || value.trim() === "") {
    throw new Error(`${where}: missing string field "${key}"`);
  }
  return value;
}

/**
 * Splits a command line into argv the way a POSIX shell would for plain words and
 * single- or double-quoted strings. Rule cases never need expansion or escapes beyond that.
 */
export function tokenize(cmd: string): string[] {
  const tokens: string[] = [];
  let current = "";
  let quote: "'" | '"' | null = null;
  let inToken = false;
  for (const ch of cmd) {
    if (quote) {
      if (ch === quote) quote = null;
      else current += ch;
    } else if (ch === "'" || ch === '"') {
      quote = ch;
      inToken = true;
    } else if (/\s/.test(ch)) {
      if (inToken) tokens.push(current);
      current = "";
      inToken = false;
    } else {
      current += ch;
      inToken = true;
    }
  }
  if (quote) throw new Error(`unterminated ${quote} quote in: ${cmd}`);
  if (inToken) tokens.push(current);
  return tokens;
}

/** Arguments for `codex execpolicy check` over every rule file. */
export function execpolicyArgs(ruleFiles: string[], cmd: string): string[] {
  return [
    "execpolicy",
    "check",
    ...ruleFiles.flatMap((f) => ["-r", f]),
    ...tokenize(cmd),
  ];
}

/** The strongest decision from `codex execpolicy check` JSON output; "none" when no rule matched. */
export function parseDecision(stdout: string): RuleDecision {
  const decision = JSON.parse(stdout).decision;
  if (decision === undefined || decision === null) return "none";
  if (!RULE_DECISIONS.includes(decision)) {
    throw new Error(`unexpected execpolicy decision: ${decision}`);
  }
  return decision as RuleDecision;
}

/** Arguments for running one sandbox probe under a permission profile. */
export function sandboxArgs(profile: string, cmd: string): string[] {
  return ["sandbox", "-P", profile, "--", "bash", "-c", cmd];
}

/** The permission profile a Codex config selects with `default_permissions`. */
export function defaultProfile(configText: string): string {
  const config = parseToml(configText) as Record<string, unknown>;
  const profile = config.default_permissions;
  if (typeof profile !== "string") {
    throw new Error(
      "symsources/codex/config.toml sets no default_permissions; agency probes the profile it names",
    );
  }
  return profile;
}

/** Nested Seatbelt fails with this message inside another sandbox (an agent's shell). */
export function isNestedSandboxFailure(stderr: string): boolean {
  return stderr.includes("sandbox_apply: Operation not permitted");
}

export function ruleFilePaths(root: string): string[] {
  const dir = join(root, "dot_codex", "rules");
  return [...Deno.readDirSync(dir)]
    .filter((e) => e.isFile && e.name.endsWith(".rules"))
    .map((e) => join(dir, e.name))
    .sort();
}

if (import.meta.main) {
  const probes = parseProbes(
    Deno.readTextFileSync(join(repoRoot(), ".utils", "agency.toml")),
  );
  console.log(
    `${probes.sandbox.length} sandbox probes, ${probes.rule.length} rule cases`,
  );
  console.log(
    "Run them with `deno task test agency` or the `agency` fish function.",
  );
}
