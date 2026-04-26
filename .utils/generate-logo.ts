#!/usr/bin/env -S deno run --allow-read --allow-write --allow-env
/**
 * generate-logo — render text to SVG using a font, one <path> per glyph.
 *
 * Each glyph becomes its own <path> with data-char and data-index attributes
 * so they can be targeted independently for CSS/JS animation.
 *
 * Usage:
 *   generate-logo --text "winnie.sh" --font moon_get-Heavy --output logo.svg
 */

import { parseArgs } from "jsr:@std/cli@^1/parse-args";
import { extname, isAbsolute, join, resolve } from "jsr:@std/path@^1";

const FONT_EXT_PRIORITY = [".otf", ".ttf", ".woff2", ".woff"] as const;
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
 * - "Heavy"            → <fontsDir>/Heavy.{otf,ttf,woff2,woff}
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
    ? (isAbsolute(expanded) ? expanded : resolve(expanded))
    : join(fontsDir, expanded);

  return resolveWithExtensions(basePath, exists);
}

function resolveWithExtensions(
  basePath: string,
  exists: (p: string) => boolean,
): string {
  const ext = extname(basePath).toLowerCase();
  const stem = ext ? basePath.slice(0, -ext.length) : basePath;

  // Build candidate list: exact match first (if any), then priority order
  // skipping the already-tried exact extension.
  const candidates: string[] = [];
  if (ext) candidates.push(basePath);
  for (const e of FONT_EXT_PRIORITY) {
    if (e === ext) continue;
    candidates.push(stem + e);
  }

  for (const candidate of candidates) {
    if (exists(candidate)) return candidate;
  }

  throw new Error(
    `font not found: tried ${
      candidates.length === 1
        ? candidates[0]
        : `${stem}{${
          candidates.map((c) => extname(c) || "(no ext)").join(",")
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
  if (cp < 0x20 || (cp >= 0x7F && cp < 0xA0)) return "control character";
  if (cp >= 0x200B && cp <= 0x200F) {
    return "zero-width or directional formatting character";
  }
  if (cp >= 0x202A && cp <= 0x202E) return "bidi override character";
  if (cp === 0xFEFF) return "byte-order mark";
  if (cp >= 0xFE00 && cp <= 0xFE0F) return "variation selector";
  if (cp >= 0x1F300 && cp <= 0x1FAFF) return "emoji (most fonts won't render)";
  if (cp >= 0x2600 && cp <= 0x27BF) {
    return "miscellaneous symbol (font may lack glyph)";
  }
  return null;
}

// ── SVG generation ─────────────────────────────────────────────────────

export interface GenerateOptions {
  text: string;
  fontPath: string;
  fontSize?: number;
  className?: string;
  padding?: number;
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

export async function generateLogo(
  opts: GenerateOptions,
): Promise<GenerateResult> {
  const {
    text,
    fontPath,
    fontSize = 72,
    className = "logo",
    padding = 0,
  } = opts;

  // Lazy-load the npm dep so tests of pure helpers don't trigger an npm fetch.
  const mod = await import("npm:text-to-svg@^3.1.5");
  // deno-lint-ignore no-explicit-any
  const TextToSVG = (mod as any).default ?? mod;
  // deno-lint-ignore no-explicit-any
  const font = (TextToSVG as any).loadSync(fontPath);
  // opentype.js Font is exposed as `.font` on TextToSVG instances
  // deno-lint-ignore no-explicit-any
  const otFont = (font as any).font;

  // Use the font's own metrics for an accurate viewBox height.
  const scale = fontSize / otFont.unitsPerEm;
  const ascent = otFont.ascender * scale;
  const descent = Math.abs(otFont.descender * scale);
  const lineHeight = ascent + descent;

  let x = 0;
  const paths: string[] = [];
  const missing: string[] = [];
  let index = 0;

  for (const ch of text) {
    const glyph = otFont.charToGlyph(ch);
    if (glyph?.name === ".notdef") missing.push(ch);

    const metrics = font.getMetrics(ch, { fontSize });
    const d = font.getD(ch, { x, y: ascent, fontSize });

    if (d) {
      paths.push(
        `    <path class="${className}-glyph" data-char="${
          xmlEscape(ch)
        }" data-index="${index}" d="${d}" />`,
      );
    }
    x += metrics.width;
    index++;
  }

  const width = Math.ceil(x + padding * 2);
  const height = Math.ceil(lineHeight + padding * 2);
  const transform = padding
    ? ` transform="translate(${padding} ${padding})"`
    : "";

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
  Bare name      "Heavy"            → ~/Library/Fonts/Heavy.{otf,ttf,woff2,woff}
  With ext       "Heavy.ttf"        → exact, then other extensions on the stem
  Path-like      "./fonts/Heavy"    → path, extension hierarchy applies
  Tilde          "~/fonts/Heavy"    → expanded against \$HOME
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
