# Lightdash workspace

Conventions for the `lightdash` Linear workspace (`linear-cli --profile lightdash`), on top of [writing issues](issues.md).

Lightdash work is planned in Linear. Create issues in Linear and stop there; don't open a GitHub issue alongside it. Some Linear teams sync with GitHub repos, which matters only in a few situations: Winnie asks for a public GitHub issue, the task is cleaning up old GitHub issues, or the issue being edited shows a sync banner. Load [github-sync](github-sync.md) for those, and only those.

| Job | Doc |
| --- | --- |
| Rewrite an existing issue into the description format | [clarify](clarify.md) |
| Predict the readiness gate's grade | [compact-rubric](compact-rubric.md) |
| Public GitHub issues, old GitHub issue cleanup, synced pairs | [github-sync](github-sync.md) |

## Customers

- Customer identity stays out of descriptions. Names, support links, and customer screenshots live in customer requests and attachments; never delete those — they are the canonical demand record.
- Generalize the body: a specific belongs there only when it changes how the problem is solved. "Export fails past 100 columns" stays in the body because it reproduces the bug; "the customer has ~340 affected dashboards" goes in a Linear comment, where the customer can be named plainly and the figure kept exact, because it only sizes the pain.
- When a Slack thread is the source of the issue or is included with it, add it as a customer request on the Linear issue, never as a comment naming the customer or their ask. Find the customer by name or by the thread's Slack channel, then create the request with the thread as its source:

  ```sh
  linear-cli --profile lightdash api query -o json '{
    customers(filter: { name: { containsIgnoreCase: "<name>" } }) { nodes { id name } }
  }'
  linear-cli --profile lightdash api query -o json 'mutation($c: String!, $i: String!, $u: String!) {
    customerNeedCreate(input: { customerId: $c, issueId: $i, attachmentUrl: $u }) { success need { id } }
  }' -v c=<customer id> -v i=<ENG-123> -v u=<slack thread url>
  ```

  Filter on `slackChannelId: { eq: "<channel>" }` instead of `name` when the channel is known. `body` adds the ask in the customer's words; `priority: 1` marks it important.
- Flag demand in the summary — which kind of customers, how many, the stakes — in generalized form; the customer request carries the identity. Never write "no customer demand": a missing ask almost always means the link was forgotten. Keep the customer's exact wording when it is safe and sharper than a paraphrase.
- Repro from a customer report without a live run is ⚠️ Unreproduced — from customer report.

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
