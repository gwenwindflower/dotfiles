import {
  assertEquals,
  assertRejects,
  assertStringIncludes,
  assertThrows,
} from "@std/assert";
import {
  addGradientBackground,
  buildResvgArgs,
  buildTermframeArgs,
  capturePaths,
  captureTerminal,
  type CommandRunner,
  DEFAULT_BACKGROUND,
  defaultEmojiFontFile,
  isolateBoxDrawing,
  selectRasterFontFiles,
  setTerminalFontStack,
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

Deno.test("buildResvgArgs isolates local fonts and sets raster scale", () => {
  assertEquals(
    buildResvgArgs("demo.svg", "demo.png", [
      "/fonts/EllographCFFixedPitch-Thin.otf",
      "/fonts/SymbolsNerdFontMono-Regular.ttf",
      "/fonts/IBMPlexMono-Regular.otf",
    ], 3),
    [
      "--skip-system-fonts",
      "--use-font-file",
      "/fonts/EllographCFFixedPitch-Thin.otf",
      "--use-font-file",
      "/fonts/SymbolsNerdFontMono-Regular.ttf",
      "--use-font-file",
      "/fonts/IBMPlexMono-Regular.otf",
      "--zoom",
      "3",
      "demo.svg",
      "demo.png",
    ],
  );
});

Deno.test("selectRasterFontFiles keeps only the three rendering families", () => {
  assertEquals(
    selectRasterFontFiles("/fonts", [
      "Arial.ttf",
      "IBMPlexMono-Regular.otf",
      "EllographCFFixedPitch-Regular.otf",
      "SymbolsNerdFontMono-Regular.ttf",
      "Noto-COLRv1.ttf",
      "MonaspaceNeon-Regular.otf",
      "EllographCFFixedPitch-Thin.otf",
    ]),
    [
      "/fonts/EllographCFFixedPitch-Regular.otf",
      "/fonts/EllographCFFixedPitch-Thin.otf",
      "/fonts/IBMPlexMono-Regular.otf",
      "/fonts/Noto-COLRv1.ttf",
      "/fonts/SymbolsNerdFontMono-Regular.ttf",
    ],
  );
});

Deno.test("selectRasterFontFiles requires every rendering family", () => {
  assertRejects(
    async () =>
      selectRasterFontFiles("/fonts", [
        "EllographCFFixedPitch-Regular.otf",
        "IBMPlexMono-Regular.otf",
      ]),
    Error,
    "Symbols Nerd Font Mono",
  );
});

Deno.test("setTerminalFontStack leaves the window title stack alone", () => {
  const source = [
    '<svg><text font-family="system-ui, sans-serif">Title</text>',
    '<svg class="terminal" font-family="Ellograph CF Fixed Pitch, JetBrains Mono, monospace">',
    "</svg></svg>",
  ].join("");
  const output = setTerminalFontStack(source);

  assertStringIncludes(output, 'font-family="system-ui, sans-serif"');
  assertStringIncludes(
    output,
    'font-family="Ellograph CF Fixed Pitch, Symbols Nerd Font Mono, IBM Plex Mono, Apple Color Emoji, Noto Color Emoji"',
  );
});

function terminalRow(texts: string): string {
  return `<svg height="18.2" overflow="hidden" width="504" y="36.4">\n${texts}\n</svg>`;
}

function textElements(source: string): string[] {
  return source.match(/<text\b[\s\S]*?<\/text>/g) ?? [];
}

Deno.test("isolateBoxDrawing keeps labels out of text elements with box glyphs", () => {
  const output = isolateBoxDrawing(terminalRow(
    '<text xml:space="preserve" y="1.01em"><tspan fill="#c6d0f5">│ </tspan><tspan>  </tspan><tspan fill="#c6d0f5">└── </tspan><tspan fill="#c6d0f5">git </tspan></text>',
  ));

  for (const text of textElements(output)) {
    const hasBox = /[─-▟]/.test(text);
    const hasLabel = /[a-z]/.test(text.replace(/<[^>]*>/g, ""));
    assertEquals(hasBox && hasLabel, false, text);
  }
});

Deno.test("isolateBoxDrawing pins box runs and labels to the cell grid", () => {
  const texts = textElements(isolateBoxDrawing(terminalRow(
    '<text xml:space="preserve" y="1.01em"><tspan fill="#c6d0f5">│ </tspan><tspan>  </tspan><tspan fill="#8caaee">└── </tspan><tspan fill="#c6d0f5">git </tspan></text>',
  )));

  assertEquals(texts.length, 3);
  assertStringIncludes(texts[0], 'x="0em" textLength="0.6em"');
  assertStringIncludes(texts[0], 'font-family="IBM Plex Mono"');
  assertStringIncludes(texts[0], '<tspan fill="#c6d0f5">│</tspan>');
  assertStringIncludes(texts[1], 'x="2.4em" textLength="1.8em"');
  assertStringIncludes(texts[1], '<tspan fill="#8caaee">└──</tspan>');
  assertStringIncludes(texts[2], 'x="4.8em" textLength="1.8em"');
  assertStringIncludes(texts[2], '<tspan fill="#c6d0f5">git</tspan>');
  for (const text of texts) assertStringIncludes(text, 'y="1.01em"');
});

Deno.test("isolateBoxDrawing starts columns at the text element's offset", () => {
  const texts = textElements(isolateBoxDrawing(terminalRow(
    '<text x="6em" xml:space="preserve" y="1.01em"><tspan>├─ a&amp;b</tspan></text>',
  )));

  assertStringIncludes(texts[0], 'x="6em" textLength="1.2em"');
  assertStringIncludes(texts[1], 'x="7.8em" textLength="1.8em"');
  assertStringIncludes(texts[1], "a&amp;b");
});

Deno.test("isolateBoxDrawing overdraws box glyphs across row seams", () => {
  const output = isolateBoxDrawing(terminalRow(
    '<text xml:space="preserve" y="1.01em"><tspan>│</tspan></text>',
  ));

  assertStringIncludes(output, 'overflow="visible"');
  assertStringIncludes(
    output,
    'transform="translate(0 -0.364) scale(1 1.04)"',
  );
});

Deno.test("isolateBoxDrawing leaves rows without box glyphs untouched", () => {
  const source = [
    terminalRow(
      '<text xml:space="preserve" y="1.01em"><tspan fill="#c6d0f5">projects </tspan></text>',
    ),
    terminalRow(
      '<text textLength="0.6em" x="34.8em" xml:space="preserve" y="1.01em"><tspan>\u{f07b}</tspan></text>',
    ),
  ].join("\n");

  assertEquals(isolateBoxDrawing(source), source);
});

Deno.test("isolateBoxDrawing rejects text markup it cannot place on the grid", () => {
  assertThrows(
    () =>
      isolateBoxDrawing(terminalRow(
        '<text xml:space="preserve" y="1.01em">├── <tspan>git</tspan></text>',
      )),
    Error,
    "unexpected terminal text markup",
  );
  assertThrows(
    () =>
      isolateBoxDrawing(terminalRow(
        '<text x="12px" xml:space="preserve" y="1.01em"><tspan>├──</tspan></text>',
      )),
    Error,
    'unsupported terminal text offset "12px"',
  );
});

Deno.test("defaultEmojiFontFile uses the native macOS color font", () => {
  assertEquals(
    defaultEmojiFontFile("darwin"),
    "/System/Library/Fonts/Apple Color Emoji.ttc",
  );
  assertEquals(defaultEmojiFontFile("linux"), undefined);
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
      fontFiles: [
        "/fonts/Ellograph.otf",
        "/fonts/Symbols.ttf",
        "/fonts/IBMPlexMono.otf",
      ],
      zoom: 2,
    },
    {
      runner,
      readTextFile: async () =>
        '<svg><svg class="terminal" font-family="JetBrains Mono"></svg></svg>',
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

Deno.test("captureTerminal renders box glyphs apart from labels", async () => {
  const writes: string[] = [];

  await captureTerminal(
    {
      command: ["tree"],
      keepSvg: true,
      svgOnly: true,
      background: null,
      fontFiles: [],
      zoom: 2,
    },
    {
      runner: async () => ({ code: 0 }),
      readTextFile: async () =>
        `<svg><svg class="terminal" font-family="JetBrains Mono">${
          terminalRow(
            '<text xml:space="preserve" y="1.01em"><tspan>└── </tspan><tspan>git </tspan></text>',
          )
        }</svg></svg>`,
      writeTextFile: async (_path, content) => {
        writes.push(content);
      },
      remove: async () => {},
    },
  );

  assertStringIncludes(
    writes[0],
    'font-family="IBM Plex Mono" transform="translate(0 -0.364) scale(1 1.04)"><tspan>└──</tspan>',
  );
  assertStringIncludes(writes[0], 'x="2.4em" textLength="1.8em"><tspan>git');
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
          fontFiles: ["/fonts/Ellograph.otf"],
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
