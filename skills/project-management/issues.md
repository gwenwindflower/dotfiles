# Writing issues

A good issue is graspable by a human in 30 seconds and executable by a coding agent without follow-up questions. Structure earns its place by carrying information, never by looking complete. Workspace conventions (labels, readiness gates, customer rules) layer on top; see the workspace table in [linear](linear.md). Use GFM markdown conventions, with the normal markdown style and syntax requirements for codeblocks, tables, etc.

## Core rules

- [Search](searching.md) for duplicates and read local conventions (labels, statuses, recent similar work) before creating, closing, or restructuring. Enrich or link existing work when it already represents the outcome.
- Follow explicit direction first, then local convention; ask only when an unresolved choice would materially change the result.
- An explicit create/update request is write approval. Otherwise propose the structure and get sign-off before calling write tools.
- One label per concept. Where near-duplicate labels exist (`✨ feature-request` and `✨ Feature Request`), use the kebab-case one and remove the other.
- Comments hold the same concision bar as the description: genuinely new information, never an overflow valve for detail the body rightly omitted.
- Never fabricate. Repro steps, root causes, and entry points are verified firsthand, labeled unverified, or omitted. Static verification (the file exists, the symbol is there, the PR did what the comment says) counts as firsthand.
- Don't mention specs or requirement IDs unless Winnie asks or the project's docs say issues cite them.
- Write the issue in this format from its first version. Add the agent brief only from verified evidence; a missing brief beats a fabricated one.

## Plain task language

The title and the opening lines are what most readers see. Write them the way you'd say the task out loud to a teammate.

- **Title:** the task or goal in a few everyday words. No numbering, area prefixes (`[Data App Themes]`, `AI agents:`), implementation detail, or jargon a newcomer to the area wouldn't know. Area lives in labels.
- **Opening:** one or two sentences — what's wrong or wanted, and what done looks like. Context and reasons come after, only if they change how someone approaches it.
- **Voice:** plain statements addressed to no one. An issue is a shared record of a task, not a message, so it neither commands ("the app must never…") nor requests ("please change…"). Describe the problem and the outcome; how to get there belongs to whoever picks it up.

| Weak | Plain |
| --- | --- |
| `[Charts] Value label rendering regression in multi-series grouped bar layouts` | `Grouped bar charts drop value labels on shorter bars` |
| `Implement configurable ordering semantics for parameter option lists` | `Keep parameter options in YAML order` |
| `Enhance robustness of scheduler retry handling` | `Retry failed scheduled deliveries` |

## Description format

Two parts: a short human summary, then a blank line and `# Additional agent context` written as a delegation brief. That shape is the only fixed structure. Everything else molds to the issue: `Impact` when priority is critical, `Expected` vs `Actual` when a bug needs the contrast, and so on — never 'user stories' framing. A short issue is a paragraph and a few bullets; add a header only when a block of content needs one to stay scannable. Two headers carry a contract: `## Repro` (status marker) and `## Open decisions` (calls a named owner will make). The description is sufficient to act on without opening every link; deep detail lives in the links.

Every fact appears once across the title, summary, brief, and comments. Each line tells the reader something they haven't read yet: the brief adds evidence and boundaries the summary lacks, and a clear summary outcome is already the definition of done. An issue ends when its last new fact is stated.

### Part 1 — human summary

Bug, titled *Grouped bar charts drop value labels on shorter bars*:

```text
Grouped bar charts with value labels set to "Top" only label the taller series. Every bar should get its label, as it did before.

- Values still show on hover, and label position "Inside" works around it
- Exec reporting charts are unreadable; a second report suggests stacked bars have the same problem

## Repro

✅ Reproduced internally

1. Grouped bar chart, two series with different magnitudes
2. Chart config → Series → value labels "Top"
3. Shorter series renders no labels
```

Feature, titled *Keep parameter options in YAML order*:

```text
Parameter options show alphabetically instead of in the order they're written in YAML. Modelers put defaults first and group related options, and sorting scrambles that.

## Open decisions

- Always keep YAML order, or make it opt-in like the `order_fields_by` table setting?
```

Rules:

- Short bullets over prose paragraphs; expected vs actual, when used, fits in one or two lines.
- Impact, when used, says who is affected, how badly, and what a fix changes for them.
- Separate the requested outcome from proposed solutions; mark unvalidated ideas as proposals. `## Open decisions` lists only calls a named owner will actually make; a call the implementer can reasonably make belongs in the PR, flagged for review.
- Repro carries a status marker: ✅ Reproduced (and by whom); 📸 Corroborated — reported evidence (screenshot, recording, error output) matches a code read that explains it, no live run; or ⚠️ Unreproduced. Never present unverified steps as confirmed.
- No cause-guessing in the summary — root-cause evidence belongs in the agent brief, marked hypothesis or confirmed.
- Environment facts only when they discriminate (version, cloud/self-hosted, warehouse), folded into Repro.
- No restated urgency and no headers that exist to look complete ("Suggested actions: investigate root cause").

### Part 2 — agent brief

Brief a capable colleague, not a keystroke script. Give verified evidence and boundaries; leave design choices to the implementer. A strong agent is only restricted by a prescriptive plan, especially a wrong one. Start broad; add detail later only where an attempt actually failed for lack of it.

```text
# Additional agent context

- Value-label overlap handling lives in the ECharts series config: `packages/frontend/src/components/Echarts/series.ts` (`labelLayout`)
- Prior art: PR #26679 fixed grouped bars but regressed for stacked bars — see issue comment 2026-08-04
- Hypothesis (unconfirmed): overlap detection treats same-x labels across series as colliding and drops the shorter bar's label
- Must hold: stacked bars get the same fix; "Inside" labels, tooltips, and legend render as they do today
```

- Entry points and prior art are evidence, not instructions. Anchor with file + symbol, not line numbers — lines rot.
- Root-cause theories are marked hypothesis or confirmed; a well-grounded hypothesis from reading the code is usually enough.
- Done criteria, non-goals, and invariants only for what the summary doesn't already settle and the implementer can't discover locally — behaviors, not test design.
- Link docs rather than restating them. Repo conventions (commands, test patterns) live in the repo's agent context.
