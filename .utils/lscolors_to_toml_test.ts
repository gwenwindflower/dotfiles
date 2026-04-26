import { assertEquals } from "@std/assert";
import {
  ansiCodeToStyle,
  convertLsColorsToToml,
  lsPatternToYazi,
  rgbToHex,
} from "./lscolors_to_toml.ts";

Deno.test("rgbToHex zero-pads each component to two hex digits", () => {
  assertEquals(rgbToHex(0, 0, 0), "#000000");
  assertEquals(rgbToHex(255, 255, 255), "#ffffff");
  assertEquals(rgbToHex(15, 0, 255), "#0f00ff");
});

Deno.test("ansiCodeToStyle returns empty style for empty code string", () => {
  assertEquals(ansiCodeToStyle(""), {});
});

Deno.test("ansiCodeToStyle resolves a basic foreground color code", () => {
  assertEquals(ansiCodeToStyle("31"), { fg: "red" });
});

Deno.test("ansiCodeToStyle resolves a basic background color code", () => {
  assertEquals(ansiCodeToStyle("44"), { bg: "blue" });
});

Deno.test("ansiCodeToStyle combines a modifier with a color", () => {
  assertEquals(ansiCodeToStyle("1;33"), { bold: true, fg: "yellow" });
});

Deno.test("ansiCodeToStyle parses a 24-bit RGB foreground", () => {
  assertEquals(ansiCodeToStyle("38;2;255;128;0"), { fg: "#ff8000" });
});

Deno.test("ansiCodeToStyle parses a 256-color palette foreground", () => {
  // index 16 is the bottom of the 6×6×6 cube → (0,0,0)
  assertEquals(ansiCodeToStyle("38;5;16"), { fg: "#000000" });
});

Deno.test("ansiCodeToStyle clears prior styling on reset code 0", () => {
  assertEquals(ansiCodeToStyle("31;0;1"), { bold: true });
});

Deno.test("lsPatternToYazi maps the canonical short codes", () => {
  assertEquals(lsPatternToYazi("di"), { name: "*/" });
  assertEquals(lsPatternToYazi("ln"), { name: "*", is: "link" });
  assertEquals(lsPatternToYazi("ex"), { name: "*", is: "exec" });
});

Deno.test("lsPatternToYazi passes glob patterns through unchanged", () => {
  assertEquals(lsPatternToYazi("*.ts"), { name: "*.ts" });
  assertEquals(lsPatternToYazi("Makefile"), { name: "Makefile" });
});

Deno.test("lsPatternToYazi returns an empty name for unknown short codes", () => {
  assertEquals(lsPatternToYazi("zz"), { name: "" });
});

Deno.test("convertLsColorsToToml emits one rule per styled entry with trailing comma", () => {
  const out = convertLsColorsToToml("di=01;34:*.ts=38;5;16");
  assertEquals(
    out,
    '  { name = "*/", fg = "blue", bold = true },\n  { name = "*.ts", fg = "#000000" },',
  );
});

Deno.test("convertLsColorsToToml drops entries with no styling", () => {
  const out = convertLsColorsToToml("di=:*.ts=31");
  assertEquals(out, '  { name = "*.ts", fg = "red" },');
});
