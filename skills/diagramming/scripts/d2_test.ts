import { assert, assertEquals, assertMatch, assertStringIncludes } from "jsr:@std/assert@1";
import { checkD2, renderD2 } from "./d2.ts";
import { DiagramError } from "./diagnostic.ts";

const arch = `classes: {
  accent: {style.fill: "#414559"; style.stroke: "#babbf1"; style.font-color: "#c6d0f5"}
  data: {shape: cylinder; style.fill: "#414559"; style.stroke: "#8caaee"; style.font-color: "#c6d0f5"}
}
api: API {class: accent}
wh: Warehouse {class: data}
api -> wh: SQL`;

Deno.test("checkD2 accepts valid source", async () => {
  assertEquals(await checkD2(arch), []);
});

Deno.test("checkD2 reports the line and column of a D2 error", async () => {
  const [d] = await checkD2("a -> b\nc: {\n");
  assertEquals([d.code, d.line, d.column], ["d2", 2, 4]);
  assertStringIncludes(d.message, "maps must be terminated");
});

Deno.test("dark mode repaints D2 theme slots with Frappe", async () => {
  const svg = await renderD2(arch, { mode: "dark" });
  assertMatch(svg, /\.fill-N7\{fill:#303446 !important\}/);
  assertMatch(svg, /\.stroke-B1\{stroke:#838ba7 !important\}/);
  assert(!svg.includes("@media"), "dark output has @media");
});

Deno.test("semantic classes override D2 class colors with the theme palette", async () => {
  const dark = await renderD2(arch, { mode: "dark" });
  assertMatch(dark, /\.accent > \.shape > \*\{[^}]*stroke:#babbf1 !important/);
  const light = await renderD2(arch, { mode: "light" });
  assertMatch(light, /\.accent > \.shape > \*\{[^}]*stroke:#907aa9 !important/);
  assertMatch(light, /\.data > text\{fill:#575279 !important\}/);
});

Deno.test("auto mode pairs Frappe D2 slots with Dawn for light viewers", async () => {
  const svg = await renderD2(arch, { mode: "auto" });
  assertMatch(svg, /\.fill-N7\{fill:#303446 !important\}/);
  assertMatch(
    svg,
    /@media \(prefers-color-scheme: light\)\{[^]*\.fill-N7\{fill:#faf4ed !important\}/,
  );
});

Deno.test("renderD2 passes layout flags to d2", async () => {
  const tight = await renderD2(arch, { mode: "dark", args: ["--pad", "0"] });
  const padded = await renderD2(arch, { mode: "dark", args: ["--pad", "200"] });
  const width = (svg: string) => Number(svg.match(/<svg [^>]*viewBox="0 0 (\d+)/)?.[1]);
  assert(width(padded) > width(tight) + 300, `${width(padded)} vs ${width(tight)}`);
});

Deno.test("renderD2 throws a DiagramError with the D2 diagnostic for invalid source", async () => {
  try {
    await renderD2("a -> b\nc: {\n", { mode: "auto" });
  } catch (e) {
    assert(e instanceof DiagramError);
    assertEquals(e.diagnostic.line, 2);
    return;
  }
  throw new Error("renderD2 did not throw");
});
