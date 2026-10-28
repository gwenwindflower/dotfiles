#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env=HOME
/**
 * generate-logo — render text to SVG using a font, one <path> per glyph.
 *
 * Each glyph becomes its own <path> with data-char and data-index attributes
 * so they can be targeted independently for CSS/JS animation.
 *
 * Usage:
 *   generate-logo --text "winnie.sh" --font moon_get-Heavy --output logo.svg
 */

import { parseArgs } from "@std/cli/parse-args";
import { extname, isAbsolute, join, resolve } from "@std/path";
// @ts-types="@types/opentype.js"
import opentype from "opentype.js";

type Font = opentype.Font;
type Glyph = opentype.Glyph;
type Path = opentype.Path;

const FONT_EXT_PRIORITY = [".otf", ".ttf", ".woff"] as const;
const WOFF2_EXT = ".woff2";
const HOME = Deno.env.get("HOME") ?? "";
const DEFAULT_FONTS_DIR = `${HOME}/Library/Fonts`;

// ── Font resolution ────────────────────────────────────────────────────

export interface ResolveFontOptions {
  fontsDir?: string;
  exists?: (path: string) => boolean;
}

/**
 * Resolve a font name or path to an absolute file path.
 *
 * - "Heavy"            → <fontsDir>/Heavy.{otf,ttf,woff}
 * - "Heavy.ttf"        → tries exact, then alternate extensions
 * - "./fonts/Heavy"    → path-like, extensions tried against the stem
 * - "~/fonts/Heavy"    → tilde expanded against $HOME
 * - "/abs/path.ttf"    → absolute path, exact then alternate extensions
 */
export function resolveFontPath(
  input: string,
  opts: ResolveFontOptions = {},
): string {
  const fontsDir = opts.fontsDir ?? DEFAULT_FONTS_DIR;
  const exists = opts.exists ?? defaultExists;

  const trimmed = input.trim();
  if (!trimmed) throw new Error("font name is empty");

  const isPathLike = trimmed.includes("/") || trimmed.startsWith("~");
  const expanded = trimmed.startsWith("~/")
    ? join(HOME, trimmed.slice(2))
    : trimmed === "~"
    ? HOME
    : trimmed;

  const basePath = isPathLike
    ? isAbsolute(expanded) ? expanded : resolve(expanded)
    : join(fontsDir, expanded);

  return resolveWithExtensions(basePath, exists);
}

function resolveWithExtensions(
  basePath: string,
  exists: (p: string) => boolean,
): string {
  const ext = extname(basePath).toLowerCase();
  const stem = ext ? basePath.slice(0, -ext.length) : basePath;

  // Build candidate list: exact match first (if supported), then priority
  // order skipping the already-tried exact extension.
  const candidates: string[] = [];
  if (ext && ext !== WOFF2_EXT) candidates.push(basePath);
  for (const e of FONT_EXT_PRIORITY) {
    if (e === ext) continue;
    candidates.push(stem + e);
  }

  for (const candidate of candidates) {
    if (exists(candidate)) return candidate;
  }

  const woff2 = ext === WOFF2_EXT ? basePath : stem + WOFF2_EXT;
  if (exists(woff2)) throw new Error(`${woff2}: ${WOFF2_HINT}`);

  throw new Error(
    `font not found: tried ${
      candidates.length === 1 ? candidates[0] : `${stem}{${
        candidates
          .map((c) => extname(c) || "(no ext)")
          .join(",")
      }}`
    }`,
  );
}

function defaultExists(path: string): boolean {
  try {
    Deno.statSync(path);
    return true;
  } catch {
    return false;
  }
}

// ── Text validation ────────────────────────────────────────────────────

export interface TextIssue {
  index: number;
  char: string;
  code: string;
  reason: string;
}

/**
 * Find characters that won't render well in a typical Latin font:
 * control chars, zero-width formatting, BOMs, variation selectors, emoji.
 * Returns issues with the code-unit index for clean error reporting.
 */
export function validateText(text: string): TextIssue[] {
  const issues: TextIssue[] = [];
  let i = 0;
  for (const ch of text) {
    const cp = ch.codePointAt(0)!;
    const code = `U+${cp.toString(16).toUpperCase().padStart(4, "0")}`;
    const reason = classifyCodePoint(cp);
    if (reason) issues.push({ index: i, char: ch, code, reason });
    i += ch.length;
  }
  return issues;
}

function classifyCodePoint(cp: number): string | null {
  if (cp < 0x20 || (cp >= 0x7f && cp < 0xa0)) return "control character";
  if (cp >= 0x200b && cp <= 0x200f) {
    return "zero-width or directional formatting character";
  }
  if (cp >= 0x202a && cp <= 0x202e) return "bidi override character";
  if (cp === 0xfeff) return "byte-order mark";
  if (cp >= 0xfe00 && cp <= 0xfe0f) return "variation selector";
  if (cp >= 0x1f300 && cp <= 0x1faff) return "emoji (most fonts won't render)";
  if (cp >= 0x2600 && cp <= 0x27bf) {
    return "miscellaneous symbol (font may lack glyph)";
  }
  return null;
}

// ── Font loading ───────────────────────────────────────────────────────

const WOFF2_HINT =
  "WOFF2 fonts are not supported; convert to OTF, TTF, or WOFF first (e.g. `woff2_decompress font.woff2`)";

/**
 * Parse OTF, TTF, or WOFF bytes into an opentype.js Font.
 * `source` names the font in error messages.
 */
export function parseFont(
  bytes: Uint8Array | ArrayBuffer,
  source: string,
): Font {
  const view = bytes instanceof Uint8Array ? bytes : new Uint8Array(bytes);
  const signature = new TextDecoder().decode(view.subarray(0, 4));
  if (signature === "wOF2") throw new Error(`${source}: ${WOFF2_HINT}`);

  const buffer = view.buffer.slice(
    view.byteOffset,
    view.byteOffset + view.byteLength,
  );
  try {
    return opentype.parse(buffer);
  } catch (err) {
    const reason = err instanceof Error ? err.message : String(err);
    throw new Error(`${source}: could not parse font: ${reason}`);
  }
}

// ── SVG generation ─────────────────────────────────────────────────────

export interface RenderOptions {
  text: string;
  fontSize?: number;
  className?: string;
  padding?: number;
}

export interface GenerateOptions extends RenderOptions {
  fontPath: string;
}

export interface GenerateResult {
  svg: string;
  glyphs: number;
  width: number;
  height: number;
  /** Characters not present in the font (rendered as .notdef). */
  missing: string[];
}

/** XML-escape a string for safe inclusion in SVG attributes / text. */
function xmlEscape(s: string): string {
  return s
    .replace(/&/g, "&amp;")
    .replace(/</g, "&lt;")
    .replace(/>/g, "&gt;")
    .replace(/"/g, "&quot;");
}

interface Bounds {
  left: number;
  top: number;
  right: number;
  bottom: number;
}

/**
 * Place a glyph outline with its baseline origin at (x, baseline), in SVG
 * coordinates (y down). Keeps close commands so stroked outlines stay sealed.
 */
function placeGlyph(
  glyph: Glyph,
  x: number,
  baseline: number,
  scale: number,
): Path {
  const path = new opentype.Path();
  const px = (v: number) => x + v * scale;
  const py = (v: number) => baseline - v * scale;
  for (const cmd of glyph.path.commands) {
    switch (cmd.type) {
      case "M":
        path.moveTo(px(cmd.x), py(cmd.y));
        break;
      case "L":
        path.lineTo(px(cmd.x), py(cmd.y));
        break;
      case "Q":
        path.quadraticCurveTo(px(cmd.x1), py(cmd.y1), px(cmd.x), py(cmd.y));
        break;
      case "C":
        path.curveTo(
          px(cmd.x1),
          py(cmd.y1),
          px(cmd.x2),
          py(cmd.y2),
          px(cmd.x),
          py(cmd.y),
        );
        break;
      case "Z":
        path.closePath();
        break;
    }
  }
  return path;
}

/** Render text to an SVG with one <path> per character, kerned by pair. */
export function renderLogo(font: Font, opts: RenderOptions): GenerateResult {
  const { text, fontSize = 72, className = "logo", padding = 0 } = opts;

  const scale = fontSize / font.unitsPerEm;
  const ascent = font.ascender * scale;
  const descent = Math.abs(font.descender * scale);

  const paths: string[] = [];
  const missing: string[] = [];
  const bounds: Bounds = { left: 0, top: 0, right: 0, bottom: 0 };
  let x = 0;
  let index = 0;
  let previous: Glyph | null = null;

  for (const ch of text) {
    const glyph = font.charToGlyph(ch);
    if (glyph.index === 0) missing.push(ch);
    if (previous) x += font.getKerningValue(previous, glyph) * scale;

    if (glyph.path.commands.length) {
      const path = placeGlyph(glyph, x, ascent, scale);
      const box = path.getBoundingBox();
      bounds.left = Math.min(bounds.left, box.x1);
      bounds.top = Math.min(bounds.top, box.y1);
      bounds.right = Math.max(bounds.right, box.x2);
      bounds.bottom = Math.max(bounds.bottom, box.y2);
      paths.push(
        `    <path class="${className}-glyph" data-char="${
          xmlEscape(ch)
        }" data-index="${index}" d="${path.toPathData(2)}" />`,
      );
    }

    x += (glyph.advanceWidth ?? 0) * scale;
    previous = glyph;
    index++;
  }

  bounds.right = Math.max(bounds.right, x);
  bounds.bottom = Math.max(bounds.bottom, ascent + descent);

  const width = Math.ceil(bounds.right - bounds.left + padding * 2);
  const height = Math.ceil(bounds.bottom - bounds.top + padding * 2);
  const dx = round(padding - bounds.left);
  const dy = round(padding - bounds.top);
  const transform = dx || dy ? ` transform="translate(${dx} ${dy})"` : "";

  const svg =
    `<svg viewBox="0 0 ${width} ${height}" class="${className}-svg" xmlns="http://www.w3.org/2000/svg" role="img" aria-label="${
      xmlEscape(text)
    }">
  <title>${xmlEscape(text)}</title>
  <g${transform}>
${paths.join("\n")}
  </g>
</svg>
`;

  return { svg, glyphs: paths.length, width, height, missing };
}

function round(v: number): number {
  return Math.round(v * 100) / 100;
}

export async function generateLogo(
  opts: GenerateOptions,
): Promise<GenerateResult> {
  const font = parseFont(await Deno.readFile(opts.fontPath), opts.fontPath);
  return renderLogo(font, opts);
}

// ── CLI ────────────────────────────────────────────────────────────────

function printHelp() {
  console.log(
    `generate-logo — render text to SVG using a font, one <path> per glyph.

Usage:
  generate-logo --text <string> --font <name|path> [options]

Required:
  -t, --text <string>     Text to render
  -f, --font <name|path>  Font (see resolution below)

Options:
  -o, --output <path>     Output SVG file (default: stdout)
  -s, --size <px>         Font size in pixels (default: 72)
      --class <name>      Base class for SVG + glyph paths (default: logo)
      --padding <px>      Padding around text inside viewBox (default: 0)
      --force             Skip text validation (allow control / emoji chars)
  -h, --help              Show this help

Font resolution:
  Bare name      "Heavy"            → ~/Library/Fonts/Heavy.{otf,ttf,woff}
  With ext       "Heavy.ttf"        → exact, then other extensions on the stem
  Path-like      "./fonts/Heavy"    → path, extension hierarchy applies
  Tilde          "~/fonts/Heavy"    → expanded against $HOME
  Absolute       "/abs/Heavy.otf"   → exact, then other extensions
`,
  );
}

async function main() {
  const args = parseArgs(Deno.args, {
    string: ["text", "font", "output", "size", "class", "padding"],
    boolean: ["help", "force"],
    alias: { h: "help", t: "text", f: "font", o: "output", s: "size" },
  });

  if (args.help) {
    printHelp();
    return;
  }

  if (!args.text || !args.font) {
    console.error("error: --text and --font are required\n");
    printHelp();
    Deno.exit(1);
  }

  const issues = validateText(args.text);
  if (issues.length && !args.force) {
    console.error(
      `error: text contains ${issues.length} character(s) that may not render:`,
    );
    for (const issue of issues) {
      console.error(`  index ${issue.index}: ${issue.code} — ${issue.reason}`);
    }
    console.error("\nuse --force to render anyway.");
    Deno.exit(1);
  }

  let fontPath: string;
  try {
    fontPath = resolveFontPath(args.font);
  } catch (err) {
    console.error(`error: ${err instanceof Error ? err.message : err}`);
    Deno.exit(1);
  }

  const result = await generateLogo({
    text: args.text,
    fontPath,
    fontSize: args.size ? Number(args.size) : undefined,
    className: args.class,
    padding: args.padding ? Number(args.padding) : undefined,
  });

  if (result.missing.length) {
    const unique = [...new Set(result.missing)].join(" ");
    console.error(
      `warning: ${result.missing.length} character(s) not in font, rendered as .notdef: ${unique}`,
    );
  }

  if (args.output) {
    await Deno.writeTextFile(args.output, result.svg);
    console.error(
      `Generated ${args.output}: ${result.glyphs} glyphs, ${result.width}×${result.height}`,
    );
  } else {
    console.log(result.svg);
  }
}

if (import.meta.main) {
  main();
}
