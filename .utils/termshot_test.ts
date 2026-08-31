import { assertEquals, assertRejects, assertStringIncludes } from "@std/assert";
import {
  addGradientBackground,
  buildResvgArgs,
  buildTermframeArgs,
  capturePaths,
  captureTerminal,
  type CommandRunner,
  DEFAULT_BACKGROUND,
} from "./termshot.ts";

Deno.test("capturePaths derives safe output names from commands", () => {
  assertEquals(capturePaths(undefined, "/usr/local/bin/gh", false), {
    png: "gh.png",
    svg: "gh.svg",
  });
  assertEquals(capturePaths("tmp/release.png", "gh", false), {
    png: "tmp/release.png",
    svg: "tmp/release.svg",
  });
  assertEquals(capturePaths("tmp/release.svg", "gh", true), {
    png: undefined,
    svg: "tmp/release.svg",
  });
});

Deno.test("addGradientBackground preserves the established visual defaults", () => {
  const output = addGradientBackground(
    '<svg width="100" height="50"><g id="capture"/></svg>',
    DEFAULT_BACKGROUND,
  );

  assertStringIncludes(output, '<defs id="termshot-bg">');
  assertStringIncludes(output, `stop-color="${DEFAULT_BACKGROUND.from}"`);
  assertStringIncludes(output, `stop-color="${DEFAULT_BACKGROUND.mid}"`);
  assertStringIncludes(output, `stop-color="${DEFAULT_BACKGROUND.to}"`);
  assertStringIncludes(output, `rx="${DEFAULT_BACKGROUND.radius}"`);
  assertStringIncludes(output, `opacity="${DEFAULT_BACKGROUND.grain}"`);
  assertStringIncludes(output, '<g id="capture"/>');
});

Deno.test("addGradientBackground applies gradient direction and custom colors", () => {
  const output = addGradientBackground('<svg viewBox="0 0 10 10"></svg>', {
    from: "#000",
    mid: "#777777",
    to: "#ffffffff",
    angle: 0,
    radius: 4,
    grain: 0.2,
  });

  assertStringIncludes(
    output,
    'x1="0.000" y1="0.500" x2="1.000" y2="0.500"',
  );
  assertStringIncludes(output, 'stop-color="#000"');
});

Deno.test("addGradientBackground rejects invalid and processed SVGs", () => {
  assertRejects(
    async () => addGradientBackground("not svg", DEFAULT_BACKGROUND),
    Error,
    "missing root <svg> tag",
  );
  assertRejects(
    async () =>
      addGradientBackground(
        '<svg><defs id="termshot-bg"></defs></svg>',
        DEFAULT_BACKGROUND,
      ),
    Error,
    "already has a termshot background",
  );
});

Deno.test("buildTermframeArgs passes only requested config overrides", () => {
  assertEquals(
    buildTermframeArgs({
      svgPath: "demo.svg",
      command: ["gh", "pr", "list"],
      title: "Pull requests",
      theme: "dracula",
      mode: "dark",
      padding: 1.8,
      width: "90..130",
      height: "20",
      timeout: 12,
      showCommand: true,
    }),
    [
      "--output",
      "demo.svg",
      "--title",
      "Pull requests",
      "--theme",
      "dracula",
      "--mode",
      "dark",
      "--padding",
      "1.8",
      "--width",
      "90..130",
      "--height",
      "20",
      "--timeout",
      "12",
      "--show-command",
      "--",
      "gh",
      "pr",
      "list",
    ],
  );
});

Deno.test("buildResvgArgs uses the local font directory and raster scale", () => {
  assertEquals(buildResvgArgs("demo.svg", "demo.png", "/fonts", 3), [
    "--use-fonts-dir",
    "/fonts",
    "--zoom",
    "3",
    "demo.svg",
    "demo.png",
  ]);
});

Deno.test("captureTerminal runs termframe then resvg and removes transient SVG", async () => {
  const calls: Array<{ command: string; args: string[] }> = [];
  const writes: Array<{ path: string; content: string }> = [];
  const removals: string[] = [];
  const runner: CommandRunner = async (command, args) => {
    calls.push({ command, args });
    return { code: 0 };
  };

  await captureTerminal(
    {
      command: ["lsd", "docs"],
      output: "lsd-docs.png",
      keepSvg: false,
      svgOnly: false,
      background: DEFAULT_BACKGROUND,
      fontDirectory: "/fonts",
      zoom: 2,
    },
    {
      runner,
      readTextFile: async () => '<svg width="10" height="10"></svg>',
      writeTextFile: async (path, content) => {
        writes.push({ path, content });
      },
      remove: async (path) => {
        removals.push(path);
      },
    },
  );

  assertEquals(calls.map(({ command }) => command), ["termframe", "resvg"]);
  assertEquals(writes[0].path, "lsd-docs.svg");
  assertStringIncludes(writes[0].content, 'id="termshot-bg"');
  assertEquals(removals, ["lsd-docs.svg"]);
});

Deno.test("captureTerminal stops when termframe fails", async () => {
  const runner: CommandRunner = async () => ({ code: 9 });

  await assertRejects(
    () =>
      captureTerminal(
        {
          command: ["false"],
          keepSvg: true,
          svgOnly: false,
          background: DEFAULT_BACKGROUND,
          fontDirectory: "/fonts",
          zoom: 2,
        },
        {
          runner,
          readTextFile: async () => "",
          writeTextFile: async () => {},
          remove: async () => {},
        },
      ),
    Error,
    "termframe exited with status 9",
  );
});
