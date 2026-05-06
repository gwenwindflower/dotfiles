---
name: sql-event-pattern-matching
description: Sequence and pattern-match events in SQL — funnels, sessionization, clickstream paths, time-series patterns, retention. Covers advanced window functions, gaps-and-islands, and MATCH_RECOGNIZE. Use when writing SQL over event/log/timestamped data to detect ordered patterns, segment sessions, attribute conversions, or analyze user journeys.
---

# SQL Event Pattern Matching

## When to use

Event data has an inherent order (timestamp, user, session). Aggregations alone lose that order. Reach for this skill when the question involves *sequence*: "what did users do before X", "how long between A and B", "which sessions contain pattern P", "where do users drop off", "find runs of consecutive Y".

## Pick the right tool

| Problem shape | Tool |
| --- | --- |
| "Compare each row to its neighbor" (deltas, gaps, prev/next event) | [`lag`/`lead` + window frames](window-functions.md) |
| "Group consecutive rows sharing a property" (sessions, runs, status streaks) | [Gaps and islands](window-functions.md#gaps-and-islands) |
| "Did sequence A → B → C happen, with constraints?" | [`match_recognize`](match-recognize.md) if dialect supports; else [self-joins + windows](analytical-patterns.md#funnels) |
| "Funnel conversion / drop-off / time-to-convert" | [Funnel patterns](analytical-patterns.md#funnels) |
| "Most common paths / Sankey / next-event distribution" | [Path analysis](analytical-patterns.md#clickstream-paths) |
| "Cohort retention, recurring behavior, churn windows" | [Retention](analytical-patterns.md#retention-and-cohorts) |
| "Anomalies / change points / streaks in time series" | [Time-series patterns](analytical-patterns.md#time-series) |

## Dialect support at a glance

`match_recognize` is the most expressive tool but not universal. Confirm the warehouse before using it:

- **Supported:** Snowflake, Oracle, Trino/Presto, Apache Flink SQL, Databricks (Photon, recent runtimes), Vertica, Exasol, SingleStore
- **Not supported:** BigQuery, Postgres, Redshift, DuckDB, MySQL, ClickHouse, SQL Server

For unsupported engines, every `match_recognize` query has a [window-function equivalent](match-recognize.md#porting-to-plain-sql) — uglier and slower, but always works. Window functions, `qualify`, and CTEs are the portable foundation.

## Working principles

- **Always partition.** `partition by user_id` (or session, device, account) is almost always correct — pattern matching across users is a bug.
- **Always order deterministically.** `order by event_at, event_id` — ties on timestamp will silently scramble sequences.
- **Filter before windowing when possible.** Window functions run after `where` but before `qualify`; reduce row count first when the filter is on raw columns.
- **Prefer `qualify` over wrapping in a subquery** when the engine supports it (Snowflake, BigQuery, Databricks, DuckDB, Trino) — keeps CTE pipelines flat.
- **Sessionize once, reuse downstream.** Don't recompute session boundaries in every query; materialize a sessions CTE or model.
- **Sanity-check with small windows.** Pull one user's events ordered by time and eyeball the pattern before scaling.

All examples in this skill follow [effective-sql](../effective-sql/SKILL.md): lowercase keywords, CTE pipelines (import → transform → output), explicit `as` aliases, type/unit suffixes on column names, `select * from <final_cte>` to close.

## Reference

- [window-functions](window-functions.md) — `lag`/`lead`, frame clauses, `row_number`/`rank`, sessionization, gaps and islands
- [match-recognize](match-recognize.md) — syntax, regex quantifiers, `measures`, `one`/`all rows per match`, porting to plain SQL
- [analytical-patterns](analytical-patterns.md) — funnels, clickstream paths, retention, time-series anomalies
