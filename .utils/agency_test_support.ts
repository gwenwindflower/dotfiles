import { repoRoot } from "./agency.ts";

const root = repoRoot();
const decoder = new TextDecoder();

export async function codex(args: string[], env: Record<string, string> = {}) {
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
