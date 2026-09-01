#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env=HOME --allow-run=termframe,resvg

import { parseArgs } from "@std/cli/parse-args";
import { basename, extname, join } from "@std/path";

export interface GradientBackground {
  from: string;
  mid: string;
  to: string;
  angle: number;
  radius: number;
  grain: number;
}

export const DEFAULT_BACKGROUND: GradientBackground = {
  from: "#f4b8e4",
  mid: "#ca9ee6",
  to: "#8caaee",
  angle: 135,
  radius: 16,
  grain: 0.08,
};

export interface TermframeOptions {
  svgPath: string;
  command: string[];
  title?: string;
  theme?: string;
  mode?: "auto" | "dark" | "light";
  padding?: number;
  margin?: number;
  width?: string;
  height?: string;
  timeout?: number;
  showCommand?: boolean;
}

export interface CaptureOptions extends Omit<TermframeOptions, "svgPath"> {
  output?: string;
  keepSvg: boolean;
  svgOnly: boolean;
  background: GradientBackground | null;
  fontFiles: string[];
  zoom: number;
}

export interface CommandResult {
  code: number;
}

export type CommandRunner = (
  command: string,
  args: string[],
) => Promise<CommandResult>;

interface CaptureDependencies {
  runner: CommandRunner;
  readTextFile(path: string): Promise<string>;
  writeTextFile(path: string, content: string): Promise<void>;
  remove(path: string): Promise<void>;
}

const defaultRunner: CommandRunner = async (command, args) => {
  const child = new Deno.Command(command, {
    args,
    stdin: "inherit",
    stdout: "inherit",
    stderr: "inherit",
  });
  const result = await child.output();
  return { code: result.code };
};

const defaultDependencies: CaptureDependencies = {
  runner: defaultRunner,
  readTextFile: Deno.readTextFile,
  writeTextFile: Deno.writeTextFile,
  remove: Deno.remove,
};

function replaceExtension(path: string, extension: string): string {
  const current = extname(path);
  return current
    ? `${path.slice(0, -current.length)}${extension}`
    : path + extension;
}

function captureName(command: string): string {
  const name = basename(command).replace(/[^a-zA-Z0-9]+/g, "-")
    .replace(/^-|-$/g, "").toLowerCase();
  return name || "capture";
}

export function capturePaths(
  output: string | undefined,
  command: string,
  svgOnly: boolean,
): { png?: string; svg: string } {
  const stem = captureName(command);
  if (svgOnly) {
    return { svg: output ?? `${stem}.svg`, png: undefined };
  }

  const png = output ?? `${stem}.png`;
  return { png, svg: replaceExtension(png, ".svg") };
}

function validateBackground(background: GradientBackground): void {
  const hex = /^#[0-9a-f]{3,4}(?:[0-9a-f]{3,4})?$/i;
  for (
    const [name, color] of [
      ["from", background.from],
      ["mid", background.mid],
      ["to", background.to],
    ]
  ) {
    if (!hex.test(color)) throw new Error(`--${name} must be a hex color`);
  }
  if (!Number.isFinite(background.angle)) {
    throw new Error("--angle must be a number");
  }
  if (!Number.isFinite(background.radius) || background.radius < 0) {
    throw new Error("--radius must be zero or greater");
  }
  if (
    !Number.isFinite(background.grain) || background.grain < 0 ||
    background.grain > 1
  ) {
    throw new Error("--grain must be between 0 and 1");
  }
}

export function addGradientBackground(
  source: string,
  background: GradientBackground,
): string {
  validateBackground(background);
  const root = source.match(/<svg\b[^>]*>/);
  if (!root || root.index === undefined) {
    throw new Error("missing root <svg> tag");
  }
  if (/id=["'](?:termshot|termframe)-bg["']/.test(source)) {
    throw new Error("SVG already has a termshot background");
  }

  const radians = ((background.angle % 360) * Math.PI) / 180;
  const dx = Math.cos(radians) / 2;
  const dy = Math.sin(radians) / 2;
  const coordinates = {
    x1: 0.5 - dx,
    y1: 0.5 - dy,
    x2: 0.5 + dx,
    y2: 0.5 + dy,
  };
  const fixed = (value: number) => value.toFixed(3);
  const content = `<defs id="termshot-bg">
<linearGradient id="termshot-gradient" x1="${fixed(coordinates.x1)}" y1="${
    fixed(coordinates.y1)
  }" x2="${fixed(coordinates.x2)}" y2="${fixed(coordinates.y2)}">
<stop offset="0" stop-color="${background.from}"/>
<stop offset="0.5" stop-color="${background.mid}"/>
<stop offset="1" stop-color="${background.to}"/>
</linearGradient>
<filter id="termshot-grain" x="0" y="0" width="100%" height="100%">
<feTurbulence type="fractalNoise" baseFrequency="0.8" numOctaves="2" stitchTiles="stitch" result="noise"/>
<feColorMatrix in="noise" type="matrix" values="0 0 0 0 1  0 0 0 0 1  0 0 0 0 1  0.6 0.6 0.6 0 0"/>
<feComposite operator="in" in2="SourceGraphic"/>
</filter>
<clipPath id="termshot-clip"><rect width="100%" height="100%" rx="${background.radius}"/></clipPath>
</defs>
<g clip-path="url(#termshot-clip)">
<rect width="100%" height="100%" fill="url(#termshot-gradient)"/>
<rect width="100%" height="100%" filter="url(#termshot-grain)" fill="#ffffff" opacity="${background.grain}"/>
</g>`;
  const insertion = root.index + root[0].length;
  return `${source.slice(0, insertion)}\n${content}${source.slice(insertion)}`;
}

export function buildTermframeArgs(options: TermframeOptions): string[] {
  const args = ["--output", options.svgPath];
  const stringOptions: Array<[string, string | number | undefined]> = [
    ["--title", options.title],
    ["--theme", options.theme],
    ["--mode", options.mode],
    ["--padding", options.padding],
    ["--window-margin", options.margin],
    ["--width", options.width],
    ["--height", options.height],
    ["--timeout", options.timeout],
  ];
  for (const [flag, value] of stringOptions) {
    if (value !== undefined) args.push(flag, String(value));
  }
  if (options.showCommand) args.push("--show-command");
  return [...args, "--", ...options.command];
}

export function buildResvgArgs(
  svgPath: string,
  pngPath: string,
  fontFiles: string[],
  zoom: number,
): string[] {
  const fonts = fontFiles.flatMap((path) => ["--use-font-file", path]);
  return [
    "--skip-system-fonts",
    ...fonts,
    "--zoom",
    String(zoom),
    svgPath,
    pngPath,
  ];
}

const rasterFontFamilies = [
  { prefix: "EllographCFFixedPitch-", name: "Ellograph CF Fixed Pitch" },
  { prefix: "SymbolsNerdFontMono-", name: "Symbols Nerd Font Mono" },
  { prefix: "IBMPlexMono-", name: "IBM Plex Mono" },
];

const optionalRasterFontPrefixes = ["NotoColorEmoji", "Noto-COLRv1"];

export function selectRasterFontFiles(
  directory: string,
  names: string[],
): string[] {
  for (const family of rasterFontFamilies) {
    if (!names.some((name) => name.startsWith(family.prefix))) {
      throw new Error(`${family.name} is missing from ${directory}`);
    }
  }
  return names.filter((name) =>
    (rasterFontFamilies.some((family) => name.startsWith(family.prefix)) ||
      optionalRasterFontPrefixes.some((prefix) => name.startsWith(prefix))) &&
    [".otf", ".ttf"].includes(extname(name).toLowerCase())
  ).sort().map((name) => join(directory, name));
}

export function defaultEmojiFontFile(
  os: typeof Deno.build.os = Deno.build.os,
): string | undefined {
  return os === "darwin"
    ? "/System/Library/Fonts/Apple Color Emoji.ttc"
    : undefined;
}

async function rasterFontFiles(
  directory: string,
  emojiFont: string | undefined,
): Promise<string[]> {
  const names: string[] = [];
  for await (const entry of Deno.readDir(directory)) {
    if (entry.isFile) names.push(entry.name);
  }
  const files = selectRasterFontFiles(directory, names);
  if (emojiFont && !files.includes(emojiFont)) {
    try {
      const file = await Deno.stat(emojiFont);
      if (!file.isFile) throw new Error("not a file");
    } catch (error) {
      throw new Error(
        `emoji font ${emojiFont} is unavailable: ${
          error instanceof Error ? error.message : error
        }`,
      );
    }
    files.push(emojiFont);
  }
  return files;
}

const terminalFontStack =
  "Ellograph CF Fixed Pitch, Symbols Nerd Font Mono, IBM Plex Mono, Apple Color Emoji, Noto Color Emoji";

export function setTerminalFontStack(source: string): string {
  const terminal = source.match(
    /<svg\b(?=[^>]*\bclass=["']terminal["'])[^>]*>/,
  );
  if (!terminal || terminal.index === undefined) {
    throw new Error("missing terminal SVG");
  }
  const updated = terminal[0].replace(
    /\bfont-family=(["'])[^"']*\1/,
    `font-family="${terminalFontStack}"`,
  );
  if (updated === terminal[0]) {
    throw new Error("terminal SVG has no font stack");
  }
  return source.slice(0, terminal.index) + updated +
    source.slice(terminal.index + terminal[0].length);
}

async function runChecked(
  runner: CommandRunner,
  command: string,
  args: string[],
): Promise<void> {
  const result = await runner(command, args);
  if (result.code !== 0) {
    throw new Error(`${command} exited with status ${result.code}`);
  }
}

export async function captureTerminal(
  options: CaptureOptions,
  dependencies: CaptureDependencies = defaultDependencies,
): Promise<{ png?: string; svg?: string }> {
  if (options.command.length === 0) throw new Error("a command is required");
  const paths = capturePaths(
    options.output,
    options.command[0],
    options.svgOnly,
  );
  const title = options.title ?? captureName(options.command[0]);

  await runChecked(
    dependencies.runner,
    "termframe",
    buildTermframeArgs({ ...options, svgPath: paths.svg, title }),
  );

  const source = await dependencies.readTextFile(paths.svg);
  const rendered = setTerminalFontStack(source);
  await dependencies.writeTextFile(
    paths.svg,
    options.background
      ? addGradientBackground(rendered, options.background)
      : rendered,
  );

  if (paths.png) {
    await runChecked(
      dependencies.runner,
      "resvg",
      buildResvgArgs(paths.svg, paths.png, options.fontFiles, options.zoom),
    );
  }

  if (paths.png && !options.keepSvg) {
    await dependencies.remove(paths.svg);
    return { png: paths.png };
  }
  return { png: paths.png, svg: paths.svg };
}

function numericOption(
  value: string | undefined,
  name: string,
): number | undefined {
  if (value === undefined) return undefined;
  const parsed = Number(value);
  if (!Number.isFinite(parsed)) throw new Error(`${name} must be a number`);
  return parsed;
}

function defaultFontDirectory(): string {
  const home = Deno.env.get("HOME");
  if (!home) throw new Error("HOME is required unless --fonts-dir is set");
  return Deno.build.os === "darwin"
    ? `${home}/Library/Fonts`
    : `${home}/.local/share/fonts`;
}

function printHelp(): void {
  console.log(`termshot — Capture styled terminal output as SVG and PNG

Usage:
  termshot [options] -- command [args...]

Output:
  -o, --output FILE       PNG path, or SVG path with --svg-only
      --[no-]keep-svg     Keep the intermediate SVG (default: true)
      --svg-only          Skip PNG rendering
      --fonts-dir DIR     Find the three raster font families in this directory
      --emoji-font FILE   Override the platform emoji font
      --zoom SCALE        PNG raster scale (default: 2)

Terminal:
      --title TEXT        Window title (default: command name)
      --theme NAME        Termframe color theme
      --mode MODE         auto, dark, or light
      --padding EM        Inner text padding
      --margin PX         Window margin around the frame
  -W, --width CELLS       Fixed or ranged terminal width
  -H, --height LINES      Fixed or ranged terminal height
      --timeout SECONDS   Command timeout
      --show-command      Include the command line

Background:
      --transparent       Leave the SVG background transparent
      --from HEX          Gradient start (default: #f4b8e4)
      --mid HEX           Gradient midpoint (default: #ca9ee6)
      --to HEX            Gradient end (default: #8caaee)
      --angle DEGREES     Gradient angle (default: 135)
      --radius PX         Outer corner radius (default: 16)
      --grain OPACITY     Noise opacity from 0 to 1 (default: 0.08)

Examples:
  termshot -- lsd docs
  termshot -o prs.png --title "Pull requests" -- gh pr list
  termshot --theme dracula --from '#f5c2e7' --to '#89b4fa' -- glow README.md`);
}

async function main(): Promise<void> {
  const args = parseArgs(Deno.args, {
    alias: { h: "help", o: "output", W: "width", H: "height" },
    boolean: [
      "help",
      "keep-svg",
      "svg-only",
      "show-command",
      "transparent",
    ],
    string: [
      "output",
      "fonts-dir",
      "emoji-font",
      "zoom",
      "title",
      "theme",
      "mode",
      "padding",
      "margin",
      "width",
      "height",
      "timeout",
      "from",
      "mid",
      "to",
      "angle",
      "radius",
      "grain",
    ],
    default: { "keep-svg": true },
    negatable: ["keep-svg"],
    "--": true,
  });

  if (args.help) {
    printHelp();
    return;
  }

  const command = (args["--"].length > 0 ? args["--"] : args._).map(String);
  if (command.length === 0) {
    printHelp();
    throw new Error("a command is required after --");
  }

  const mode = args.mode as "auto" | "dark" | "light" | undefined;
  if (mode && !["auto", "dark", "light"].includes(mode)) {
    throw new Error("--mode must be auto, dark, or light");
  }
  const zoom = numericOption(args.zoom, "--zoom") ?? 2;
  if (zoom <= 0) throw new Error("--zoom must be greater than zero");
  if (!args["svg-only"] && args.output && extname(args.output) !== ".png") {
    throw new Error("--output must end in .png unless --svg-only is set");
  }

  const background = args.transparent ? null : {
    from: args.from ?? DEFAULT_BACKGROUND.from,
    mid: args.mid ?? DEFAULT_BACKGROUND.mid,
    to: args.to ?? DEFAULT_BACKGROUND.to,
    angle: numericOption(args.angle, "--angle") ?? DEFAULT_BACKGROUND.angle,
    radius: numericOption(args.radius, "--radius") ??
      DEFAULT_BACKGROUND.radius,
    grain: numericOption(args.grain, "--grain") ?? DEFAULT_BACKGROUND.grain,
  };
  if (background) validateBackground(background);

  const outputs = await captureTerminal({
    command,
    output: args.output,
    keepSvg: args["keep-svg"],
    svgOnly: args["svg-only"],
    background,
    fontFiles: args["svg-only"] ? [] : await rasterFontFiles(
      args["fonts-dir"] ?? defaultFontDirectory(),
      args["emoji-font"] ?? defaultEmojiFontFile(),
    ),
    zoom,
    title: args.title,
    theme: args.theme,
    mode,
    padding: numericOption(args.padding, "--padding"),
    margin: numericOption(args.margin, "--margin"),
    width: args.width,
    height: args.height,
    timeout: numericOption(args.timeout, "--timeout"),
    showCommand: args["show-command"],
  });

  for (const path of [outputs.svg, outputs.png]) {
    if (path) console.log(`Created ${path}`);
  }
}

if (import.meta.main) {
  try {
    await main();
  } catch (error) {
    console.error(
      `termshot: ${error instanceof Error ? error.message : error}`,
    );
    Deno.exit(1);
  }
}
