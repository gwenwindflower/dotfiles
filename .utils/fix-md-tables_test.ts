import { assertEquals } from "jsr:@std/assert@1";
import { fixTableLine, isTableLine, processContent } from "./fix-md-tables.ts";

// ── isTableLine ────────────────────────────────────────────────────

Deno.test("isTableLine recognizes pipe-prefixed lines", () => {
  assertEquals(isTableLine("| foo | bar |"), true);
  assertEquals(isTableLine("|foo|"), true);
  assertEquals(isTableLine("  | indented |"), true);
});

Deno.test("isTableLine rejects non-table content", () => {
  assertEquals(isTableLine("plain text"), false);
  assertEquals(isTableLine("- list item"), false);
  assertEquals(isTableLine(""), false);
});

// ── fixTableLine ───────────────────────────────────────────────────

Deno.test("fixTableLine adds spacing to compact rows", () => {
  assertEquals(fixTableLine("|foo|bar|"), "| foo | bar |");
});

Deno.test("fixTableLine is idempotent on already-spaced rows", () => {
  const spaced = "| foo | bar |";
  assertEquals(fixTableLine(spaced), spaced);
});

Deno.test("fixTableLine preserves alignment markers in separator rows", () => {
  assertEquals(fixTableLine("|:---:|---:|---|"), "| :---: | ---: | --- |");
});

Deno.test("fixTableLine collapses excess internal whitespace", () => {
  assertEquals(fixTableLine("|   foo   |   bar   |"), "| foo | bar |");
});

Deno.test("fixTableLine returns non-table lines unchanged", () => {
  assertEquals(fixTableLine("not a table"), "not a table");
  assertEquals(fixTableLine("| missing trailing pipe"), "| missing trailing pipe");
});

// ── processContent ─────────────────────────────────────────────────

Deno.test("processContent fixes tables and reports line numbers", () => {
  const input = [
    "# Heading",
    "",
    "|name|value|",
    "|---|---|",
    "|a|1|",
    "",
  ].join("\n");

  const { output, issues } = processContent(input, "test.md");

  assertEquals(issues.length, 3);
  assertEquals(issues[0].line, 3);
  assertEquals(issues[1].line, 4);
  assertEquals(issues[2].line, 5);
  assertEquals(output.includes("| name | value |"), true);
  assertEquals(output.includes("| --- | --- |"), true);
});

Deno.test("processContent skips tables inside fenced code blocks", () => {
  const input = [
    "Example output:",
    "",
    "```text",
    "|foo|bar|",
    "|---|---|",
    "```",
    "",
  ].join("\n");

  const { output, issues } = processContent(input, "test.md");

  assertEquals(issues.length, 0);
  assertEquals(output, input);
});

Deno.test("processContent handles tilde-fenced code blocks", () => {
  const input = ["~~~markdown", "|a|b|", "~~~"].join("\n");
  const { issues } = processContent(input, "test.md");
  assertEquals(issues.length, 0);
});

Deno.test("processContent reports nothing on already-correct files", () => {
  const input = [
    "| name | value |",
    "| --- | --- |",
    "| a | 1 |",
  ].join("\n");

  const { output, issues } = processContent(input, "test.md");

  assertEquals(issues.length, 0);
  assertEquals(output, input);
});
