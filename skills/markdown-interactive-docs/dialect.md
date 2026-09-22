# Markdown Dialect

Write one source in this order: frontmatter → page heading and lede → optional Callout → optional Tiers → sections. Both Callout and Tiers may be omitted. The compiler reports source line numbers for invalid Markdown structure.

## Frontmatter

```yaml
---
title: Platform Work Queue
eyebrow: Q3 Planning
footer: Acme — platform operations
---
```

All three keys are required. `title` sets the browser title and localStorage key, `eyebrow` appears above the page heading and in the footer, and `footer` sets the footer's left side.

Frontmatter accepts one-line `key: value` entries, not general YAML. Do not quote values, add inline comments, or use multiline scalars.

## Constructs

### Page heading and lede

Exactly one `# Heading`. Paragraphs after it (before any `##`) render as the lede; `**bold**` spans render strong in ink.

### Callout — `## Callout: <title>`

At most one. Renders a dashed callout box (hidden in print). Paragraphs become the note; task lines become persisted checkboxes:

```markdown
- [ ] Confirm the datasets {#datasets}
```

Every task needs a stable `{#id}` — it keys the checkbox state in localStorage (`mid-tasks-<slugged title>`), so reworded tasks keep their state and duplicate ids fail the build.

### Tiers — `## Tiers: <system>`

Optional; at most one. The system name labels the filter control and describes what the tiers measure, such as Priority, Urgency, Complexity, or Confidence. Define 1–3 entries numbered consecutively from 1:

```markdown
## Tiers: Urgency

1. **Immediate** — Resolve before other work.
2. **Soon** — Complete in the current cycle.
3. **Backlog** — Revisit when capacity permits.
```

Each entry renders as a tier card. If any item uses `[tN]`, the system name and tier labels also render as filter chips that dim non-matching rows. Entry order maps to `[t1]`, `[t2]`, and `[t3]`; items may remain un-tiered. Without a Tiers section, no tier cards or filters render.

### Sections — `## Kicker — Title` or `## Title`

Text before the first ` — ` is the kicker (small accent line above the h2); omit the dash for a plain section. Paragraphs after render as the subtitle. Tables and code blocks are allowed at section level.

### Blocks — `### Title — Chip` or `### Title`

A ruled heading inside a section; text after ` — ` becomes a small filled chip (owner, status, audience…). Items live inside blocks.

### Items — `#### Label — Title [tags]`

The collapsible rows. Text before the first ` — ` is the label, rendered in a fixed-width mono column (ID, date, time range); omit the dash for no label. Because ` — ` splits label from title, keep spaced em dashes out of row titles — use commas or colons.

Trailing `[tag]`s, in any order:

| Tag | Effect |
| --- | --- |
| `[t1]`…`[t3]` | tier defined by the Tiers entry of that number |
| `[flat]` | non-collapsible divider row (milestones, maintenance windows, separators) |
| anything else | filled flag chip in the summary row (`[Owner: API]`, `[Beta]`) |

Item bodies support paragraphs, lists, H5 groups, tables, and fenced code blocks.

### Item groups — `##### Heading`

An H5 creates a titled group inside the current item. Its paragraphs, lists, tables, and code remain inside the group until the next H5 or higher heading. Groups render as washed panels with a real `<h5>`.

Headings must use heading syntax. Never fake a group heading with a bold-only list item such as `- **Work with dashboards**`; markdownlint flags that structure and the compiler rejects it. Use:

```markdown
##### Work with dashboards

- Open a dashboard and understand what you are looking at.
- Navigate existing dashboards, charts, and search.
```

Markdown structure is the source of truth. If content does not fit the supported elements, revise the document model and its renderer instead of encoding layout with emphasis or list tricks.

### Tables and code

Pipe tables and fenced code blocks work at section, block, and item-body level. Each table row must start with `|` and include a header, `| --- |` separator, and body; escaped pipes inside cells are not supported. Wide tables scroll inside their own container. Code fence language labels are accepted but not rendered.

### Inline

| Syntax | Renders |
| --- | --- |
| `**bold**` | strong |
| `` `code` `` | inline code |
| `[text](url)` | small arrow link, opens in new tab |
| `[Chip]` | outlined chip in body text (roles, statuses); on `####` headings it's a filled flag instead |

### Internal content — `#internal`

Append `#internal` to content that belongs in the editable source but not the built HTML:

- On a paragraph or bullet, it removes only that element.
- On a heading, it removes the heading and everything structurally beneath it through the next heading of the same or higher level. For example, an internal H2 ends at the next H2 or H1; an internal H5 group ends at the next H5 or higher heading.
- Inside a fenced code block, `#internal` remains literal code.

Internal content is removed during the build, not hidden with CSS, so it does not ship in the output.

## Example

```markdown
---
title: Platform Work Queue
eyebrow: Q3 Planning
footer: Acme — platform operations
---

# Platform work queue

Planned work grouped by urgency and service area.

## Callout: Before prioritization

Confirm ownership and dependencies before committing the cycle.

- [ ] Confirm service owners {#owners}

## Tiers: Urgency

1. **Immediate** — Resolve before other work.
2. **Soon** — Complete in the current cycle.
3. **Backlog** — Revisit when capacity permits.

## Reliability — Active work

Changes that improve service health and incident response.

### API — Platform

#### OPS-142 — Restore request tracing [t1] [Owner: API]

Trace requests across service boundaries.

##### Scope

- Propagate trace context through the gateway and workers.

##### Done when

- Incident dashboards link every request to a complete trace.

#### OPS-207 — Rotate integration credentials [t2]

Move remaining integrations onto managed credentials.

#### Maintenance window — Change freeze [flat]

#### OPS-311 — Consolidate retry dashboards [t3]
```

## Template contract

`build.ts` fills three slots — `__TITLE__`, `__CONTENT__`, `__TASKKEY__` — and emits markup bound to these hooks. A restyled template may change anything else, but these must survive:

| Hook | Used by |
| --- | --- |
| `details.item[data-tier]`, `.item-title`, `.item-body`, `.item-list`, `.label`, `.chev` | collapsible rows, expand/collapse |
| `.item-group`, `.item-group h5` | structured H5 groups inside item bodies |
| `.flat-row`, `.flat-label` | divider rows |
| `.chip[data-tier]`, `#expand-all`, `#collapse-all`, `.controls` | filter + expand JS, print hiding |
| `:root[data-tier="N"]` dim rules | filtering |
| `.callout`, `.task[data-task]`, `.t-label`, `.box` | persisted checkboxes, print hiding |
| `.tier-badge.t1/.t2/.t3`, `.tier-card`, `.tiers` | tier definitions and item tiers |
| `.eyebrow`, `.lede`, `.sec-head`, `.kicker`, `.block-head`, `.head-chip` | header/section chrome |
| `.tag`, `.flag`, `.mlink`, `pre.code`, `.table-wrap` | inline chips, links, code, tables |
| `prefers-color-scheme` tokens + `:root[data-theme]` overrides | light/dark, host theme toggles |
| `beforeprint` expand + `@media print` rules | PDF-quality printing |
