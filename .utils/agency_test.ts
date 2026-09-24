import { assertEquals, assertThrows } from "@std/assert";
import { join } from "@std/path";
import {
  defaultProfile,
  execpolicyArgs,
  isNestedSandboxFailure,
  parseDecision,
  parseProbes,
  repoRoot,
  ruleFilePaths,
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
expect = "ok"
cmd = "touch x"

[[rule]]
cmd = "git status"
expect = "allow"
`);
  assertEquals(probes.sandbox, [{
    name: "cache is writable",
    expect: "ok",
    cmd: "touch x",
  }]);
  assertEquals(probes.rule, [{ cmd: "git status", expect: "allow" }]);
});

Deno.test("parseProbes names the table and field for a missing value", () => {
  assertThrows(
    () => parseProbes(`[[sandbox]]\nname = "x"\nexpect = "ok"\n`),
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

// ── Repo probes ────────────────────────────────────────────────────

const root = repoRoot();
const probes = parseProbes(
  Deno.readTextFileSync(join(root, ".utils", "agency.toml")),
);
const ruleFiles = ruleFilePaths(root);
const configPath = join(root, "symsources", "codex", "config.toml");
const profile = defaultProfile(Deno.readTextFileSync(configPath));
const requireHost = Deno.env.get("AGENCY_REQUIRE_HOST") === "1";
const decoder = new TextDecoder();

async function codex(args: string[], env: Record<string, string> = {}) {
  const out = await new Deno.Command("codex", {
    args,
    env,
    cwd: root,
    stdout: "piped",
    stderr: "piped",
  }).output();
  return {
    code: out.code,
    stdout: decoder.decode(out.stdout),
    stderr: decoder.decode(out.stderr),
  };
}

for (const c of probes.rule) {
  Deno.test(`rule: ${c.cmd} → ${c.expect}`, async () => {
    const out = await codex(execpolicyArgs(ruleFiles, c.cmd));
    assertEquals(out.code, 0, `codex execpolicy check failed:\n${out.stderr}`);
    assertEquals(parseDecision(out.stdout), c.expect);
  });
}

// Sandbox probes use a temp CODEX_HOME holding this repo's config, so a worktree
// probes its own config rather than the deployed one.
const codexHome = await Deno.makeTempDir({ prefix: "agency-codex-" });
await Deno.copyFile(configPath, join(codexHome, "config.toml"));
const sandboxEnv = { CODEX_HOME: codexHome };
const nested = isNestedSandboxFailure(
  (await codex(sandboxArgs(profile, "true"), sandboxEnv)).stderr,
);

if (nested && !requireHost) {
  console.warn(
    "agency: sandbox probes skipped; Seatbelt cannot nest inside this shell's sandbox. " +
      "Run `agency` from a host terminal to run them.",
  );
}

for (const p of probes.sandbox) {
  Deno.test({
    name: `sandbox (${profile}): ${p.name} → ${p.expect}`,
    ignore: nested && !requireHost,
    fn: async () => {
      if (nested) {
        throw new Error(
          "Seatbelt cannot nest inside this shell's sandbox; run agency from a host terminal",
        );
      }
      const out = await codex(sandboxArgs(profile, p.cmd), sandboxEnv);
      const outcome = out.code === 0 ? "ok" : "deny";
      const detail = out.stderr.split("\n").filter((l) =>
        l && !l.includes("PATH aliases")
      ).slice(0, 3).join("\n");
      assertEquals(outcome, p.expect, `exit ${out.code}: ${p.cmd}\n${detail}`);
    },
  });
}

globalThis.addEventListener(
  "unload",
  () => Deno.removeSync(codexHome, { recursive: true }),
);
