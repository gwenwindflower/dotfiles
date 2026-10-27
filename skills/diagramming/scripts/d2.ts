import { type Diagnostic, DiagramError } from "./diagnostic.ts";
import { classRules, injectStyle, themeCss } from "./style.ts";
import type { Palette, RenderMode } from "./theme.ts";

const slotProperties = ["fill", "stroke", "color", "background-color"];

function slots({ vars }: Palette): Record<string, string> {
  return {
    N1: vars.fg,
    N2: vars.muted,
    N3: vars.line,
    N4: vars.border,
    N5: vars.border,
    N6: vars["surface-alt"],
    N7: vars.bg,
    B1: vars.line,
    B2: vars.border,
    B3: vars.border,
    B4: vars["surface-alt"],
    B5: vars["surface-alt"],
    B6: vars.surface,
    AA2: vars.accent,
    AA4: vars.surface,
    AA5: vars["surface-alt"],
    AB4: vars.surface,
    AB5: vars["surface-alt"],
  };
}

function paletteCss(palette: Palette): string {
  const slotRules = Object.entries(slots(palette))
    .flatMap(([slot, color]) =>
      slotProperties.map((p) => `.${p}-${slot}{${p}:${color} !important}`)
    )
    .join("");
  return slotRules + classRules(palette, {
    shape: (cls) => `.${cls} > .shape > *`,
    text: (cls) => `.${cls} > text`,
  });
}

async function runD2(args: string[], source: string) {
  const child = new Deno.Command("d2", { args, stdin: "piped", stdout: "piped", stderr: "piped" })
    .spawn();
  const writer = child.stdin.getWriter();
  await writer.write(new TextEncoder().encode(source));
  await writer.close();
  const { success, stdout, stderr } = await child.output();
  const decoder = new TextDecoder();
  return { success, stdout: decoder.decode(stdout), stderr: decoder.decode(stderr) };
}

const errorLine = /^err: .*?(\d+):(\d+): (.*)$/;

function parseErrors(stderr: string, source: string): Diagnostic[] {
  const lines = source.split("\n");
  return stderr.split("\n").flatMap((text) => {
    const m = text.match(errorLine);
    if (!m) return [];
    const line = Number(m[1]);
    return [{
      code: "d2",
      line,
      column: Number(m[2]),
      message: m[3],
      snippet: lines[line - 1] ?? "",
    }];
  });
}

export async function checkD2(source: string): Promise<Diagnostic[]> {
  const { success, stderr } = await runD2(["validate", "-"], source);
  if (success) return [];
  const diagnostics = parseErrors(stderr, source);
  if (diagnostics.length === 0) throw new Error(`d2 validate failed:\n${stderr}`);
  return diagnostics;
}

export interface D2RenderOptions {
  mode: RenderMode;
  args?: string[];
}

export async function renderD2(
  source: string,
  { mode, args = [] }: D2RenderOptions,
): Promise<string> {
  const { success, stdout, stderr } = await runD2([...args, "-", "-"], source);
  if (!success) {
    const [first] = parseErrors(stderr, source);
    if (first) throw new DiagramError(first);
    throw new Error(`d2 failed:\n${stderr}`);
  }
  return injectStyle(stdout, themeCss(mode, paletteCss));
}
