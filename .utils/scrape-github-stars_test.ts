import { assertEquals } from "@std/assert";
import {
  csvEscape,
  parseListIndexHtml,
  type RepoCard,
  toCsvRow,
} from "./scrape-github-stars.ts";

Deno.test("csvEscape passes through plain values", () => {
  assertEquals(csvEscape("hello"), "hello");
  assertEquals(csvEscape("  trimmed  "), "trimmed");
});

Deno.test("csvEscape quotes commas and quotes", () => {
  assertEquals(csvEscape("a, b"), '"a, b"');
  assertEquals(csvEscape('he said "hi"'), '"he said ""hi"""');
});

Deno.test("csvEscape collapses newlines to spaces", () => {
  assertEquals(csvEscape("line1\nline2"), "line1 line2");
});

Deno.test("toCsvRow assembles a full row", () => {
  const card: RepoCard = {
    name: "owner/repo",
    url: "https://github.com/owner/repo",
    description: "A, useful tool",
    language: "Rust",
  };
  assertEquals(
    toCsvRow(card, "dev-tools"),
    'dev-tools,owner/repo,https://github.com/owner/repo,"A, useful tool",Rust',
  );
});

Deno.test("parseListIndexHtml extracts unique slugs", () => {
  const html = `
    <a href="/stars/winnie/lists/dev-tools">Dev Tools</a>
    <a href="/stars/winnie/lists/dev-tools">Dev Tools (dup)</a>
    <a href="/stars/winnie/lists/ai_agents">AI Agents</a>
    <a href="/stars/winnie/lists/data">Data</a>
    <a href="/stars/someone-else/lists/should-ignore">No</a>
  `;
  assertEquals(parseListIndexHtml(html, "winnie"), [
    "ai_agents",
    "data",
    "dev-tools",
  ]);
});

Deno.test("parseListIndexHtml handles users with regex-special chars", () => {
  const html = `<a href="/stars/user.name/lists/foo">x</a>`;
  assertEquals(parseListIndexHtml(html, "user.name"), ["foo"]);
});
