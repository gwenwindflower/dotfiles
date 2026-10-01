# Lightdash workspace

Conventions for the `lightdash` Linear workspace, on top of [writing issues](issues.md).

Issues live on two platforms with distinct jobs. GitHub is for customers: they see we understand their problem, check progress, and give feedback there. Linear is for us: prioritizing and executing the work. Synced pairs mirror the shared fields, so title and description serve both audiences at once, while everything surface-specific goes to its surface: customer names, demand records, and exact figures to Linear; public narrative and progress to GitHub. How the sync works: [github-sync](github-sync.md).

| Job | Doc |
| --- | --- |
| Rewrite an existing issue into the description format | [clarify](clarify.md) |
| Predict the readiness gate's grade | [compact-rubric](compact-rubric.md) |
| Create on a synced pair, close, dedupe, unlink | [github-sync](github-sync.md) |

## Customers

- Customer identity stays out of descriptions. Names, support links, and customer screenshots live in customer requests and attachments; never delete those — they are the canonical demand record.
- Generalize the body: a specific belongs there only when it changes how the problem is solved. Anonymizing a customer's numbers ("a workspace with ~1,800 orphaned schedules") is not generalizing — a detail that matters only for impact goes in a Linear comment, where the customer can be named plainly and the specifics kept exact. "Export fails past 100 columns" stays in the body because it reproduces the bug; "the customer has ~340 affected dashboards" moves to Linear because it only sizes the pain. Customer details are never a reason to keep an issue internal.
- Customer demand is recorded automatically: sharing the GitHub link in the customer's Slack thread links it as a customer request on the Linear twin. Never attach the thread or write a comment naming the customer or their ask.
- Flag demand affirmatively in the summary — which customers, how many, the stakes — in generalized form; the customer request link carries the identity. Never write "no customer demand": a missing ask almost always means the link was forgotten. Preserve the customer's exact wording when it is safe and sharper than a paraphrase.
- Repro from a customer report without a live run is ⚠️ Unreproduced — from customer report.
- Label sync between GitHub and Linear can re-add a removed duplicate label, so check labels after a synced edit.

## Readiness labels

An automated gate reviews each product issue, applies one readiness label, and leaves an "AI readiness review" comment. **Never apply `ai-ready` yourself.** That label dispatches a coding agent to build the issue, so a wrong award spends real compute and lands unreviewed work. The gate re-grades on meaningful edits, so a well-written issue earns the label without anyone setting it. Your only readiness-label writes are `needs-decisions` when you surface an open decision, and removing `needs-clarification` after a [clarify](clarify.md) pass. Self-check against the [compact rubric](compact-rubric.md) to predict the grade.

| Label | Means | Cleared by |
| --- | --- | --- |
| `ai-ready` | An agent can successfully execute the brief; gate-awarded only, never set by hand | — |
| `needs-decisions` | A discrete product decision is pending, listed under `## Open decisions` | An owner making the call — including taking ownership when the issue has none |
| `needs-clarification` | The issue itself is confusing — scope drifted, contradictory, or missing facts | Anyone with context, via [clarify](clarify.md) |
| `needs-decomposition` | A poorly shaped report that is really several issues | Splitting into scoped issues |
| `human-led-high-risk` | Rare: cannot ship as a reviewable PR — irreversible migration, coordinated live rollout, direct production intervention | Human execution |

Clarity and decisions are independent: an issue can be perfectly clear yet blocked on a product call, a clear-cut problem can hide in a bad write-up, or both at once.

Readiness labels are scoped to product issues. The gate does not review docs, analytics, Analytics Engineering (AE) team, or general ops issues, so `ai-ready` and the `needs-*` labels never go on them — the description format and [clarify](clarify.md) pass still apply, but leave the label fields alone.

### AE team labels

| Label | Means | Cleared by |
| --- | --- | --- |
| `planning` | A task is spiked out but specifics remain to be decided | Recording the decisions, then removing the label |

`planning` is the AE team's stand-in for `needs-decisions` and the readiness gate: apply it by hand when spiking out work whose shape is clear but whose details are not. Record the open specifics in the description.
