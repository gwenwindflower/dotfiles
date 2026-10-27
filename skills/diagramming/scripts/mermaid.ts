import { parse, render } from "npm:pele@1.9.0";
import { type Diagnostic, DiagramError } from "./diagnostic.ts";
import { classRules, injectStyle, themeCss } from "./style.ts";
import { type Palette, type RenderMode, theme } from "./theme.ts";

interface PeleErrorShape {
  code: string;
  line: number;
  column: number;
  message: string;
  snippet: string;
}

const isPeleError = (e: unknown): e is PeleErrorShape =>
  typeof e === "object" && e !== null && "code" in e && "line" in e;

const toDiagnostic = (e: PeleErrorShape, lineOffset = 0): Diagnostic => ({
  code: e.code,
  line: e.line > 0 ? e.line + lineOffset : 0,
  column: e.column,
  message: e.message.split("\n").filter(Boolean).at(-1) ?? e.message,
  snippet: e.snippet,
});

export function checkSource(source: string, lineOffset = 0): Diagnostic[] {
  try {
    parse(source);
    return [];
  } catch (e) {
    if (isPeleError(e)) return [toDiagnostic(e, lineOffset)];
    throw e;
  }
}

const fenceOpen = /^(\s*)(`{3,}|~{3,})\s*mermaid\s*$/;

export function checkMarkdown(markdown: string): Diagnostic[] {
  const lines = markdown.split("\n");
  const diagnostics: Diagnostic[] = [];
  let i = 0;
  while (i < lines.length) {
    const open = lines[i].match(fenceOpen);
    if (!open) {
      i++;
      continue;
    }
    const marker = open[2];
    const start = i;
    let end = start + 1;
    while (end < lines.length && !lines[end].trim().startsWith(marker)) end++;
    if (end >= lines.length) {
      diagnostics.push({
        code: "unclosed-fence",
        line: start + 1,
        column: 1,
        message: `mermaid fence opened with ${marker} is never closed`,
        snippet: lines[start],
      });
      break;
    }
    diagnostics.push(...checkSource(lines.slice(start + 1, end).join("\n"), start + 1));
    i = end + 1;
  }
  return diagnostics;
}

const shapes = ["rect", "polygon", "path", "circle", "ellipse"];

const peleSelectors = {
  shape: (cls: string) =>
    shapes.flatMap((s) => [`.pele-node.${cls} > ${s}`, `.pele-cluster.${cls} > ${s}`]).join(","),
  text: (cls: string) => `.pele-node.${cls} .pele-label,.pele-cluster.${cls} .pele-cluster-label`,
};

function varBlock(palette: Palette): string {
  const decls = Object.entries(palette.vars).map(([k, v]) => `--pele-${k}:${v}`).join(";");
  return `.pele{${decls};background:var(--pele-bg)}`;
}

const autoPaletteCss = (palette: Palette) => varBlock(palette) + classRules(palette, peleSelectors);

const varRef = /var\(\s*(--[\w-]+)\s*(?:,\s*([^()]*?))?\s*\)/g;

function flatten(svg: string, palette: Palette): string {
  const known = new Map<string, string>(
    Object.entries(palette.vars).map(([k, v]) => [`--pele-${k}`, v]),
  );
  const resolve = (text: string): string => {
    let out = text;
    for (let pass = 0; pass < 8 && out.includes("var("); pass++) {
      out = out.replace(
        varRef,
        (whole, name: string, fallback?: string) => known.get(name) ?? fallback?.trim() ?? whole,
      );
    }
    return out;
  };
  const rootStyle = svg.match(/^<svg[^>]*style="([^"]*)"/)?.[1] ?? "";
  for (const decl of rootStyle.split(";")) {
    const m = decl.match(/^\s*(--[\w-]+)\s*:(.*)$/);
    if (m) known.set(m[1], resolve(m[2].trim()));
  }
  const flat = resolve(svg);
  const leftover = flat.match(varRef);
  if (leftover) throw new Error(`unresolved CSS variables: ${[...new Set(leftover)].join(", ")}`);
  return flat;
}

const fontSize = 16;

export interface MermaidRenderOptions {
  mode: RenderMode;
}

export function renderMermaid(source: string, { mode }: MermaidRenderOptions): string {
  const { font } = theme;
  let svg: string;
  try {
    svg = render(source, { fontFamily: font, fontSize }).svg;
  } catch (e) {
    if (isPeleError(e)) throw new DiagramError(toDiagnostic(e));
    throw e;
  }
  if (mode === "auto") return injectStyle(svg, themeCss(mode, autoPaletteCss));
  const palette = theme.modes[mode];
  const openEnd = svg.indexOf(">") + 1;
  const head = svg.slice(0, openEnd - 1) + ` font-family="${font}" font-size="${fontSize}">`;
  const bg = `<rect width="100%" height="100%" fill="${palette.vars.bg}"/>`;
  const css = classRules(palette, peleSelectors);
  return flatten(head + bg + `<style>${css}</style>` + svg.slice(openEnd), palette);
}
