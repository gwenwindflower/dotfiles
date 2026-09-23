---
name: analytics-engineering
description: Analytics engineering - dbt projects, maintainable SQL as CTE pipelines, event patterns (funnels, sessions, retention, window functions, MATCH_RECOGNIZE).
---

# Analytics engineering

Apply software engineering discipline to analytics code. Any SQL meant to be committed, reviewed, or reused follows [effective-sql](sql/effective-sql.md) unless the project has established patterns that override it; skip that for one-off ad-hoc queries.

| Job | Doc |
| --- | --- |
| Write or review committed SQL | [sql/effective-sql](sql/effective-sql.md) |
| Sequence events - funnels, sessionization, paths, retention, gaps-and-islands | [sql/event-patterns](sql/event-patterns.md), linking window functions, `match_recognize`, and analytical patterns |
| Build, test, configure, or debug a dbt project | [dbt/overview](dbt/overview.md), linking tests, incremental models, Jinja, macros, semantic layer, CLI, debugging |

Lightdash metadata on dbt models belongs to `developing-in-lightdash`.
