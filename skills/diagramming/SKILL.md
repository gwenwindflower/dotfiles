---
name: diagramming
description: Mermaid and D2 diagrams - architecture, sequence, ER, state, flow, git graphs, timelines, charts. One checker and themed renderer for both, style rules, SVG and raster export.
---

# Diagramming

Diagram source is the maintainable artifact; exports are generated outputs. Model one coherent idea per diagram at a consistent abstraction level, with nodes derived from real code, config, or events — never invented for visual balance.

## Language choice

Both languages export themed SVG, and every raster format comes from that SVG. Pick by the diagram and the job:

| Reach for | When |
| --- | --- |
| Mermaid | The source lives in Markdown (GitHub, Obsidian, Artifacts, docs), the content matches one of the 32 [diagram types](mermaid.md#diagram-types), or readers will edit it in place |
| D2 | Dense nested architecture, ERDs from real schemas, orthogonal routing (ELK), multi-board layers and steps, or precise control over layout and shapes |
| Either | The user names one; never substitute silently |

## Style rules

Both languages, every diagram:

- Theme through the semantic classes in [themes](themes.md): Catppuccin Frappe for dark, Rosé Pine Dawn for light. No ad-hoc hex in diagram source beyond the `classDef` block themes.md gives.
- Color reinforces meaning, never carries it alone; every explicit fill pairs with an explicit text color.
- 12–16 nodes maximum — split rather than shrink, and mark truncation with an explicit `+N more` node.
- Containers and subgraphs express real boundaries (ownership, deployment, trust), not decoration.
- One scenario per diagram; happy path and error path are two diagrams.
- Label edges with the protocol, call, or payload (`HTTPS 443`, `POST /payments`), not verbs; keep decision-label vocabulary consistent within a diagram.
- Check, render, and inspect before delivering; never commit an unrendered diagram. Keep source alongside exports.

## Workflow

1. Infer the audience and abstraction level from the request and nearby docs; ask only when the choice materially changes the diagram.
2. Pick the diagram type from the [Mermaid type table](mermaid.md#diagram-types) before choosing a language. Git history, schedules, timelines, schemas, and charts each have a dedicated type; a flowchart is for flow.
3. Author with stable keys, concise labels, and semantic classes.
4. Check it with `diagram.ts check`, plus `d2 fmt` for D2. Exit status is authoritative.
5. Render, rasterize, and inspect for hierarchy, label clipping, collisions, contrast in both modes, and readable scale.
6. Deliver source plus requested exports, noting meaningful layout or portability constraints only.

## Checking and rendering

`scripts/diagram.ts` checks and renders both languages in the [theme](themes.md). Mermaid renders through pele; D2 through the `d2` CLI, with any flags after `--` passed to it.

```bash
DIAGRAM=~/.agents/skills/diagramming/scripts/diagram.ts
deno run --allow-read --allow-run=d2 "$DIAGRAM" check flow.mmd notes.md arch.d2
deno run --allow-read --allow-run=d2 --allow-write=. "$DIAGRAM" render arch.d2 -o arch.svg -- --layout elk
deno run --allow-read --allow-run=d2 "$DIAGRAM" render flow.mmd --mode light | rsvg-convert -z 2 -o flow.png
```

`check` reads `.mmd`, `.d2`, and the mermaid fences in `.md` files. `render` infers the language from `.mmd`, `.mermaid`, or `.d2`, and needs `--lang mermaid|d2` for stdin.

| `--mode` | Output | Use for |
| --- | --- | --- |
| `auto` (default) | Frappe, with a `prefers-color-scheme: light` block for Dawn | SVG viewed in a browser: docs sites, committed SVGs, Artifacts |
| `light` (Dawn), `dark` (Frappe) | Literal colors only | Anything rasterized, and destinations that ignore CSS |

The theme's semantic classes override the colors written in the source in every mode.

## Rasterizing

`rsvg-convert` turns any SVG from either language into PNG, PDF, or PS; pipe through ImageMagick for other formats. It reads D2's embedded fonts and the theme's CSS, where resvg falls back to a serif font on D2 output. Rasterizers ignore media queries, so always pass `--mode light` or `--mode dark` before piping.

```bash
rsvg-convert -z 2 diagram.svg -o diagram.png
rsvg-convert -f pdf diagram.svg -o diagram.pdf
rsvg-convert diagram.svg | magick - diagram.webp
```

## References

- [mermaid](mermaid.md) — diagram types, check codes, destinations, syntax traps, styling
- [d2-language](d2-language.md), [d2-patterns](d2-patterns.md), [d2-cli](d2-cli.md)
- [themes](themes.md) — Frappe and Dawn palettes, semantic classes, per-language expressions
