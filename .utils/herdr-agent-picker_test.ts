import { assertEquals, assertStringIncludes } from "@std/assert";
import { dirname, fromFileUrl, join } from "@std/path";

const utilsDir = dirname(fromFileUrl(import.meta.url));
const herdrConfigDir = join(
  utilsDir,
  "..",
  "private_dot_config",
  "herdr",
);

interface PickerRun {
  code: number;
  herdrCalls: string;
  gumCalls: string;
  gumArguments: string;
  stderr: string;
}

async function writeExecutable(path: string, contents: string): Promise<void> {
  await Deno.writeTextFile(path, contents);
  await Deno.chmod(path, 0o755);
}

async function runLauncher(
  launcher: string,
  selections: Record<string, string>,
  cancelAt?: string,
): Promise<PickerRun> {
  const tempDir = await Deno.makeTempDir();
  const herdrLog = join(tempDir, "herdr.log");
  const gumLog = join(tempDir, "gum.log");
  const gumArgumentsLog = join(tempDir, "gum-arguments.log");

  try {
    await Deno.copyFile(
      join(herdrConfigDir, "agent-picker.sh"),
      join(tempDir, "agent-picker.sh"),
    );
    for (
      const name of [
        "pick-agent",
        "pick-codex-agent",
        "pick-claude-agent",
        "pick-opencode-agent",
        "open-nvim",
      ]
    ) {
      await Deno.copyFile(
        join(herdrConfigDir, `executable_${name}`),
        join(tempDir, name),
      );
      await Deno.chmod(join(tempDir, name), 0o755);
    }

    await writeExecutable(
      join(tempDir, "gum"),
      `#!/bin/sh
header=
while [ "$#" -gt 0 ]; do
  if [ "$1" = "--header" ]; then
    header=$2
    break
  fi
  shift
done
printf '%s\n' "$header" >> "$GUM_TEST_LOG"
printf '%s\n' "$@" >> "$GUM_ARGUMENTS_TEST_LOG"
if [ "$header" = "${cancelAt ?? ""}" ]; then
  exit 130
fi
case "$header" in
  "agent") printf '%s\n' "${selections.agent ?? "codex"}" ;;
  "model") printf '%s\n' "${selections.model ?? "default"}" ;;
  "effort") printf '%s\n' "${selections.effort ?? "default"}" ;;
  *) exit 2 ;;
esac
`,
    );

    await writeExecutable(
      join(tempDir, "herdr"),
      `#!/bin/sh
printf 'CALL' >> "$HERDR_TEST_LOG"
for arg in "$@"; do
  printf '\t%s' "$arg" >> "$HERDR_TEST_LOG"
done
printf '\n' >> "$HERDR_TEST_LOG"
if [ "$1" = "tab" ] && [ "$2" = "create" ]; then
  printf '%s\n' '{"result":{"root_pane":{"pane_id":"w1:p9"}}}'
fi
`,
    );

    const command = new Deno.Command("sh", {
      args: [join(tempDir, launcher.replace("executable_", ""))],
      env: {
        GUM_TEST_LOG: gumLog,
        GUM_ARGUMENTS_TEST_LOG: gumArgumentsLog,
        HERDR_TEST_LOG: herdrLog,
        HERDR_BIN_PATH: join(tempDir, "herdr"),
        HERDR_ACTIVE_WORKSPACE_ID: "w1",
        HERDR_ACTIVE_PANE_CWD: "/project with spaces",
        PATH: `${tempDir}:/usr/bin:/bin`,
      },
      stdout: "piped",
      stderr: "piped",
    });
    const output = await command.output();

    return {
      code: output.code,
      herdrCalls: await Deno.readTextFile(herdrLog).catch(() => ""),
      gumCalls: await Deno.readTextFile(gumLog).catch(() => ""),
      gumArguments: await Deno.readTextFile(gumArgumentsLog).catch(() => ""),
      stderr: new TextDecoder().decode(output.stderr),
    };
  } finally {
    await Deno.remove(tempDir, { recursive: true });
  }
}

Deno.test("Codex picker creates a focused tab and submits the selected model", async () => {
  const result = await runLauncher("executable_pick-agent", {
    agent: "codex",
    model: "gpt-5.6-terra",
    effort: "high",
  });

  assertEquals(result.code, 0, result.stderr);
  assertEquals(result.gumCalls, "agent\nmodel\neffort\n");
  assertStringIncludes(
    result.herdrCalls,
    "CALL\ttab\tcreate\t--workspace\tw1\t--cwd\t/project with spaces\t--focus",
  );
  assertStringIncludes(
    result.herdrCalls,
    "CALL\tpane\trun\tw1:p9\tcodex -m gpt-5.6-terra -c 'model_reasoning_effort=\"high\"'",
  );
  assertEquals(result.herdrCalls.includes("\tagent\tstart\t"), false);
});

Deno.test("Codex picker orders default, Sol, Luna, then Terra", async () => {
  const result = await runLauncher("executable_pick-codex-agent", {
    model: "default",
    effort: "default",
  });

  assertEquals(result.code, 0, result.stderr);
  assertStringIncludes(
    result.gumArguments,
    "default\ngpt-5.6-sol\ngpt-5.6-luna\ngpt-5.6-terra\n",
  );
});

Deno.test("tab create leaves naming to the heraldry plugin", async () => {
  const result = await runLauncher("executable_pick-claude-agent", {
    model: "opus",
    effort: "high",
  });

  assertEquals(result.code, 0, result.stderr);
  assertEquals(result.herdrCalls.includes("--label"), false);
});

Deno.test("Claude picker offers Haiku and passes its native effort flag", async () => {
  const result = await runLauncher("executable_pick-agent", {
    agent: "claude",
    model: "haiku",
    effort: "xhigh",
  });

  assertEquals(result.code, 0, result.stderr);
  assertEquals(result.gumCalls, "agent\nmodel\neffort\n");
  assertStringIncludes(
    result.herdrCalls,
    "CALL\tpane\trun\tw1:p9\tclaude --model haiku --effort xhigh",
  );
});

Deno.test("OpenCode picker launches the v2 binary with a Zen model", async () => {
  const result = await runLauncher("executable_pick-agent", {
    agent: "opencode",
    model: "opencode/deepseek-v4-flash",
  });

  assertEquals(result.code, 0, result.stderr);
  assertEquals(result.gumCalls, "agent\nmodel\n");
  assertStringIncludes(
    result.herdrCalls,
    "CALL\tpane\trun\tw1:p9\topencode2 mini -m opencode/deepseek-v4-flash",
  );
});

Deno.test("configured defaults launch an agent without native overrides", async () => {
  const result = await runLauncher("executable_pick-codex-agent", {
    model: "default",
    effort: "default",
  });

  assertEquals(result.code, 0, result.stderr);
  const paneRunCall = result.herdrCalls.trim().split("\n")[1];
  assertEquals(paneRunCall, "CALL\tpane\trun\tw1:p9\tcodex");
});

Deno.test("cancelling a picker leaves the Herdr layout unchanged", async () => {
  const result = await runLauncher(
    "executable_pick-agent",
    { agent: "codex" },
    "agent",
  );

  assertEquals(result.code, 130);
  assertEquals(result.herdrCalls, "");
});

Deno.test("nvim launcher opens a focused tab in the active pane directory", async () => {
  const result = await runLauncher("executable_open-nvim", {});

  assertEquals(result.code, 0, result.stderr);
  assertEquals(
    result.herdrCalls,
    "CALL\ttab\tcreate\t--workspace\tw1\t--cwd\t/project with spaces\t--focus\n" +
      "CALL\tpane\trun\tw1:p9\tnvim\n",
  );
});
