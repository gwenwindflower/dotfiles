import { assert, assertEquals, assertObjectMatch } from "@std/assert";
import {
  applyClaudeText,
  applyOpencodeText,
  type Channel,
  diffClaudeText,
  diffOpencodeText,
  encodeClaude,
  findObjectBlock,
  loadSource,
  type Mode,
  sortEntries,
  type SourceConfig,
} from "./twinsies.ts";

const ALL_CHANNELS = new Set<Channel>(["bash", "read", "edit", "scalars"]);

// ── findObjectBlock ────────────────────────────────────────────────

Deno.test("findObjectBlock locates a flat object value", () => {
  const text = `{
\t"permission": { "skill": "allow" }
}`;
  const block = findObjectBlock(text, "permission");
  assert(block);
  assertEquals(text[block.openBrace], "{");
  assertEquals(text[block.closeBrace], "}");
  assertEquals(
    text.slice(block.openBrace, block.closeBrace + 1),
    `{ "skill": "allow" }`,
  );
});

Deno.test("findObjectBlock handles nested braces and string-literal braces", () => {
  const text = `{
\t"permission": {
\t\t"bash": {
\t\t\t"echo {weird}": "allow",
\t\t\t"awk '{ print $1 }'": "allow"
\t\t},
\t\t"skill": "allow"
\t}
}`;
  const outer = findObjectBlock(text, "permission");
  assert(outer);
  const inner = findObjectBlock(text, "bash", outer.openBrace);
  assert(inner);
  // Inner block should encompass exactly the bash entries.
  const innerBody = text.slice(inner.openBrace, inner.closeBrace + 1);
  assert(innerBody.includes(`"echo {weird}": "allow"`));
  assert(innerBody.includes(`"awk '{ print $1 }'": "allow"`));
  assert(!innerBody.includes(`"skill"`));
});

Deno.test("findObjectBlock returns null when key not found", () => {
  const text = `{ "permission": { "skill": "allow" } }`;
  assertEquals(findObjectBlock(text, "missing"), null);
});

Deno.test("findObjectBlock skips keys that match strings but not actual object values", () => {
  // The string `"permission": {` appears inside a value, but only as data —
  // the real key match should still resolve correctly when present later.
  const text = `{
\t"comment": "look: \\"permission\\": {",
\t"permission": { "skill": "allow" }
}`;
  const block = findObjectBlock(text, "permission");
  assert(block);
  assertEquals(
    text.slice(block.openBrace, block.closeBrace + 1),
    `{ "skill": "allow" }`,
  );
});

// ── sortEntries ────────────────────────────────────────────────────

Deno.test("sortEntries groups by mode order then alpha within group", () => {
  const input: Array<[string, Mode]> = [
    ["zebra", "deny"],
    ["beta", "allow"],
    ["alpha", "deny"],
    ["midway", "ask"],
    ["apple", "allow"],
  ];
  assertEquals(sortEntries(input), [
    ["midway", "ask"],
    ["apple", "allow"],
    ["beta", "allow"],
    ["alpha", "deny"],
    ["zebra", "deny"],
  ]);
});

Deno.test("sortEntries does not mutate input", () => {
  const input: Array<[string, Mode]> = [["b", "deny"], ["a", "allow"]];
  const copy = input.map((p) => [...p]);
  sortEntries(input);
  assertEquals(input, copy);
});

// ── loadSource ─────────────────────────────────────────────────────

Deno.test("loadSource parses a TOML fixture into channels", async () => {
  const tmp = await Deno.makeTempFile({ suffix: ".toml" });
  try {
    await Deno.writeTextFile(
      tmp,
      `[permissions.bash]
"pnpm test *" = "allow"
"rm -rf *" = "deny"

[permissions.read]
".env" = "deny"

[permissions.edit]
".env" = "deny"

[permissions.scalars]
skill = "allow"
`,
    );
    const source = await loadSource(tmp);
    assertEquals(source.permissions.bash, {
      "pnpm test *": "allow",
      "rm -rf *": "deny",
    });
    assertEquals(source.permissions.read, { ".env": "deny" });
    assertEquals(source.permissions.edit, { ".env": "deny" });
    assertEquals(source.permissions.scalars, { skill: "allow" });
  } finally {
    await Deno.remove(tmp);
  }
});

Deno.test("loadSource leaves missing channels undefined", async () => {
  const tmp = await Deno.makeTempFile({ suffix: ".toml" });
  try {
    await Deno.writeTextFile(tmp, `[permissions.bash]\n"ls *" = "allow"\n`);
    const source = await loadSource(tmp);
    assertEquals(source.permissions.bash, { "ls *": "allow" });
    assertEquals(source.permissions.read, undefined);
    assertEquals(source.permissions.edit, undefined);
    assertEquals(source.permissions.scalars, undefined);
  } finally {
    await Deno.remove(tmp);
  }
});

// ── encodeClaude ───────────────────────────────────────────────────

Deno.test("encodeClaude wraps channel patterns and capitalizes scalars", () => {
  assertEquals(encodeClaude("bash", "ls *"), "Bash(ls *)");
  assertEquals(encodeClaude("read", ".env"), "Read(.env)");
  assertEquals(encodeClaude("edit", ".env"), "Edit(.env)");
  assertEquals(encodeClaude("scalars", "skill"), "Skill");
});

// ── Claude adapter: diff ───────────────────────────────────────────

const CLAUDE_FIXTURE = JSON.stringify(
  {
    permissions: {
      allow: ["Bash(ls *)", "Read(~/foo/**)", "Skill"],
      ask: [],
      deny: ["Bash(rm -rf *)", "Read(.env)", "Edit(.env)"],
    },
  },
  null,
  "\t",
);

Deno.test("diffClaudeText reports missing entries per channel", () => {
  const source: SourceConfig = {
    permissions: {
      bash: { "ls *": "allow", "pnpm test *": "allow", "rm -rf *": "deny" },
      read: { ".env": "deny" },
      edit: { ".env": "deny" },
      scalars: { skill: "allow" },
    },
  };
  const diff = diffClaudeText(CLAUDE_FIXTURE, source, ALL_CHANNELS);
  assertEquals(diff.conflicts, []);
  assertEquals(diff.missing.length, 1);
  assertObjectMatch(diff.missing[0], {
    channel: "bash",
    pattern: "pnpm test *",
    mode: "allow",
  });
});

Deno.test("diffClaudeText flags same-pattern-different-mode as conflict", () => {
  const source: SourceConfig = {
    permissions: { bash: { "rm -rf *": "allow" } }, // target has it under deny
  };
  const diff = diffClaudeText(CLAUDE_FIXTURE, source, ALL_CHANNELS);
  assertEquals(diff.missing, []);
  assertEquals(diff.conflicts.length, 1);
  assertObjectMatch(diff.conflicts[0], {
    channel: "bash",
    pattern: "rm -rf *",
    sourceMode: "allow",
    targetMode: "deny",
  });
});

Deno.test("diffClaudeText reports nothing when source is a subset of target", () => {
  const source: SourceConfig = {
    permissions: {
      bash: { "ls *": "allow" },
      scalars: { skill: "allow" },
    },
  };
  const diff = diffClaudeText(CLAUDE_FIXTURE, source, ALL_CHANNELS);
  assertEquals(diff.missing, []);
  assertEquals(diff.conflicts, []);
});

// ── Claude adapter: apply ──────────────────────────────────────────

Deno.test("applyClaudeText adds missing entries, sorts, and preserves modes", () => {
  const diff = {
    target: "claude",
    missing: [
      {
        channel: "bash" as Channel,
        pattern: "pnpm test *",
        mode: "allow" as Mode,
      },
      { channel: "bash" as Channel, pattern: "dd *", mode: "deny" as Mode },
    ],
    conflicts: [],
  };
  const out = applyClaudeText(CLAUDE_FIXTURE, diff);
  const data = JSON.parse(out);
  assert(data.permissions.allow.includes("Bash(pnpm test *)"));
  assert(data.permissions.deny.includes("Bash(dd *)"));
  // Allow list must be alphabetically sorted.
  const allow = data.permissions.allow as string[];
  assertEquals([...allow].sort(), allow);
  // No duplicate entries.
  assertEquals(new Set(allow).size, allow.length);
});

// ── OpenCode adapter: diff ─────────────────────────────────────────

const OPENCODE_FIXTURE = `{
\t"$schema": "https://opencode.ai/config.json",
\t"permission": {
\t\t"bash": {
\t\t\t"*": "ask",
\t\t\t"ls *": "allow",
\t\t\t"rm -rf *": "deny"
\t\t},
\t\t"skill": "allow",
\t\t"read": {
\t\t\t".env": "deny"
\t\t},
\t\t"edit": {
\t\t\t".env": "deny"
\t\t}
\t}
}
`;

Deno.test("diffOpencodeText finds missing bash entries", () => {
  const source: SourceConfig = {
    permissions: {
      bash: { "ls *": "allow", "pnpm test *": "allow" },
      scalars: { skill: "allow" },
    },
  };
  const diff = diffOpencodeText(OPENCODE_FIXTURE, source, ALL_CHANNELS);
  assertEquals(diff.conflicts, []);
  assertEquals(diff.missing.length, 1);
  assertObjectMatch(diff.missing[0], {
    channel: "bash",
    pattern: "pnpm test *",
    mode: "allow",
  });
});

Deno.test("diffOpencodeText flags mode mismatch as conflict", () => {
  const source: SourceConfig = {
    permissions: { bash: { "rm -rf *": "allow" } },
  };
  const diff = diffOpencodeText(OPENCODE_FIXTURE, source, ALL_CHANNELS);
  assertEquals(diff.missing, []);
  assertEquals(diff.conflicts.length, 1);
  assertObjectMatch(diff.conflicts[0], {
    channel: "bash",
    pattern: "rm -rf *",
    sourceMode: "allow",
    targetMode: "deny",
  });
});

Deno.test("diffOpencodeText handles scalar capability presence", () => {
  const source: SourceConfig = {
    permissions: { scalars: { skill: "allow", webfetch: "allow" } },
  };
  const diff = diffOpencodeText(OPENCODE_FIXTURE, source, ALL_CHANNELS);
  assertEquals(diff.conflicts, []);
  assertEquals(diff.missing.length, 1);
  assertObjectMatch(diff.missing[0], {
    channel: "scalars",
    pattern: "webfetch",
    mode: "allow",
  });
});

// ── OpenCode adapter: apply ────────────────────────────────────────

Deno.test("applyOpencodeText rewrites a channel block additively, sorted", () => {
  const diff = {
    target: "opencode",
    missing: [
      {
        channel: "bash" as Channel,
        pattern: "pnpm test *",
        mode: "allow" as Mode,
      },
      { channel: "bash" as Channel, pattern: "dd *", mode: "deny" as Mode },
    ],
    conflicts: [],
  };
  const out = applyOpencodeText(OPENCODE_FIXTURE, diff);
  // New entries present.
  assert(out.includes(`"pnpm test *": "allow"`));
  assert(out.includes(`"dd *": "deny"`));
  // Existing entries preserved.
  assert(out.includes(`"ls *": "allow"`));
  assert(out.includes(`"rm -rf *": "deny"`));
  assert(out.includes(`"*": "ask"`));
  // Skill scalar untouched.
  assert(out.includes(`"skill": "allow"`));
  // Allow group precedes deny group within the bash block.
  const lsIdx = out.indexOf(`"ls *"`);
  const rmIdx = out.indexOf(`"rm -rf *"`);
  assert(lsIdx < rmIdx, "allow entries should come before deny entries");
});

Deno.test("applyOpencodeText inserts a new scalar key under permission", () => {
  const diff = {
    target: "opencode",
    missing: [
      {
        channel: "scalars" as Channel,
        pattern: "webfetch",
        mode: "allow" as Mode,
      },
    ],
    conflicts: [],
  };
  const out = applyOpencodeText(OPENCODE_FIXTURE, diff);
  assert(out.includes(`"webfetch": "allow"`));
  // Existing scalar untouched.
  assert(out.includes(`"skill": "allow"`));
});
