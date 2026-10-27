import {
  assert,
  assertEquals,
  assertMatch,
  assertStringIncludes,
  assertThrows,
} from "jsr:@std/assert@1";
import { checkMarkdown, checkSource, renderMermaid } from "./mermaid.ts";
import { DiagramError } from "./diagnostic.ts";

const flow = `flowchart LR
  a[API] --> b[(Warehouse)]
  classDef accent fill:#efedff,stroke:#7262FF,color:#1a1b25
  classDef data fill:#EDF0FD,stroke:#3b5bdb,color:#1c2b67
  class a accent
  class b data`;

Deno.test("checkSource accepts a valid flowchart", () => {
  assertEquals(checkSource(flow), []);
});

Deno.test("checkSource reports the line and column of a syntax error", () => {
  const [d] = checkSource("sequenceDiagram\n  A->>B: hi\n  end");
  assertEquals([d.code, d.line, d.column], ["syntax", 3, 3]);
});

Deno.test("checkSource reports text with no diagram type as unsupported", () => {
  const [d] = checkSource("not a diagram");
  assertEquals(d.code, "unsupported-diagram");
});

Deno.test("checkMarkdown maps fence errors to lines in the Markdown file", () => {
  const md = [
    "# Doc",
    "",
    "```mermaid",
    flow,
    "```",
    "",
    "Text.",
    "",
    "~~~mermaid",
    "sequenceDiagram",
    "  A->>B: hi",
    "  end",
    "~~~",
    "",
    "```ts",
    "end",
    "```",
  ].join("\n");
  const ds = checkMarkdown(md);
  assertEquals(ds.length, 1);
  assertEquals(ds[0].line, md.split("\n").indexOf("  end") + 1);
});

Deno.test("checkMarkdown reports an unclosed mermaid fence", () => {
  const [d] = checkMarkdown("```mermaid\nflowchart LR\n  a --> b\n");
  assertEquals([d.code, d.line], ["unclosed-fence", 1]);
});

Deno.test("auto mode pairs Frappe dark with Rose Pine Dawn for light viewers", () => {
  const svg = renderMermaid(flow, { mode: "auto" });
  assertStringIncludes(svg, "--pele-bg:#303446");
  assertStringIncludes(svg, "@media (prefers-color-scheme: light)");
  assertStringIncludes(svg, "--pele-bg:#faf4ed");
});

Deno.test("semantic classes override classDef colors with the theme palette", () => {
  const dark = renderMermaid(flow, { mode: "dark" });
  assertMatch(dark, /\.pele-node\.accent[^{]*\{[^}]*stroke:#babbf1 !important/);
  assertMatch(dark, /\.pele-node\.data[^{]*\{[^}]*stroke:#8caaee !important/);
  const light = renderMermaid(flow, { mode: "light" });
  assertMatch(light, /\.pele-node\.accent[^{]*\{[^}]*stroke:#907aa9 !important/);
  assertMatch(light, /\.pele-node\.data[^{]*\{[^}]*stroke:#56949f !important/);
});

Deno.test("light and dark modes leave no CSS variables for rasterizers", () => {
  for (const mode of ["light", "dark"] as const) {
    const svg = renderMermaid(flow, { mode });
    assert(!svg.includes("var("), `${mode} output still has var()`);
    assert(!svg.includes("@media"), `${mode} output still has @media`);
  }
});

Deno.test("light and dark modes declare the font as attributes for rasterizers", () => {
  const svg = renderMermaid(flow, { mode: "light" });
  assertMatch(svg, /^<svg[^>]* font-family="sans-serif" font-size="16"/);
});

Deno.test("light and dark modes paint the theme background", () => {
  assertMatch(
    renderMermaid(flow, { mode: "dark" }),
    /<rect width="100%" height="100%" fill="#303446"\/>/,
  );
  assertMatch(
    renderMermaid(flow, { mode: "light" }),
    /<rect width="100%" height="100%" fill="#faf4ed"\/>/,
  );
});

Deno.test("renderMermaid throws a DiagramError with the pele diagnostic for invalid source", () => {
  const e = assertThrows(
    () => renderMermaid("flowchart LR\n  a --> ", { mode: "auto" }),
    DiagramError,
  );
  assertEquals(e.diagnostic.code, "syntax");
});
