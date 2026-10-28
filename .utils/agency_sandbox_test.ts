import { assertEquals } from "@std/assert";
import { join } from "@std/path";
import {
  defaultProfile,
  isNestedSandboxFailure,
  parseProbes,
  repoRoot,
  sandboxArgs,
} from "./agency.ts";
import { codex } from "./agency_test_support.ts";

const root = repoRoot();
const probes = parseProbes(
  Deno.readTextFileSync(join(root, ".utils", "agency.toml")),
);
const configPath = join(root, "symsources", "codex", "config.toml");
const profile = defaultProfile(Deno.readTextFileSync(configPath));
const requireHost = Deno.env.get("AGENCY_REQUIRE_HOST") === "1";

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
    name: `sandbox (${profile}) ${p.group}: ${p.name} → ${p.expect}`,
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
