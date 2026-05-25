# Form: Audit

The audit form is a written deliverable a consultant hands to a paying client, or an internal reviewer hands to a stakeholder who hired them to assess something. The audience is a busy decision-maker who already knows the system being audited and wants findings, evidence, and prioritized recommendations they can act on. The deliverable reads as a professional assessment — not a documentation site reconstructing their world.

## Structural conventions

- **Lead with the finding.** Each section header is the finding itself or a short paraphrase of it. The first sentence restates the finding as a complete sentence.
- **Pair each finding with its recommendation exactly once.** Adjacent paragraphs in the same section, or a finding that links to a recommendation living in its proper home (a GitHub issue, a Linear ticket, a Notion database row, a dedicated implementation doc). The link is what matters, and neither half gets restated elsewhere in the deliverable. Duplication causes drift as one copy gets updated and the other doesn't.
- **Group findings by subject-matter area.** Reliability, performance, cost, architecture, practices — whatever cuts the work the way the audience will think about acting on it. Avoid grouping by severity alone; severity is an attribute of each finding, not a primary organizer.
- **Recommendations with a natural order land as an ordered sequence.** State the ordering criterion explicitly (deploy risk, dependency chain, cost-of-delay) and tie per-item rationale to it.
- **Call out what's deliberately deprioritized.** Patterns the auditor noticed and chose not to recommend action on belong in their own short section. Shows scope was considered, not missed.

## Form-specific anti-patterns

(Universal audience-recap and doc-site-reflex anti-patterns live in `SKILL.md` — these are the audit-shaped ones on top.)

- Severity tags as the primary organizing axis instead of subject-matter areas
- Open-ended "recommendations" sections detached from findings — readers shouldn't have to triangulate
- "Next steps" sections that restate recommendations already paired with findings
- Executive summaries that recap the findings rather than land the highest-leverage one or two

## Short exemplar

Fictional snippet — Acme Logistics, reliability section of a data platform audit:

````markdown
# Pipeline reliability findings

## Two production pipelines drop late-arriving data via `LatestOnlyOperator`

Roughly 4% of orders for the previous calendar day arrive after the `orders_daily` DAG run completes — based on a one-week sample comparing `dim_orders` row counts to the source `orders.created_at` distribution. The `LatestOnlyOperator` skips the historical backfill that would catch them, so those rows never land in the warehouse. The same pattern applies to `customers_daily`; impact there is smaller (under 1%) but the structural cause is identical.

Recommendation: replace the `LatestOnlyOperator` on these two DAGs with a lookback window — probably 3 days, given the late-arrival distribution. Cost is a small repeated re-read against source; benefit is a fact table that matches OLTP totals at month-end close.

Open: I haven't confirmed whether the missing rows show up downstream in the `finance_close` views, which apply their own reconciliation. If they do, user-visible impact is limited to the BI dashboards. Worth a 30-minute check before scoping the fix.

## `XS_INGEST` autosuspend is 600s; 60s would cut idle cost without touching workload

`XS_INGEST` handles the Snowpipe loads. Snowpipe credit usage is unaffected by warehouse autosuspend, but the dbt staging models sharing the warehouse keep it warm between off-cycles. A spot check of the credit timeline shows 4–8 idle hours per day on this warehouse — the autosuspend timer keeps it alive between batches that burst in seconds but average minutes apart.

Recommendation: lower autosuspend on `XS_INGEST` to 60s. Quick to revert if dbt cold-starts become a noticeable tax (they shouldn't — the staging models are sub-second).

## Reliability patterns deliberately not prioritized

`customer_lifetime_value_v3` has stale dependencies pointing at the v2 chain; cleanup is a day's work but blocks nothing. The Snowflake resource monitor sits at the account level rather than per-team — correct for now, since the team is small enough that account-level visibility suffices.

## Suggested sequence

The two fixes are independent and small; order by deploy risk, lightest first:

1. **Autosuspend tweak.** Instantly revertable — ship first to exercise the change-management path with near-zero blast radius.
2. **`LatestOnlyOperator` change.** Touches DAG semantics and changes what data lands in the warehouse — review in standup before merging, watch the first two daily runs.
````

## Form-specific self-check

- [ ] Each finding paired with its recommendation exactly once, co-located or linked to a single source of truth
- [ ] Findings grouped by subject-matter area, not by severity alone
- [ ] If recommendations have a natural order, sequenced with the criterion stated explicitly
- [ ] What's deliberately deprioritized called out in its own short section where relevant
