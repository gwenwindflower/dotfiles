---
name: markdown-interactive-docs
description: Build self-contained interactive HTML from structured Markdown and a customizable template with a bundled Deno compiler. Use when a schedule, runbook, or checklist needs collapsible rows, filters, persisted tasks, or print styling; also when editing a project that uses this skill's template.html and build.ts pattern. Skip ordinary Markdown with no HTML output.
---

# Markdown Interactive Docs

Use a one-way build: content lives in a structured Markdown source, presentation and interaction live in `template.html`, and `build.ts` compiles them into one HTML file. Treat `dist/` as generated output.

## Workflow

1. Read [dialect](dialect.md) before authoring or editing a source file.
2. Keep content in Markdown and presentation in the template.
3. Copy the template when the project owns its visual design; otherwise use the bundled default.
4. Build after every source, template, or compiler edit and fix validation errors at the reported source lines.
5. Inspect the HTML in a browser and print preview before delivery.

```bash
SKILL_DIR=~/.agents/skills/markdown-interactive-docs
cp "$SKILL_DIR/assets/template.html" ./template.html
deno run --allow-read="$SKILL_DIR,$PWD" --allow-write="$PWD" \
  "$SKILL_DIR/scripts/build.ts" doc.md -t template.html
```

Output lands at `dist/<stem>.html`; override it with `-o`. Omit the copy step and `-t` to use the default template.

## Extension boundaries

- Restyle a project-owned template freely, but preserve the `__TITLE__`, `__CONTENT__`, and `__TASKKEY__` slots plus the hooks in [dialect](dialect.md).
- Keep deliverables self-contained. Embed fonts and images with `data:` URIs instead of external requests.
- For project-specific validation, copy `build.ts` into the project and add checks after parsing. Change the bundled compiler and dialect together only when the reusable format itself needs another construct.
- Never hand-edit built HTML; edit the source, template, or compiler and rebuild.

## Delivery

The result is a self-contained HTML file that can be opened locally, hosted as a static file, or printed to PDF.

- [Claude Artifact delivery](claude-code.md)
- [Codex Sites delivery](codex.md)
