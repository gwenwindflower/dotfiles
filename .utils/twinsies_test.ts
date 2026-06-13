import { assert, assertEquals, assertObjectMatch } from "@std/assert";
import { parse as parseJsonc } from "@std/jsonc";
import {
  applyClaudeText,
  applyOpencodeText,
  type Channel,
  CHANNELS,
  decodeClaude,
  diffClaudeText,
  diffOpencodeText,
  encodeClaude,
  findObjectBlock,
  loadSource,
  type Mode,
  sortEntries,
  type SourceConfig,
} from "./twinsies.ts";

const ALL_CHANNELS = new Set<Channel>(CHANNELS);

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

[permissions.edit]
".env" = "deny"
`,
    );
    const source = await loadSource(tmp);
    assertEquals(source.permissions.bash, {
      "pnpm test *": "allow",
      "rm -rf *": "deny",
    });
    assertEquals(source.permissions.edit, { ".env": "deny" });
  } finally {
    await Deno.remove(tmp);
  }
});

Deno.test("loadSource ignores out-of-scope channels (read, scalars)", async () => {
  const tmp = await Deno.makeTempFile({ suffix: ".toml" });
  try {
    await Deno.writeTextFile(
      tmp,
      `[permissions.bash]
"ls *" = "allow"

[permissions.read]
".env" = "deny"

[permissions.scalars]
skill = "allow"
`,
    );
    const source = await loadSource(tmp);
    assertEquals(source.permissions.bash, { "ls *": "allow" });
    assertEquals(Object.keys(source.permissions).sort(), ["bash"]);
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
    assertEquals(source.permissions.edit, undefined);
  } finally {
    await Deno.remove(tmp);
  }
});

// ── encodeClaude / decodeClaude ────────────────────────────────────

Deno.test("encodeClaude wraps channel patterns", () => {
  assertEquals(encodeClaude("bash", "ls *"), "Bash(ls *)");
  assertEquals(encodeClaude("edit", ".env"), "Edit(.env)");
});

Deno.test("decodeClaude extracts channel and pattern from owned wires", () => {
  assertEquals(decodeClaude("Bash(ls *)"), { channel: "bash", pattern: "ls *" });
  assertEquals(decodeClaude("Edit(.env)"), { channel: "edit", pattern: ".env" });
});

Deno.test("decodeClaude returns null for unowned wires", () => {
  assertEquals(decodeClaude("Skill"), null);
  assertEquals(decodeClaude("WebFetch(domain:example.com)"), null);
  assertEquals(decodeClaude("mcp__foo__bar"), null);
  // Read is intentionally not twinsies-owned — Claude sandbox-specific.
  assertEquals(decodeClaude("Read(~/foo/**)"), null);
  assertEquals(decodeClaude("Read(.env)"), null);
});

Deno.test("decodeClaude handles patterns containing parens", () => {
  assertEquals(
    decodeClaude("Bash(awk '{ print $1 }')"),
    { channel: "bash", pattern: "awk '{ print $1 }'" },
  );
});

// ── Claude adapter: diff ───────────────────────────────────────────

const CLAUDE_FIXTURE = JSON.stringify(
  {
    permissions: {
      allow: [
        "Bash(ls *)",
        "Read(~/foo/**)",
        "Skill",
        "WebFetch(domain:example.com)",
      ],
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
      edit: { ".env": "deny" },
    },
  };
  const diff = diffClaudeText(CLAUDE_FIXTURE, source, ALL_CHANNELS);
  assertEquals(diff.conflicts, []);
  assertEquals(diff.extras, []);
  assertEquals(diff.missing.length, 1);
  assertObjectMatch(diff.missing[0], {
    channel: "bash",
    pattern: "pnpm test *",
    mode: "allow",
  });
});

Deno.test("diffClaudeText flags same-pattern-different-mode as conflict", () => {
  const source: SourceConfig = {
    permissions: { bash: { "rm -rf *": "allow" } },
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

Deno.test("diffClaudeText reports target-only owned entries as extras", () => {
  const source: SourceConfig = {
    permissions: { bash: { "ls *": "allow" } },
  };
  const diff = diffClaudeText(CLAUDE_FIXTURE, source, ALL_CHANNELS);
  // Only Bash(...) and Edit(...) extras surface. Read(...) is unowned.
  const extras = diff.extras.map((e) => `${e.channel}:${e.pattern}=${e.mode}`)
    .sort();
  assertEquals(extras, [
    "bash:rm -rf *=deny",
    "edit:.env=deny",
  ]);
});

Deno.test("diffClaudeText ignores unowned wires (Skill, WebFetch, Read, mcp__*)", () => {
  const source: SourceConfig = { permissions: {} };
  const diff = diffClaudeText(CLAUDE_FIXTURE, source, ALL_CHANNELS);
  for (const e of diff.extras) {
    assert(
      !["Skill", "WebFetch", "Read"].some((p) => e.pattern.startsWith(p)),
      `unowned entry leaked into extras: ${e.pattern}`,
    );
  }
});

// ── Claude adapter: apply ──────────────────────────────────────────

Deno.test("applyClaudeText reconciles to source, sorts, dedupes", () => {
  const source: SourceConfig = {
    permissions: {
      bash: { "ls *": "allow", "pnpm test *": "allow", "dd *": "deny" },
      edit: {},
    },
  };
  const out = applyClaudeText(CLAUDE_FIXTURE, source);
  const data = JSON.parse(out);
  // Missing added.
  assert(data.permissions.allow.includes("Bash(pnpm test *)"));
  assert(data.permissions.deny.includes("Bash(dd *)"));
  // Existing owned entries that aren't in source are removed.
  assert(!data.permissions.deny.includes("Bash(rm -rf *)"));
  assert(!data.permissions.deny.includes("Edit(.env)"));
  // Unowned entries preserved — including Read(...) sandbox roots.
  assert(data.permissions.allow.includes("Skill"));
  assert(data.permissions.allow.includes("WebFetch(domain:example.com)"));
  assert(data.permissions.allow.includes("Read(~/foo/**)"));
  assert(data.permissions.deny.includes("Read(.env)"));
  // Each bucket sorted, no dupes.
  for (const m of ["allow", "ask", "deny"] as const) {
    const arr = data.permissions[m] as string[];
    assertEquals([...arr].sort(), arr);
    assertEquals(new Set(arr).size, arr.length);
  }
});

Deno.test("applyClaudeText resolves mode conflicts source-wins", () => {
  // Target has Bash(rm -rf *) under deny; source says allow.
  const source: SourceConfig = {
    permissions: { bash: { "rm -rf *": "allow" } },
  };
  const out = applyClaudeText(CLAUDE_FIXTURE, source);
  const data = JSON.parse(out);
  assert(data.permissions.allow.includes("Bash(rm -rf *)"));
  assert(!data.permissions.deny.includes("Bash(rm -rf *)"));
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
      bash: { "ls *": "allow", "pnpm test *": "allow", "rm -rf *": "deny" },
      edit: { ".env": "deny" },
    },
  };
  const diff = diffOpencodeText(OPENCODE_FIXTURE, source, ALL_CHANNELS);
  assertEquals(diff.conflicts, []);
  assertEquals(diff.extras, []);
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

Deno.test("diffOpencodeText reports target-only entries as extras", () => {
  const source: SourceConfig = {
    permissions: { bash: { "ls *": "allow" } },
  };
  const diff = diffOpencodeText(OPENCODE_FIXTURE, source, ALL_CHANNELS);
  // The catch-all "*" is preserved, NOT an extra. The fixture's `read` block
  // is unowned so its entries never surface.
  const extras = diff.extras.map((e) => `${e.channel}:${e.pattern}=${e.mode}`)
    .sort();
  assertEquals(extras, [
    "bash:rm -rf *=deny",
    "edit:.env=deny",
  ]);
});

Deno.test("diffOpencodeText preserves catch-all '*' in bash (not an extra)", () => {
  const source: SourceConfig = {
    permissions: {
      bash: { "ls *": "allow", "rm -rf *": "deny" },
      edit: { ".env": "deny" },
    },
  };
  const diff = diffOpencodeText(OPENCODE_FIXTURE, source, ALL_CHANNELS);
  assertEquals(diff.extras, []);
  assertEquals(diff.missing, []);
  assertEquals(diff.conflicts, []);
});

// ── OpenCode adapter: apply ────────────────────────────────────────

Deno.test("applyOpencodeText reconciles bash to source and preserves catch-all", () => {
  const source: SourceConfig = {
    permissions: {
      bash: {
        "ls *": "allow",
        "pnpm test *": "allow",
        "dd *": "deny",
      },
      edit: { ".env": "deny" },
    },
  };
  const out = applyOpencodeText(OPENCODE_FIXTURE, source);
  // Added.
  assert(out.includes(`"pnpm test *": "allow"`));
  assert(out.includes(`"dd *": "deny"`));
  // Preserved existing source-tracked entry.
  assert(out.includes(`"ls *": "allow"`));
  // Removed target-only entry (rm -rf was not in this source).
  assert(!out.includes(`"rm -rf *": "deny"`));
  // Catch-all preserved.
  assert(out.includes(`"*": "ask"`));
  // Sibling scalar untouched.
  assert(out.includes(`"skill": "allow"`));
  // Catch-all "*" should sort to top of ask group (no other ask entries here).
  const starIdx = out.indexOf(`"*": "ask"`);
  const lsIdx = out.indexOf(`"ls *": "allow"`);
  assert(starIdx < lsIdx, "ask group should come before allow group");
});

Deno.test("applyOpencodeText removes target-only entries in owned channels", () => {
  const source: SourceConfig = {
    permissions: {
      bash: { "ls *": "allow" },
      edit: {}, // empty — target's `.env` deny should vanish from edit
    },
  };
  const out = applyOpencodeText(OPENCODE_FIXTURE, source);
  assert(!out.includes(`"rm -rf *": "deny"`));
  const data = parseJsonc(out) as { permission: Record<string, unknown> };
  assertEquals(data.permission.edit, {});
  // `read` block is unowned — left exactly as it was in the fixture.
  assertEquals(data.permission.read, { ".env": "deny" });
});

Deno.test("applyOpencodeText resolves mode conflicts source-wins", () => {
  const source: SourceConfig = {
    permissions: {
      bash: { "ls *": "allow", "rm -rf *": "allow" }, // target has rm -rf as deny
      edit: { ".env": "deny" },
    },
  };
  const out = applyOpencodeText(OPENCODE_FIXTURE, source);
  // The deny version is replaced by the allow version — only one occurrence.
  const matches = out.match(/"rm -rf \*": "(allow|deny)"/g) ?? [];
  assertEquals(matches, [`"rm -rf *": "allow"`]);
});
