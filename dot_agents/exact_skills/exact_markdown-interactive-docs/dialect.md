# Source Dialect

One source file, top to bottom: frontmatter → page heading + lede → optional Callout → optional Legend → sections. The build fails with a source line number on any structural violation.

## Frontmatter

```yaml
---
title: Q3 Data Platform Onboarding    # browser tab title; also derives the localStorage key
eyebrow: September 2026               # kicker above the h1; repeated right-side in the footer
footer: Acme × DataCo — onboarding    # left side of the footer
---
```

All three keys are required. Content is markdown-only — styling never goes in frontmatter.

## Constructs

### Page heading and lede

Exactly one `# Heading`. Paragraphs after it (before any `##`) render as the lede; `**bold**` spans render strong in ink.

### Callout — `## Callout: <title>`

At most one. Renders a dashed callout box (hidden in print). Paragraphs become the note; task lines become persisted checkboxes:

```markdown
- [ ] Confirm the datasets {#datasets}
```

Every task needs a stable `{#id}` — it keys the checkbox state in localStorage (`mid-tasks-<slugged title>`), so reworded tasks keep their state and duplicate ids fail the build.

### Legend — `## Legend: <title>`

At most one; the title is structural only (not rendered). 1–3 numbered entries:

```markdown
1. **Core** — Required for everyone; taught live.
2. **Useful** — Shown live, linked resources afterwards.
```

Renders badge cards, and — if any item uses a `[tN]` tag — a "Focus on" filter chip row that dims non-matching rows. Entry order defines badge styles: t1 accent fill, t2 accent tint, t3 neutral fill. More than 3 kinds means extending the template first.

### Sections — `## Kicker — Title` or `## Title`

Text before the first ` — ` is the kicker (small accent line above the h2); omit the dash for a plain section. Paragraphs after render as the subtitle. Tables and code blocks are allowed at section level.

### Blocks — `### Title — Chip` or `### Title`

A ruled heading inside a section; text after ` — ` becomes a small filled chip (audience, status, owner…). Items live inside blocks.

### Items — `#### Label — Title [tags]`

The collapsible rows. Text before the first ` — ` is the label, rendered in a fixed-width mono column (time range, ID, date); omit the dash for no label. Because ` — ` splits label from title, keep spaced em dashes out of row titles — use commas or colons.

Trailing `[tag]`s, in any order:

| Tag | Effect |
| --- | --- |
| `[t1]`…`[t3]` | badge from the legend entry of that number |
| `[flat]` | non-collapsible divider row (breaks, lunch, separators) |
| anything else | filled flag chip in the summary row (`[Led by Will]`, `[Beta]`) |

Item bodies: paragraphs render as detail text; bullet lists render in a washed panel where a fully-bold item (`- **Group name**`) becomes an uppercase group header; tables and fenced code blocks render styled.

### Tables and code

GFM tables (header, `| --- |` separator, body) and fenced code blocks work at section, block, and item-body level. Wide tables scroll inside their own container.

### Inline

| Syntax | Renders |
| --- | --- |
| `**bold**` | strong |
| `` `code` `` | inline code |
| `[text](url)` | small arrow link, opens in new tab |
| `[Chip]` | outlined chip in body text (roles, statuses); on `####` headings it's a filled flag instead |

## Example

```markdown
---
title: Q3 Data Platform Onboarding
eyebrow: September 2026
footer: Acme × DataCo — onboarding plan
---

# Data platform onboarding

Three weeks from access request to first shipped dashboard.

## Callout: Before kickoff

- [ ] Provision workspace access for the full cohort {#access}

## Legend: Priorities

1. **Core** — Required for everyone; taught live with Q&A.
2. **Useful** — Shown live, linked resources afterwards.

## Week 1 — Orientation

Get oriented, get access, meet the data.

### Morning — Everyone

#### 9:30–10:45 — Find and read dashboards [t1]

The consumption loop end to end.

- **Navigate**
- Search, spaces, and favorites [Viewer] [Docs](https://example.com/docs/nav)
- **Go deeper**
- Drill into underlying records

#### 10:45–11:00 — Break [flat]

#### 11:00–12:00 — First queries [t2] [Bring a laptop]
```

## Template contract

`build.ts` fills three slots — `__TITLE__`, `__CONTENT__`, `__TASKKEY__` — and emits markup bound to these hooks. A restyled template may change anything else, but these must survive:

| Hook | Used by |
| --- | --- |
| `details.item[data-badge]`, `.item-title`, `.item-body`, `.item-list`, `li.group`, `.label`, `.chev` | collapsible rows, expand/collapse |
| `.flat-row`, `.flat-label` | divider rows |
| `.chip[data-badge]`, `#expand-all`, `#collapse-all`, `.controls` | filter + expand JS, print hiding |
| `:root[data-badge="N"]` dim rules | filtering |
| `.callout`, `.task[data-task]`, `.t-label`, `.box` | persisted checkboxes, print hiding |
| `.badge.t1/.t2/.t3`, `.badge-card`, `.legend` | legend + item badges |
| `.eyebrow`, `.lede`, `.sec-head`, `.kicker`, `.block-head`, `.head-chip` | header/section chrome |
| `.tag`, `.flag`, `.mlink`, `pre.code`, `.table-wrap` | inline chips, links, code, tables |
| `prefers-color-scheme` tokens + `:root[data-theme]` overrides | light/dark, host theme toggles |
| `beforeprint` expand + `@media print` rules | PDF-quality printing |
