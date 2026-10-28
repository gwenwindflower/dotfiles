import {
  assertEquals,
  assertMatch,
  assertStringIncludes,
  assertThrows,
} from "@std/assert";
// @ts-types="@types/opentype.js"
import opentype from "opentype.js";
import {
  parseFont,
  renderLogo,
  resolveFontPath,
  validateText,
} from "./generate-logo.ts";

type Font = opentype.Font;

// ── resolveFontPath ────────────────────────────────────────────────────

const FONTS_DIR = "/fake/fonts";

/** Build a fake `exists` predicate from a fixed set of paths. */
function existsFromSet(paths: string[]) {
  const set = new Set(paths);
  return (p: string) => set.has(p);
}

Deno.test("resolveFontPath: bare name resolves against fontsDir with extension priority", () => {
  const exists = existsFromSet([
    `${FONTS_DIR}/Heavy.otf`,
    `${FONTS_DIR}/Heavy.ttf`,
  ]);
  assertEquals(
    resolveFontPath("Heavy", { fontsDir: FONTS_DIR, exists }),
    `${FONTS_DIR}/Heavy.otf`,
    "otf wins over ttf",
  );
});

Deno.test("resolveFontPath: bare name falls back to ttf when otf missing", () => {
  const exists = existsFromSet([`${FONTS_DIR}/Heavy.ttf`]);
  assertEquals(
    resolveFontPath("Heavy", { fontsDir: FONTS_DIR, exists }),
    `${FONTS_DIR}/Heavy.ttf`,
  );
});

Deno.test("resolveFontPath: explicit extension is tried first, then alternates", () => {
  const exists = existsFromSet([`${FONTS_DIR}/Heavy.otf`]);
  assertEquals(
    resolveFontPath("Heavy.ttf", { fontsDir: FONTS_DIR, exists }),
    `${FONTS_DIR}/Heavy.otf`,
    "alternate found when requested ttf missing",
  );
});

Deno.test("resolveFontPath: explicit extension that exists is used as-is", () => {
  const exists = existsFromSet([
    `${FONTS_DIR}/Heavy.ttf`,
    `${FONTS_DIR}/Heavy.otf`,
  ]);
  assertEquals(
    resolveFontPath("Heavy.ttf", { fontsDir: FONTS_DIR, exists }),
    `${FONTS_DIR}/Heavy.ttf`,
    "exact match wins even if higher-priority extension also exists",
  );
});

Deno.test("resolveFontPath: relative path-like input is treated as a path, not a name", () => {
  const cwd = Deno.cwd();
  const exists = existsFromSet([`${cwd}/fonts/Heavy.ttf`]);
  assertEquals(
    resolveFontPath("./fonts/Heavy", { fontsDir: FONTS_DIR, exists }),
    `${cwd}/fonts/Heavy.ttf`,
  );
});

Deno.test("resolveFontPath: absolute path bypasses fontsDir", () => {
  const exists = existsFromSet(["/opt/fonts/Heavy.woff"]);
  assertEquals(
    resolveFontPath("/opt/fonts/Heavy", { fontsDir: FONTS_DIR, exists }),
    "/opt/fonts/Heavy.woff",
  );
});

Deno.test("resolveFontPath: skips WOFF2 in favor of a supported sibling", () => {
  const exists = existsFromSet([
    `${FONTS_DIR}/Heavy.woff2`,
    `${FONTS_DIR}/Heavy.woff`,
  ]);
  assertEquals(
    resolveFontPath("Heavy.woff2", { fontsDir: FONTS_DIR, exists }),
    `${FONTS_DIR}/Heavy.woff`,
  );
});

Deno.test("resolveFontPath: explains when only a WOFF2 file matches", () => {
  const exists = existsFromSet([`${FONTS_DIR}/Heavy.woff2`]);
  const err = assertThrows(
    () => resolveFontPath("Heavy", { fontsDir: FONTS_DIR, exists }),
    Error,
    `${FONTS_DIR}/Heavy.woff2: WOFF2 fonts are not supported`,
  );
  assertStringIncludes(err.message, "woff2_decompress");
});

Deno.test("resolveFontPath: throws when nothing matches", () => {
  const exists = () => false;
  assertThrows(
    () => resolveFontPath("Missing", { fontsDir: FONTS_DIR, exists }),
    Error,
    "font not found",
  );
});

Deno.test("resolveFontPath: rejects empty input", () => {
  assertThrows(
    () => resolveFontPath("   ", { exists: () => true }),
    Error,
    "empty",
  );
});

// ── validateText ───────────────────────────────────────────────────────

Deno.test("validateText: clean ASCII passes", () => {
  assertEquals(validateText("winnie.sh"), []);
  assertEquals(validateText("Hello, World!"), []);
});

Deno.test("validateText: extended Latin passes", () => {
  assertEquals(validateText("café résumé"), []);
});

Deno.test("validateText: flags control characters", () => {
  const issues = validateText("hi\tthere");
  assertEquals(issues.length, 1);
  assertEquals(issues[0].code, "U+0009");
  assertEquals(issues[0].reason, "control character");
});

Deno.test("validateText: flags zero-width formatting characters", () => {
  const issues = validateText("a\u200Bb");
  assertEquals(issues.length, 1);
  assertEquals(issues[0].code, "U+200B");
});

Deno.test("validateText: flags emoji as unrenderable", () => {
  const issues = validateText("hi 👋");
  assertEquals(issues.length, 1);
  assertEquals(issues[0].char, "👋");
  assertEquals(issues[0].reason.includes("emoji"), true);
});

Deno.test("validateText: flags BOM", () => {
  const issues = validateText("\uFEFFhello");
  assertEquals(issues.length, 1);
  assertEquals(issues[0].code, "U+FEFF");
});

Deno.test("validateText: reports indices in source order", () => {
  const issues = validateText("a\tb\tc");
  assertEquals(
    issues.map((i) => i.index),
    [1, 3],
  );
});

// ── Synthetic test fonts ───────────────────────────────────────────────

/** A glyph outline as closed rectangles in font units: [x1, y1, x2, y2]. */
interface TestGlyph {
  name: string;
  unicode?: number;
  advanceWidth: number;
  boxes: [number, number, number, number][];
}

const UNITS_PER_EM = 1000;

const TEST_GLYPHS: TestGlyph[] = [
  { name: ".notdef", advanceWidth: 500, boxes: [[50, 0, 450, 700]] },
  { name: "space", unicode: 0x20, advanceWidth: 250, boxes: [] },
  { name: "A", unicode: 0x41, advanceWidth: 600, boxes: [[0, 0, 600, 700]] },
  { name: "V", unicode: 0x56, advanceWidth: 600, boxes: [[0, 0, 600, 700]] },
  {
    name: "eacute",
    unicode: 0xe9,
    advanceWidth: 500,
    boxes: [[0, 0, 500, 500], [150, 850, 350, 950]],
  },
  { name: "g", unicode: 0x67, advanceWidth: 500, boxes: [[0, -300, 500, 500]] },
  { name: "f", unicode: 0x66, advanceWidth: 300, boxes: [[-100, 0, 450, 700]] },
  {
    name: "ampersand",
    unicode: 0x26,
    advanceWidth: 600,
    boxes: [[0, 0, 600, 700]],
  },
];

/** Kerning pairs by character, in font units. */
const TEST_KERNING: [string, string, number][] = [["A", "V", -100]];

function buildTestFont(): Font {
  const glyphs = TEST_GLYPHS.map((g) => {
    const path = new opentype.Path();
    for (const [x1, y1, x2, y2] of g.boxes) {
      path.moveTo(x1, y1);
      path.lineTo(x2, y1);
      path.lineTo(x2, y2);
      path.lineTo(x1, y2);
      path.closePath();
    }
    return new opentype.Glyph({
      name: g.name,
      unicode: g.unicode,
      advanceWidth: g.advanceWidth,
      path,
    });
  });
  return new opentype.Font({
    familyName: "Logo Test",
    styleName: "Regular",
    unitsPerEm: UNITS_PER_EM,
    ascender: 800,
    descender: -200,
    glyphs,
  });
}

/** Encode a format-0 `kern` table for the given glyph-index pairs. */
function encodeKernTable(pairs: [number, number, number][]): Uint8Array {
  const subtableLength = 14 + pairs.length * 6;
  const bytes = new Uint8Array(4 + subtableLength);
  const view = new DataView(bytes.buffer);
  const pow = 2 ** Math.floor(Math.log2(pairs.length || 1));
  view.setUint16(0, 0); // table version
  view.setUint16(2, 1); // nTables
  view.setUint16(4, 0); // subtable version
  view.setUint16(6, subtableLength);
  view.setUint16(8, 0x0001); // coverage: horizontal
  view.setUint16(10, pairs.length);
  view.setUint16(12, pow * 6);
  view.setUint16(14, Math.log2(pow));
  view.setUint16(16, (pairs.length - pow) * 6);
  pairs.forEach(([left, right, value], i) => {
    view.setUint16(18 + i * 6, left);
    view.setUint16(20 + i * 6, right);
    view.setInt16(22 + i * 6, value);
  });
  return bytes;
}

interface SfntTables {
  flavor: number;
  tables: Map<string, Uint8Array>;
}

function readSfnt(bytes: Uint8Array): SfntTables {
  const view = new DataView(bytes.buffer, bytes.byteOffset, bytes.byteLength);
  const tables = new Map<string, Uint8Array>();
  for (let i = 0; i < view.getUint16(4); i++) {
    const record = 12 + i * 16;
    const tag = new TextDecoder().decode(bytes.subarray(record, record + 4));
    const offset = view.getUint32(record + 8);
    tables.set(
      tag,
      bytes.slice(offset, offset + view.getUint32(record + 12)),
    );
  }
  return { flavor: view.getUint32(0), tables };
}

const pad4 = (n: number) => (n + 3) & ~3;

function writeSfnt({ flavor, tables }: SfntTables): Uint8Array {
  const tags = [...tables.keys()].sort();
  const headerSize = 12 + tags.length * 16;
  const size = tags.reduce((n, t) => n + pad4(tables.get(t)!.length), 0);
  const bytes = new Uint8Array(headerSize + size);
  const view = new DataView(bytes.buffer);
  const pow = 2 ** Math.floor(Math.log2(tags.length));
  view.setUint32(0, flavor);
  view.setUint16(4, tags.length);
  view.setUint16(6, pow * 16);
  view.setUint16(8, Math.log2(pow));
  view.setUint16(10, (tags.length - pow) * 16);
  let offset = headerSize;
  tags.forEach((tag, i) => {
    const data = tables.get(tag)!;
    const record = 12 + i * 16;
    bytes.set(new TextEncoder().encode(tag), record);
    view.setUint32(record + 8, offset);
    view.setUint32(record + 12, data.length);
    bytes.set(data, offset);
    offset += pad4(data.length);
  });
  return bytes;
}

/** Wrap sfnt tables in an uncompressed WOFF 1.0 container. */
function writeWoff({ flavor, tables }: SfntTables): Uint8Array {
  const tags = [...tables.keys()].sort();
  const headerSize = 44 + tags.length * 20;
  const size = tags.reduce((n, t) => n + pad4(tables.get(t)!.length), 0);
  const bytes = new Uint8Array(headerSize + size);
  const view = new DataView(bytes.buffer);
  bytes.set(new TextEncoder().encode("wOFF"), 0);
  view.setUint32(4, flavor);
  view.setUint32(8, bytes.length);
  view.setUint16(12, tags.length);
  view.setUint32(16, writeSfnt({ flavor, tables }).length);
  view.setUint16(20, 1); // majorVersion
  let offset = headerSize;
  tags.forEach((tag, i) => {
    const data = tables.get(tag)!;
    const entry = 44 + i * 20;
    bytes.set(new TextEncoder().encode(tag), entry);
    view.setUint32(entry + 4, offset);
    view.setUint32(entry + 8, data.length);
    view.setUint32(entry + 12, data.length);
    bytes.set(data, offset);
    offset += pad4(data.length);
  });
  return bytes;
}

function testFontTables(): SfntTables {
  const font = buildTestFont();
  const sfnt = readSfnt(new Uint8Array(font.toArrayBuffer()));
  const indexOf = (ch: string) => font.charToGlyphIndex(ch);
  sfnt.tables.set(
    "kern",
    encodeKernTable(
      TEST_KERNING.map(([l, r, v]) => [indexOf(l), indexOf(r), v]),
    ),
  );
  return sfnt;
}

const OTF_BYTES = writeSfnt(testFontTables());
const WOFF_BYTES = writeWoff(testFontTables());
const TEST_FONT = parseFont(OTF_BYTES, "test.otf");

/** Size 100 on a 1000-unit em: one font unit is 0.1px. */
const SIZE = 100;

interface RenderedPath {
  char: string;
  index: number;
  d: string;
}

function renderedPaths(svg: string): RenderedPath[] {
  return [...svg.matchAll(
    /<path class="[^"]*" data-char="([^"]*)" data-index="(\d+)" d="([^"]*)" \/>/g,
  )].map(([, char, index, d]) => ({ char, index: Number(index), d }));
}

/** Smallest x across a path's coordinates. */
function minX(d: string): number {
  const xs = [...d.matchAll(/[ML](-?[\d.]+) (-?[\d.]+)/g)].map((m) =>
    Number(m[1])
  );
  return Math.min(...xs);
}

function viewBox(svg: string): string {
  return svg.match(/viewBox="([^"]*)"/)![1];
}

function groupTransform(svg: string): string | null {
  return svg.match(/<g transform="([^"]*)">/)?.[1] ?? null;
}

// ── parseFont ──────────────────────────────────────────────────────────

Deno.test("parseFont: reads kerning pairs from an OTF kern table", () => {
  const a = TEST_FONT.charToGlyph("A");
  const v = TEST_FONT.charToGlyph("V");
  assertEquals(TEST_FONT.getKerningValue(a, v), -100);
});

Deno.test("parseFont: WOFF renders the same glyph paths as OTF", () => {
  const woff = parseFont(WOFF_BYTES, "test.woff");
  assertEquals(
    renderLogo(woff, { text: "AVé", fontSize: SIZE }).svg,
    renderLogo(TEST_FONT, { text: "AVé", fontSize: SIZE }).svg,
  );
});

Deno.test("parseFont: rejects WOFF2 with a conversion hint", () => {
  const woff2 = new Uint8Array(64);
  woff2.set(new TextEncoder().encode("wOF2"), 0);
  const err = assertThrows(
    () => parseFont(woff2, "/fonts/Heavy.woff2"),
    Error,
    "/fonts/Heavy.woff2: WOFF2 fonts are not supported",
  );
  assertStringIncludes(err.message, "woff2_decompress");
});

Deno.test("parseFont: names the file when the data is not a font", () => {
  assertThrows(
    () => parseFont(new TextEncoder().encode("not a font at all"), "x.otf"),
    Error,
    "x.otf: could not parse font",
  );
});

// ── renderLogo ─────────────────────────────────────────────────────────

Deno.test("renderLogo: emits one closed path per character with data attributes", () => {
  const result = renderLogo(TEST_FONT, { text: "AV", fontSize: SIZE });
  const paths = renderedPaths(result.svg);
  assertEquals(paths.map((p) => [p.char, p.index]), [["A", 0], ["V", 1]]);
  assertEquals(result.glyphs, 2);
  for (const p of paths) assertMatch(p.d, /Z$/);
});

Deno.test("renderLogo: applies pair kerning between adjacent glyphs", () => {
  const kerned = renderLogo(TEST_FONT, { text: "AV", fontSize: SIZE });
  assertEquals(
    minX(renderedPaths(kerned.svg)[1].d),
    50,
    "60 advance - 10 kern",
  );
  assertEquals(kerned.width, 110);

  const unkerned = renderLogo(TEST_FONT, { text: "VA", fontSize: SIZE });
  assertEquals(minX(renderedPaths(unkerned.svg)[1].d), 60);
  assertEquals(unkerned.width, 120);
});

Deno.test("renderLogo: spaces advance the pen and keep their index without a path", () => {
  const result = renderLogo(TEST_FONT, { text: "A A ", fontSize: SIZE });
  const paths = renderedPaths(result.svg);
  assertEquals(paths.map((p) => p.index), [0, 2]);
  assertEquals(minX(paths[1].d), 85);
  assertEquals(result.width, 170, "trailing space is part of the layout");
});

Deno.test("renderLogo: reports missing characters and draws .notdef for them", () => {
  const result = renderLogo(TEST_FONT, { text: "AZZ", fontSize: SIZE });
  assertEquals(result.missing, ["Z", "Z"]);
  const paths = renderedPaths(result.svg);
  assertEquals(paths.map((p) => p.char), ["A", "Z", "Z"]);
  assertEquals(minX(paths[1].d), 65, ".notdef outline starts at x=50 units");
});

Deno.test("renderLogo: line box sets bounds for glyphs inside ascender and descender", () => {
  const result = renderLogo(TEST_FONT, { text: "A", fontSize: SIZE });
  assertEquals(viewBox(result.svg), "0 0 60 100");
  assertEquals(groupTransform(result.svg), null);
});

Deno.test("renderLogo: accents above the ascender grow the top of the viewBox", () => {
  const result = renderLogo(TEST_FONT, { text: "é", fontSize: SIZE });
  assertEquals(viewBox(result.svg), "0 0 50 115");
  assertEquals(groupTransform(result.svg), "translate(0 15)");
});

Deno.test("renderLogo: descenders below the font descender grow the bottom", () => {
  const result = renderLogo(TEST_FONT, { text: "g", fontSize: SIZE });
  assertEquals(viewBox(result.svg), "0 0 50 110");
  assertEquals(groupTransform(result.svg), null);
});

Deno.test("renderLogo: overhangs past the origin and advance widen the viewBox", () => {
  const result = renderLogo(TEST_FONT, { text: "f", fontSize: SIZE });
  assertEquals(viewBox(result.svg), "0 0 55 100");
  assertEquals(groupTransform(result.svg), "translate(10 0)");
});

Deno.test("renderLogo: padding surrounds the ink bounds", () => {
  const result = renderLogo(TEST_FONT, {
    text: "é",
    fontSize: SIZE,
    padding: 5,
  });
  assertEquals(viewBox(result.svg), "0 0 60 125");
  assertEquals(groupTransform(result.svg), "translate(5 20)");
  assertEquals([result.width, result.height], [60, 125]);
});

Deno.test("renderLogo: escapes markup in data-char, title, and aria-label", () => {
  const result = renderLogo(TEST_FONT, { text: `A&<"`, fontSize: SIZE });
  assertEquals(
    renderedPaths(result.svg).map((p) => p.char),
    ["A", "&amp;", "&lt;", "&quot;"],
  );
  assertStringIncludes(result.svg, `aria-label="A&amp;&lt;&quot;"`);
  assertStringIncludes(result.svg, `<title>A&amp;&lt;&quot;</title>`);
});

Deno.test("renderLogo: class name prefixes the svg and glyph classes", () => {
  const { svg } = renderLogo(TEST_FONT, {
    text: "A",
    fontSize: SIZE,
    className: "brand",
  });
  assertStringIncludes(svg, `class="brand-svg"`);
  assertStringIncludes(svg, `<path class="brand-glyph"`);
});
