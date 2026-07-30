---
name: markdown-interactive-docs
description: Turn a rigid, hand-editable markdown source into a polished single-file interactive HTML doc — collapsible rows, legend-driven filter chips, persisted checkboxes, print-ready — via a bundled Deno build script. Use when shipping a schedule, program, plan, runbook, or checklist as a styled web page, or when editing a project that pairs a markdown source with a template.html built on this pattern. Skip for ordinary markdown that never renders to a page.
---

# Markdown Interactive Docs

Three parts, one-way flow: **content** lives in a markdown source written in a rigid dialect, **styling and interaction** live in `template.html`, and the bundled `build.ts` compiles one into the other with line-numbered validation. Never hand-edit build output, put styling in the markdown, or put content in the template.

## Quickstart

```bash
SKILL=~/.agents/skills/markdown-interactive-docs

# New project: copy the template next to the source so styling is project-owned
cp "$SKILL/assets/template.html" ./template.html

# Author the source (dialect below), then build
deno run --allow-read --allow-write "$SKILL/scripts/build.ts" doc.md -t template.html
```

Output lands at `dist/<stem>.html` (override with `-o`): one self-contained file — no external requests, light/dark aware, print-ready (printing auto-expands every row and hides the controls). Omit `-t` to build with the skill's default template.

## The dialect

Structure is fixed; only styling flexes. Full spec, rules, and a complete example: [dialect](dialect.md).

| Syntax | Renders as |
| --- | --- |
| frontmatter `title` / `eyebrow` / `footer` | tab title, kicker line, footer |
| `# Heading` + paragraphs | page heading + lede |
| `## Callout: Title` with `- [ ] task {#id}` | dashed callout box, checkboxes persisted in localStorage |
| `## Legend: Title` with `1. **Name** — desc` | badge legend cards + auto-generated filter chips |
| `## Kicker — Title` + paragraph | major section with kicker and subtitle |
| `### Title — Chip` | ruled block heading with chip |
| `#### Label — Title [t1] [Flag]` | collapsible row; `[tN]` badge from legend, other tags are flag chips, `[flat]` makes a non-collapsible divider |
| `- item` / `- **Group**` | washed bullet list / group header inside it |
| GFM table / fenced code | styled table / code block |
| `` `code` ``, `**bold**`, `[text](url)`, `[Chip]` | inline code, strong, arrow link, outlined chip |

## Styling

The copied `template.html` is the project's to restyle — tokens, fonts, spacing, whole aesthetic. Keep the contract intact: the `__TITLE__` / `__CONTENT__` / `__TASKKEY__` slots, and the class names + JS hooks listed in [dialect](dialect.md). For docs that must stay self-contained (PDFs, artifacts), embed brand fonts as base64 `data:` URIs in `@font-face` rather than linking a CDN.

## Extending the build

For domain validation, copy `build.ts` into the project and add checks after the parse — e.g. a training schedule failing the build when time-slot labels leave gaps in the day. Keep the parser and renderer intact so sources stay portable.

## Delivery

The built file is plain HTML — host it anywhere. Agent-specific publish flows live in modular docs next to this file; add `<agent>.md` for a new platform:

- [claude-code](claude-code.md) — publish as a Claude Artifact
