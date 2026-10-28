import { assertEquals, assertThrows } from "@std/assert";
import {
  defaultProfile,
  execpolicyArgs,
  isNestedSandboxFailure,
  parseDecision,
  parseProbes,
  sandboxArgs,
  tokenize,
} from "./agency.ts";

// ── Pure helpers ───────────────────────────────────────────────────

Deno.test("tokenize splits words and keeps quoted strings whole", () => {
  assertEquals(tokenize(`git commit -m "fix bug" --author 'A B'`), [
    "git",
    "commit",
    "-m",
    "fix bug",
    "--author",
    "A B",
  ]);
});

Deno.test("tokenize keeps an empty quoted argument", () => {
  assertEquals(tokenize(`printf ''`), ["printf", ""]);
});

Deno.test("tokenize rejects an unterminated quote", () => {
  assertThrows(() => tokenize(`echo "oops`), Error, "unterminated");
});

Deno.test("parseProbes reads sandbox and rule tables", () => {
  const probes = parseProbes(`
[[sandbox]]
name = "cache is writable"
group = "writes"
expect = "ok"
cmd = "touch x"

[[rule]]
cmd = "git status"
expect = "allow"
`);
  assertEquals(probes.sandbox, [{
    name: "cache is writable",
    group: "writes",
    expect: "ok",
    cmd: "touch x",
  }]);
  assertEquals(probes.rule, [{ cmd: "git status", expect: "allow" }]);
});

Deno.test("parseProbes names the table and field for a missing value", () => {
  assertThrows(
    () =>
      parseProbes(`[[sandbox]]\nname = "x"\ngroup = "reads"\nexpect = "ok"\n`),
    Error,
    `[[sandbox]] #1: missing string field "cmd"`,
  );
});

Deno.test("parseProbes rejects an unknown rule decision", () => {
  assertThrows(
    () => parseProbes(`[[rule]]\ncmd = "git push"\nexpect = "ask"\n`),
    Error,
    `[[rule]] #1: expect must be one of`,
  );
});

Deno.test("parseProbes requires a sandbox group", () => {
  assertThrows(
    () => parseProbes(`[[sandbox]]\nname = "x"\nexpect = "ok"\ncmd = "true"`),
    Error,
    'missing string field "group"',
  );
});

Deno.test("parseProbes rejects an unknown sandbox group", () => {
  assertThrows(
    () =>
      parseProbes(
        `[[sandbox]]\nname = "x"\ngroup = "typo"\nexpect = "ok"\ncmd = "true"`,
      ),
    Error,
    "group must be one of reads, writes, network, integrations",
  );
});

Deno.test("parseDecision maps a missing decision to none", () => {
  assertEquals(parseDecision(`{"matchedRules":[]}`), "none");
  assertEquals(parseDecision(`{"decision":"prompt"}`), "prompt");
});

Deno.test("execpolicyArgs passes every rule file and the tokenized command", () => {
  assertEquals(execpolicyArgs(["a.rules", "b.rules"], `git commit -m "x y"`), [
    "execpolicy",
    "check",
    "-r",
    "a.rules",
    "-r",
    "b.rules",
    "git",
    "commit",
    "-m",
    "x y",
  ]);
});

Deno.test("sandboxArgs runs the probe with bash under the named profile", () => {
  assertEquals(sandboxArgs("dev", "ls ~"), [
    "sandbox",
    "-P",
    "dev",
    "--",
    "bash",
    "-c",
    "ls ~",
  ]);
});

Deno.test("defaultProfile reads default_permissions", () => {
  assertEquals(
    defaultProfile(
      `default_permissions = "dev"\n[permissions.dev]\nextends = ":workspace"\n`,
    ),
    "dev",
  );
  assertThrows(
    () => defaultProfile(`sandbox_mode = "workspace-write"\n`),
    Error,
    "no default_permissions",
  );
});

Deno.test("isNestedSandboxFailure recognizes Seatbelt refusing to nest", () => {
  assertEquals(
    isNestedSandboxFailure(
      "sandbox-exec: sandbox_apply: Operation not permitted",
    ),
    true,
  );
  assertEquals(
    isNestedSandboxFailure("ls: /x: Operation not permitted"),
    false,
  );
});
