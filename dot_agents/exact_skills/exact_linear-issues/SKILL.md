---
name: linear-issues
description: Use whenever working with Linear issues — reading, creating, clarifying, triaging, labeling, or organizing them into projects and proposals.
---

# Linear Issues

A good issue is graspable by a human in 30 seconds and executable by a coding agent without follow-up questions. Two things carry the whole system: the human/agent description split, and the readiness labels. Everything else is deliberately low ceremony — structure earns its place by carrying information, never by looking complete.

## Jobs

- [clarify](clarify.md) — rewrite an existing issue into the description format: research depth, open decisions, metadata sync, sync guardrails
- [compact-rubric](compact-rubric.md) — how the readiness gate grades issues; self-check before expecting `ai-ready`

## Core rules

- Search for duplicates and read local conventions (labels, statuses, recent similar work) before creating or restructuring. Enrich or link existing work when it already represents the outcome.
- Follow explicit direction first, then local convention; ask only when an unresolved choice would materially change the result.
- An explicit create/update request is write approval. Otherwise propose the structure and get sign-off before calling write tools.
- Titles name the outcome — scannable, no numbering, prefixes, or implementation detail.
- Customer identity stays out of descriptions — refer to segment and scale ("enterprise customer, ~3,000 operational users"). Names, support links, and customer screenshots live in customer requests, attachments, and top-level comments; never delete those — they are the canonical demand record.
- Never fabricate. Repro steps, root causes, and entry points are verified firsthand, labeled unverified, or omitted. Static verification (the file exists, the symbol is there, the PR did what the comment says) counts as firsthand — a live repro isn't required to cite a path.

## Structure

- One issue by default, written in the description format from its first version — born ready, not clarified later. Add the agent brief only from verified evidence; a missing brief beats a fabricated one, and a later [clarify](clarify.md) pass can add it. Self-check against the [compact rubric](compact-rubric.md) before labeling `ai-ready`.
- Filing on someone else's behalf: frame the problem as an ask and leave solution ownership with the assignee.
- Related relations link cohesive siblings; blocking relations only when one issue's output is another's required input — likely sequence alone is not a dependency.
- A project is coordination structure, not a folder: establish one only for committed ownership, roadmap reporting, or release needs. Shared rationale and cross-cutting links live in the project description or doc; issues stay locally actionable and link back rather than copying context. Milestones mark meaningful checkpoints (roughly five or more issues each), never status, priority, or sequence.
- Task- and project-oriented documents — shared framing for a cluster of related issues, design rationale, project anchors — are Linear Docs, not Notion or Google Drive. A doc needs a project home.

## Readiness labels

An automated gate reviews each issue, applies one readiness label, and leaves an "AI readiness review" comment. Set the label to match reality when you materially change an issue; the gate re-grades on meaningful edits.

| Label | Means | Cleared by |
| --- | --- | --- |
| `ai-ready` | An agent can successfully execute the brief | — |
| `needs-decisions` | A discrete product decision is pending, listed under `## Open decisions` | An owner making the call — including taking ownership when the issue has none |
| `needs-clarification` | The issue itself is confusing — scope drifted, contradictory, or missing facts | Anyone with context, via [clarify](clarify.md) |
| `needs-decomposition` | A poorly shaped report that is really several issues | Splitting into scoped issues |
| `human-led-high-risk` | Rare: cannot ship as a reviewable PR — irreversible migration, coordinated live rollout, direct production intervention | Human execution |

Clarity and decisions are independent: an issue can be perfectly clear yet blocked on a product call, a clear-cut problem can hide in a bad write-up, or both at once.

## Description format

The description is two parts: a tight human summary, then a blank line and `# Additional agent context` written as a delegation brief. Sections in both parts are a menu, not a template — include one only when it carries information no other section does; state each fact once in the section that best carries it; delete empty-value lines ("Version: unknown"). The description is sufficient to act on without opening every link; deep detail lives in the links.

### Part 1 — human summary

Bug:

```text
Grouped bar charts with value labels set to "Top" only label the taller series; shorter bars get no label (value still visible on hover). Regression — this worked previously.
## Repro
✅ Reproduced internally
1. Grouped bar chart, two series with different magnitudes
2. Chart config → Series → value labels "Top"
3. Shorter series renders no labels
## Impact
- Display-only: values readable via tooltip; workaround is label position "Inside"
- Enterprise customer's exec reporting charts are unreadable; second report suggests stacked bars share the fault
```

Feature:

```text
Parameter options render alphabetically regardless of YAML order. Modelers want the YAML order preserved so option lists follow business logic, mirroring `order_fields_by` table config.
## Impact
- Option order carries meaning (defaults first, hierarchies grouped); alphabetical sorting scrambles it
- Small, well-bounded change
## Open decisions
- Preserve YAML order always, or opt-in via config mirroring `order_fields_by`?
```

Rules:

- Tight bullets over prose paragraphs; expected vs actual in one or two lines, never mirrored paragraphs.
- Impact is never cut: who is affected, how badly, what a fix or ship changes for them — concise, but present. Same for bug context and customer demand. Preserve the customer's exact wording when it is safe and sharper than a paraphrase.
- Flag demand affirmatively — which customers, how many, the stakes — but never write "no customer demand": an issue without a linked ask almost always means the link was forgotten, not that nobody asked. When nothing is attached, omit demand and state what is affirmatively known.
- Separate the requested outcome from proposed solutions; mark unvalidated ideas as proposals. `## Open decisions` names each unresolved product call — its presence pairs with the `needs-decisions` label and means not agent-ready.
- Repro carries a status marker: ✅ Reproduced (and by whom) or ⚠️ Unreproduced — from customer report. Never present unverified steps as confirmed.
- No cause-guessing in the summary — root-cause evidence belongs in the agent brief, marked hypothesis or confirmed.
- Environment facts only when they discriminate (version, cloud/self-hosted, warehouse), folded into Repro — not a section of unknowns.
- De-jargon: no "leverage/robust/utilize", no restated urgency ("this is urgent due to deadlines" after Impact already says it), no sections that exist to look complete ("Suggested actions: investigate root cause").

### Part 2 — agent brief

Brief a capable colleague, not a keystroke script. Give verified evidence and boundaries; leave design choices to the implementer. Engineers push back on prescriptive implementation plans — especially wrong ones — and a strong agent is only restricted by them. Start broad; add detail in a later pass only where an attempt actually failed for lack of it. The implementer will run the code — you don't need to pre-run it for them.

```text
# Additional agent context
## Where to start
- Value-label overlap handling lives in the ECharts series config: `packages/frontend/src/components/Echarts/series.ts` (`labelLayout`)
- Prior art: PR #26679 fixed grouped bars but regressed for stacked bars — see issue comment 2026-08-04
## Root cause
Hypothesis (unconfirmed): overlap detection treats same-x labels across series as colliding and drops the shorter bar's label.
## Verifications
- Every bar in grouped and stacked charts shows its value label at position "Top"
- "Inside" label behavior unchanged
- A two-series grouped chart passes a visual check at both positions
## Scope
- Chart label rendering only; tooltips and legend untouched
```

Menu: `## Where to start` (verified entry points and prior art — evidence, not instructions), `## Root cause` (bugs — hypothesis vs confirmed; a well-grounded hypothesis from reading the code is fine, and usually all that's needed), `## Verifications` (behaviors that must hold when the work is done — name the behaviors, not the test design), `## Constraints` (invariants and patterns the implementer can't discover locally), `## Scope` (non-goals — only when a boundary genuinely needs stating and Verifications don't already imply it).

- Anchor with file + symbol, not line numbers — lines rot.
- Repo conventions (commands, test patterns, TDD) live in the repo's agent context — don't restate them.
- Verifications define done. No `Done:` restatement, and never "PR references this issue" — PR↔issue linking is repo convention, and on the issue's own page it renders as a link back to itself.
