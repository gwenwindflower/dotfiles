---
name: managing-issues
description: Use whenever working with Linear or GitHub issues — searching, reading, creating, clarifying, triaging, labeling, closing, or organizing them into projects and proposals, including Linear↔GitHub synced repos.
---

# Managing Issues

A good issue is graspable by a human in 30 seconds and executable by a coding agent without follow-up questions. Two things carry the whole system: the human/agent description split, and the readiness labels. Everything else is deliberately low ceremony — structure earns its place by carrying information, never by looking complete.

Issues live on two platforms with distinct jobs. GitHub is for customers: they see we understand their problem, check progress, and give feedback there. Linear is for us: prioritizing and executing the work. Synced pairs mirror the shared fields — title and description must serve both audiences at once, which is exactly what the description format and the generalize-the-body rule achieve — while everything surface-specific goes to its surface: customer names, demand records, and exact figures to Linear; public narrative and progress to GitHub. Readiness labels and the gate are Linear-only.

## Jobs

- [searching](searching.md) — semantic/hybrid search on both trackers: `gh --search-type` and Linear GraphQL via `linear-cli api`; the default for duplicate checks and "are there issues about X?"
- [github-sync](github-sync.md) — how Linear↔GitHub sync works: GitHub-first creation and twin retrieval, what mirrors, public vs private surfaces, closing/duplicate/unlink patterns
- [clarify](clarify.md) — rewrite an existing issue into the description format: research depth, open decisions, metadata sync, sync guardrails
- [compact-rubric](compact-rubric.md) — how the readiness gate grades issues; predict its grade, never award it

## Core rules

- [Search](searching.md) for duplicates on both trackers and read local conventions (labels, statuses, recent similar work) before creating, closing, or restructuring. Enrich or link existing work when it already represents the outcome.
- Follow explicit direction first, then local convention; ask only when an unresolved choice would materially change the result.
- An explicit create/update request is write approval. Otherwise propose the structure and get sign-off before calling write tools.
- Titles name the outcome — scannable, no numbering, prefixes, or implementation detail.
- Customer identity stays out of descriptions. Names, support links, and customer screenshots live in customer requests and attachments; never delete those — they are the canonical demand record.
- Generalize the body: a specific belongs there only when it changes how the problem is solved. Anonymizing a customer's numbers ("a workspace with ~1,800 orphaned schedules") is not generalizing — a detail that matters only for impact goes in a Linear comment, where the customer can be named plainly and the specifics kept exact. The same kind of number can cut either way: "export fails past 100 columns" stays in the body because it reproduces the bug; "the customer has ~340 affected dashboards" moves to Linear because it only sizes the pain. Customer details are never a reason to keep an issue internal ([creating on a synced pair](github-sync.md)).
- One label per concept. Where the workspace has near-duplicate labels (`✨ feature-request` and `✨ Feature Request`), use the kebab-case one and remove the other; label sync between GitHub and Linear can re-add the duplicate, so check labels after a synced edit.
- Customer demand is recorded automatically: sharing the GitHub link in the customer's Slack thread links it as a customer request on the Linear twin. Never attach the thread or write a comment naming the customer or their ask. Add a Linear comment only for a specific that shapes the work but doesn't belong in the public body (exact figures, internal repro data).
- Comments hold the same concision bar as the description: a tight addition of genuinely new information, never an overflow valve for detail the body rightly omitted. A well-written issue does not need a companion essay.
- Never fabricate. Repro steps, root causes, and entry points are verified firsthand, labeled unverified, or omitted. Static verification (the file exists, the symbol is there, the PR did what the comment says) counts as firsthand — a live repro isn't required to cite a path.

## Structure

- One issue by default, written in the description format from its first version — born ready, not clarified later. Add the agent brief only from verified evidence; a missing brief beats a fabricated one, and a later [clarify](clarify.md) pass can add it. Self-check against the [compact rubric](compact-rubric.md) to predict the grade the gate will give.
- Filing on someone else's behalf: frame the problem as an ask and leave solution ownership with the assignee.
- Related work links split by audience. Does it help customers follow the narrative and progress across multiple issues? Then a dedicated links section in the GitHub body or comments is right — an umbrella or batch issue serving as the public progress surface. Does it help engineers find related work not already associated via project or parent? Then use Linear's relation fields — right for partial-but-important overlaps, and for batches meant to land together that have no project or parent home. Outside those two jobs, don't dump `## Related` lists in descriptions: a link must earn its place, topical similarity alone never qualifies, and no relations beats padded ones. Blocking relations only when one issue's output is another's required input — likely sequence alone is not a dependency.
- A project is coordination structure, not a folder: establish one only for committed ownership, roadmap reporting, or release needs. Shared rationale and cross-cutting links live in the project description or doc; issues stay locally actionable and link back rather than copying context. Milestones mark meaningful checkpoints (roughly five or more issues each), never status, priority, or sequence.
- Task- and project-oriented documents — shared framing for a cluster of related issues, design rationale, project anchors — are Linear Docs, not Notion or Google Drive. A doc needs a project home.

## Readiness labels

An automated gate reviews each issue, applies one readiness label, and leaves an "AI readiness review" comment. **Never apply `ai-ready` yourself.** That label dispatches a coding agent to build the issue, so a wrong award spends real compute and lands unreviewed work. Only the gate has the evidence and authority to grant it; it re-grades on meaningful edits, so a well-written issue earns the label without anyone setting it. Your only readiness-label writes are `needs-decisions` when you surface an open decision, and removing `needs-clarification` after a [clarify](clarify.md) pass.

| Label | Means | Cleared by |
| --- | --- | --- |
| `ai-ready` | An agent can successfully execute the brief; gate-awarded only, never set by hand | — |
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
- Flag demand affirmatively — which customers, how many, the stakes — in generalized form in the body; the customer request link carries the identity. Never write "no customer demand": an issue without a linked ask almost always means the link was forgotten, not that nobody asked. When nothing is attached, omit demand and state what is affirmatively known.
- Separate the requested outcome from proposed solutions; mark unvalidated ideas as proposals. `## Open decisions` names each unresolved product call — its presence pairs with the `needs-decisions` label and means not agent-ready.
- Repro carries a status marker: ✅ Reproduced (and by whom); 📸 Corroborated — customer evidence (screenshot, recording, error output) matches a code read that explains it, no live run; or ⚠️ Unreproduced — from customer report. Never present unverified steps as confirmed.
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
