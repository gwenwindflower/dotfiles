---
name: diagramming
description: Create architecture, sequence, ER, state, and flow diagrams in Mermaid or D2 with shared themes and style rules. Use when asked for any diagram, when editing .mmd files, mermaid fences, or .d2 files, or when choosing how to diagram for a destination such as GitHub, Obsidian, Confluence, docs sites, or image exports.
---

# Diagramming

Diagram source is the maintainable artifact; exports are generated outputs. Model one coherent idea per diagram at a consistent abstraction level, with nodes derived from real code, config, or events — never invented for visual balance.

## Language choice

| Situation | Use |
| --- | --- |
| GitHub markdown, PRs, wiki; Obsidian; Claude Artifacts | Mermaid fence — renders natively |
| Committed SVG/PNG exports, docs sites, slides, print | D2 |
| Dense nested architecture, ERDs from real schemas, orthogonal routing | D2 with ELK |
| Confluence, Notion, Word | Either language, delivered as a rendered PNG/SVG image |
| User names a language | That language — never substitute silently |

## Style rules

Both languages, every diagram:

- Theme through the semantic classes in [themes](themes.md) — `lightdash` for work-facing output, `frappe` for personal and Supermodel work. No ad-hoc hex in diagram source.
- Color reinforces meaning, never carries it alone; every explicit fill pairs with an explicit text color.
- 12–16 nodes maximum — split rather than shrink, and mark truncation with an explicit `+N more` node.
- Containers and subgraphs express real boundaries (ownership, deployment, trust), not decoration.
- One scenario per diagram; happy path and error path are two diagrams.
- Label edges with the protocol, call, or payload (`HTTPS 443`, `POST /payments`), not verbs; keep decision-label vocabulary consistent within a diagram.
- Validate and visually inspect the render before delivering; never commit an unrendered diagram. Keep source alongside exports.

## Workflow

1. Infer the audience and abstraction level from the request and nearby docs; ask only when the choice materially changes the diagram.
2. Pick the language from the table, then author with stable keys, concise labels, and semantic classes.
3. Validate — `d2 fmt` + `d2 validate`, or an mmdc test render — treating exit status as authoritative.
4. Render and inspect for hierarchy, label clipping, collisions, contrast in both light and dark destination modes, and readable scale.
5. Deliver source plus requested exports, noting meaningful layout or portability constraints only.

## References

- [mermaid](mermaid.md) — renderer compatibility, mmdc validation, syntax traps, styling
- [d2-language](d2-language.md), [d2-patterns](d2-patterns.md), [d2-cli](d2-cli.md)
- [themes](themes.md) — Lightdash and Frappe palettes, semantic classes, per-language expressions
