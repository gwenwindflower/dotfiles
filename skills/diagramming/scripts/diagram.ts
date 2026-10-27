import { parseArgs } from "jsr:@std/cli@1/parse-args";
import { checkD2, renderD2 } from "./d2.ts";
import { type Diagnostic, DiagramError, formatDiagnostic } from "./diagnostic.ts";
import { checkMarkdown, checkSource, renderMermaid } from "./mermaid.ts";
import type { RenderMode } from "./theme.ts";

type Lang = "mermaid" | "d2";

const usage = `diagram.ts — check and render Mermaid and D2 in the diagram theme

Usage:
  diagram.ts check <file.mmd|file.md|file.d2>...
  diagram.ts render <file.mmd|file.d2|-> [--lang mermaid|d2] [--mode auto|light|dark]
                    [-o out.svg] [-- d2 flags]

check   Parses each .mmd or .d2 file, or every mermaid fence in a .md file.
        Prints path:line:col [code] message for each failure; exits 1 if any fail.
render  Writes an SVG themed Catppuccin Frappe (dark) and Rose Pine Dawn (light)
        to -o or stdout. Mermaid renders through pele; D2 through the d2 CLI,
        with flags after -- passed to it (--layout elk, --pad 0).
        --mode auto (default) embeds both schemes for browsers; light or dark
        writes literal colors for rasterizers:
          diagram.ts render d.d2 --mode dark | rsvg-convert -z 2 -o d.png
        --lang is required for stdin and inferred from .mmd, .mermaid, or .d2.

Permissions: --allow-read --allow-run=d2, plus --allow-write for -o.`;

const langByExtension: Record<string, Lang> = { mmd: "mermaid", mermaid: "mermaid", d2: "d2" };

const langOf = (path: string): Lang | undefined => langByExtension[path.split(".").pop() ?? ""];

async function check(path: string): Promise<Diagnostic[]> {
  const text = await Deno.readTextFile(path);
  if (path.endsWith(".md")) return checkMarkdown(text);
  const lang = langOf(path);
  if (lang === "d2") return checkD2(text);
  if (lang === "mermaid") return checkSource(text);
  throw new UsageError(`${path}: check reads .mmd, .mermaid, .d2, or .md files`);
}

class UsageError extends Error {}

async function main(argv: string[]): Promise<number> {
  const args = parseArgs(argv, {
    string: ["mode", "output", "lang"],
    boolean: ["help"],
    alias: { o: "output", h: "help" },
    default: { mode: "auto" },
    "--": true,
  });
  const [command, ...paths] = args._.map(String);
  if (args.help || !command) {
    console.log(usage);
    return command || args.help ? 0 : 2;
  }

  if (command === "check") {
    if (paths.length === 0) throw new UsageError("check needs at least one file");
    let failed = 0;
    for (const path of paths) {
      const ds = await check(path);
      ds.forEach((d) => console.error(formatDiagnostic(path, d)));
      if (ds.length) failed++;
      else console.error(`${path}: ok`);
    }
    return failed ? 1 : 0;
  }

  if (command === "render") {
    const [input] = paths;
    if (!input) throw new UsageError("render needs an input file, or - for stdin");
    const lang = (args.lang ?? (input === "-" ? undefined : langOf(input))) as Lang | undefined;
    if (lang !== "mermaid" && lang !== "d2") {
      throw new UsageError(
        input === "-" || args.lang
          ? "--lang must be mermaid or d2"
          : `${input}: can't infer the language; pass --lang mermaid or --lang d2`,
      );
    }
    const mode = args.mode as RenderMode;
    if (!["auto", "light", "dark"].includes(mode)) {
      throw new UsageError("--mode must be auto, light, or dark");
    }
    const d2Args = args["--"] ?? [];
    if (lang === "mermaid" && d2Args.length) {
      throw new UsageError("flags after -- go to d2 and don't apply to Mermaid");
    }
    const source = input === "-"
      ? await new Response(Deno.stdin.readable).text()
      : await Deno.readTextFile(input);
    try {
      const svg = lang === "d2"
        ? await renderD2(source, { mode, args: d2Args })
        : renderMermaid(source, { mode });
      if (args.output) await Deno.writeTextFile(args.output, svg);
      else console.log(svg);
      return 0;
    } catch (e) {
      if (!(e instanceof DiagramError)) throw e;
      console.error(formatDiagnostic(input === "-" ? "<stdin>" : input, e.diagnostic));
      return 1;
    }
  }

  throw new UsageError(`unknown command: ${command}`);
}

if (import.meta.main) {
  try {
    Deno.exit(await main(Deno.args));
  } catch (e) {
    if (!(e instanceof UsageError)) throw e;
    console.error(`${e.message}\n\n${usage}`);
    Deno.exit(2);
  }
}
