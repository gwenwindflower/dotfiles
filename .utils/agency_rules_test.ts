import { assertEquals } from "@std/assert";
import { join } from "@std/path";
import {
  execpolicyArgs,
  parseDecision,
  parseProbes,
  repoRoot,
  ruleFilePaths,
} from "./agency.ts";
import { codex } from "./agency_test_support.ts";

const root = repoRoot();
const probes = parseProbes(
  Deno.readTextFileSync(join(root, ".utils", "agency.toml")),
);
const ruleFiles = ruleFilePaths(root);

for (const c of probes.rule) {
  Deno.test(`rule: ${c.cmd} → ${c.expect}`, async () => {
    const out = await codex(execpolicyArgs(ruleFiles, c.cmd));
    assertEquals(out.code, 0, `codex execpolicy check failed:\n${out.stderr}`);
    assertEquals(parseDecision(out.stdout), c.expect);
  });
}
