# Writing issues

A good issue is graspable by a human in 30 seconds and executable by a coding agent without follow-up questions. Structure earns its place by carrying information, never by looking complete. Workspace conventions (labels, readiness gates, customer rules) layer on top; see the workspace table in [linear](linear.md).

## Core rules

- [Search](searching.md) for duplicates and read local conventions (labels, statuses, recent similar work) before creating, closing, or restructuring. Enrich or link existing work when it already represents the outcome.
- Follow explicit direction first, then local convention; ask only when an unresolved choice would materially change the result.
- An explicit create/update request is write approval. Otherwise propose the structure and get sign-off before calling write tools.
- Titles name the outcome in plain language — scannable, with no numbering, implementation detail, or bracketed area prefixes such as `[Data App Themes]`. Carry area and other context in labels or metadata.
- One label per concept. Where near-duplicate labels exist (`✨ feature-request` and `✨ Feature Request`), use the kebab-case one and remove the other.
- Comments hold the same concision bar as the description: genuinely new information, never an overflow valve for detail the body rightly omitted.
- Never fabricate. Repro steps, root causes, and entry points are verified firsthand, labeled unverified, or omitted. Static verification (the file exists, the symbol is there, the PR did what the comment says) counts as firsthand.
- Filing on someone else's behalf: frame the problem as an ask and leave solution ownership with the assignee.
- Write the issue in this format from its first version. Add the agent brief only from verified evidence; a missing brief beats a fabricated one.

## Description format

Two parts: a tight human summary, then a blank line and `# Additional agent context` written as a delegation brief. Neither part has a section list. A short issue is a paragraph and a few bullets; add a header only when a block of content needs one to stay scannable. Two headers carry a contract: `## Repro` (status marker) and `## Open decisions` (calls a named owner will make). State each fact once; delete empty-value lines ("Version: unknown"). The description is sufficient to act on without opening every link; deep detail lives in the links.

### Part 1 — human summary

Bug:

```text
Grouped bar charts with value labels set to "Top" only label the taller series; shorter bars get no label (value still visible on hover). Regression — this worked previously.
- Display-only: values readable via tooltip; workaround is label position "Inside"
- Exec reporting charts are unreadable; a second report suggests stacked bars share the fault
## Repro
✅ Reproduced internally
1. Grouped bar chart, two series with different magnitudes
2. Chart config → Series → value labels "Top"
3. Shorter series renders no labels
```

Feature:

```text
Parameter options render alphabetically regardless of YAML order. Modelers want the YAML order preserved so option lists follow business logic, mirroring `order_fields_by` table config.
- Option order carries meaning (defaults first, hierarchies grouped); alphabetical sorting scrambles it
- Small, well-bounded change
## Open decisions
- Preserve YAML order always, or opt-in via config mirroring `order_fields_by`?
```

Rules:

- Tight bullets over prose paragraphs; expected vs actual in one or two lines, never mirrored paragraphs.
- Impact is never cut: who is affected, how badly, what a fix changes for them.
- Separate the requested outcome from proposed solutions; mark unvalidated ideas as proposals. `## Open decisions` lists only calls a named owner will actually make; a call the implementer can reasonably make belongs in the PR, flagged for review.
- Repro carries a status marker: ✅ Reproduced (and by whom); 📸 Corroborated — reported evidence (screenshot, recording, error output) matches a code read that explains it, no live run; or ⚠️ Unreproduced. Never present unverified steps as confirmed.
- No cause-guessing in the summary — root-cause evidence belongs in the agent brief, marked hypothesis or confirmed.
- Environment facts only when they discriminate (version, cloud/self-hosted, warehouse), folded into Repro.
- De-jargon: no "leverage/robust/utilize", no restated urgency, no headers that exist to look complete ("Suggested actions: investigate root cause").

### Part 2 — agent brief

Brief a capable colleague, not a keystroke script. Give verified evidence and boundaries; leave design choices to the implementer. A strong agent is only restricted by a prescriptive plan, especially a wrong one. Start broad; add detail later only where an attempt actually failed for lack of it.

```text
# Additional agent context
- Value-label overlap handling lives in the ECharts series config: `packages/frontend/src/components/Echarts/series.ts` (`labelLayout`)
- Prior art: PR #26679 fixed grouped bars but regressed for stacked bars — see issue comment 2026-08-04
- Hypothesis (unconfirmed): overlap detection treats same-x labels across series as colliding and drops the shorter bar's label
- Done when every bar in grouped and stacked charts shows its value label at "Top", "Inside" behavior is unchanged, and a two-series grouped chart passes a visual check at both positions; tooltips and legend untouched
```

- Entry points and prior art are evidence, not instructions. Anchor with file + symbol, not line numbers — lines rot.
- Root-cause theories are marked hypothesis or confirmed; a well-grounded hypothesis from reading the code is usually enough.
- Say what must hold when the work is done — behaviors, not test design. Never add "PR references this issue"; the link back to itself is noise.
- Non-goals and invariants only when the implementer can't discover them locally and the done criteria don't already imply them.
- Link docs and specs rather than restating them. Repo conventions (commands, test patterns) live in the repo's agent context.
