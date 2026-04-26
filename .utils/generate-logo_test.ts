import { assertEquals, assertThrows } from "jsr:@std/assert@1";
import { resolveFontPath, validateText } from "./generate-logo.ts";

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
  const exists = existsFromSet(["/opt/fonts/Heavy.woff2"]);
  assertEquals(
    resolveFontPath("/opt/fonts/Heavy", { fontsDir: FONTS_DIR, exists }),
    "/opt/fonts/Heavy.woff2",
  );
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
  assertEquals(issues.map((i) => i.index), [1, 3]);
});
