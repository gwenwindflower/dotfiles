# Window Functions for Event Sequencing

The portable foundation. Every dialect supports these (syntax varies on `qualify` and frame edge cases).

SQL style throughout this skill follows [effective-sql](../effective-sql/SKILL.md): lowercase keywords, CTE pipelines (import → transform → output), explicit `as` aliases, descriptive column names with type/unit suffixes.

## Anatomy

```sql
function() over (
    partition by user_id            -- per-entity scope (almost always required)
    order by event_at, event_id     -- deterministic order, break ties
    rows between ... and ...        -- frame: which rows are visible to the function
)
```

## The core navigation set

| Function | Use |
| --- | --- |
| `lag(col, n, default)` | Value from `n` rows before |
| `lead(col, n, default)` | Value from `n` rows after |
| `first_value(col)` | First row in frame |
| `last_value(col)` | Last row in frame (watch frame default — see below) |
| `nth_value(col, n)` | Nth row in frame |
| `row_number()` | 1-indexed position; unique per partition |
| `rank()` / `dense_rank()` | Position with tie handling |
| `ntile(n)` | Bucket into n quantiles |

## The frame trap

Default frame for ordered windows is `range between unbounded preceding and current row`, *not* the whole partition. So `last_value(col) over (order by event_at)` returns the current row, not the last row in the partition. Fix:

```sql
last_value(col) over (
    partition by user_id
    order by event_at
    rows between unbounded preceding and unbounded following
)
```

For aggregates with `order by` (running totals), the default is correct — leave it. Override only when needed.

`rows` counts physical rows; `range` operates on values (e.g. `range between interval '1 hour' preceding and current row` for time-window aggregates — Postgres, Snowflake, Trino support this; BigQuery does not, use `rows` with pre-aggregation).

## Time between events

```sql
with

events_in_scope as (

    select
        user_id,
        event_id,
        event_name,
        event_at

    from events

),

with_neighbors as (

    select
        user_id,
        event_id,
        event_name,
        event_at,

        event_at - lag(event_at) over (
            partition by user_id
            order by event_at, event_id
        ) as time_since_prev_event,

        lead(event_name) over (
            partition by user_id
            order by event_at, event_id
        ) as next_event_name

    from events_in_scope

),

final as (

    select
        ---------- ids
        user_id,
        event_id,

        ---------- text
        event_name,
        next_event_name,

        ---------- timestamps
        event_at,

        ---------- intervals
        time_since_prev_event

    from with_neighbors

)

select * from final
```

## Gaps and islands

The single most useful pattern in event SQL. Used for sessionization, status-streak detection, consecutive-day calculations, run-length encoding.

**Core trick:** subtract `row_number()` from a sequence-defining column. Rows that should belong to the same group land on the same difference.

### Sessionize by inactivity gap

```sql
with

events_in_scope as (

    select
        user_id,
        event_id,
        event_at

    from events

),

flag_session_starts as (

    select
        user_id,
        event_id,
        event_at,

        case
            when event_at - lag(event_at) over (
                    partition by user_id
                    order by event_at, event_id
                 ) > interval '30 minutes'
            then 1
            else 0
        end as is_new_session

    from events_in_scope

),

assign_session_ids as (

    select
        user_id,
        event_id,
        event_at,
        is_new_session,

        sum(is_new_session) over (
            partition by user_id
            order by event_at, event_id
        ) as session_id

    from flag_session_starts

),

summarize_sessions as (

    select
        user_id,
        session_id,
        min(event_at) as session_started_at,
        max(event_at) as session_ended_at,
        count(*) as event_count

    from assign_session_ids
    group by all

),

final as (

    select
        ---------- ids
        user_id,
        session_id,

        ---------- numerics
        event_count,

        ---------- timestamps
        session_started_at,
        session_ended_at

    from summarize_sessions

)

select * from final
```

The first row's `lag` is null → comparison is null → `is_new_session = 0`. Running `sum` then assigns each user's first session id 0, second 1, etc. Combine with `user_id` if you need a globally unique session id: `concat(user_id, '-', session_id)`.

### Consecutive runs (status streaks, login streaks)

```sql
with

daily_status_in_scope as (

    select
        user_id,
        status,
        status_date

    from daily_status

),

assign_island_groups as (

    select
        user_id,
        status,
        status_date,

        status_date - row_number() over (
            partition by user_id, status
            order by status_date
        ) * interval '1 day' as island_group

    from daily_status_in_scope

),

collapse_to_runs as (

    select
        user_id,
        status,
        island_group,
        min(status_date) as streak_start_date,
        max(status_date) as streak_end_date,
        count(*) as streak_length_days

    from assign_island_groups
    group by all

),

final as (

    select
        ---------- ids
        user_id,

        ---------- text
        status,

        ---------- numerics
        streak_length_days,

        ---------- dates
        streak_start_date,
        streak_end_date

    from collapse_to_runs

)

select * from final
```

The `island_group` value is constant across consecutive days within the same status — that's the island id.

For integer sequences (e.g. consecutive page numbers), the trick is even simpler: `value - row_number() over (...)` is constant within a run.

### First/last event per partition

```sql
-- "What was each user's first event?"
with

events_in_scope as (

    select
        user_id,
        event_id,
        event_name,
        event_at

    from events

),

final as (

    select
        user_id,
        event_id,
        event_name,
        event_at

    from events_in_scope
    qualify row_number() over (
        partition by user_id
        order by event_at, event_id
    ) = 1

)

select * from final
```

Without `qualify` (Postgres, Redshift), wrap the ranked CTE and filter:

```sql
with

events_in_scope as (

    select
        user_id,
        event_id,
        event_name,
        event_at

    from events

),

ranked_events as (

    select
        user_id,
        event_id,
        event_name,
        event_at,

        row_number() over (
            partition by user_id
            order by event_at, event_id
        ) as event_rank

    from events_in_scope

),

final as (

    select
        user_id,
        event_id,
        event_name,
        event_at

    from ranked_events
    where event_rank = 1

)

select * from final
```

`distinct on (user_id) ... order by user_id, event_at` is the Postgres-idiomatic shortcut.

## Rolling aggregates over time

```sql
-- 7-day rolling event count per user
with

events_in_scope as (

    select
        user_id,
        event_id,
        event_at

    from events

),

rolling as (

    select
        user_id,
        event_id,
        event_at,

        count(*) over (
            partition by user_id
            order by event_at
            range between interval '7 days' preceding and current row
        ) as events_last_7d

    from events_in_scope

),

final as (

    select
        ---------- ids
        user_id,
        event_id,

        ---------- numerics
        events_last_7d,

        ---------- timestamps
        event_at

    from rolling

)

select * from final
```

For BigQuery, pre-aggregate to a daily grain then use `rows between 6 preceding and current row`.

## Cumulative distinct count (the hard one)

`count(distinct col) over (...)` is not allowed in most dialects. Workaround: flag first occurrence with `row_number() = 1` per `(partition, col)`, then `sum` that flag over the time window.

```sql
with

events_in_scope as (

    select
        user_id,
        page_name,
        event_at

    from events

),

flag_first_visits as (

    select
        user_id,
        page_name,
        event_at,

        case
            when row_number() over (
                    partition by user_id, page_name
                    order by event_at
                 ) = 1
            then 1
            else 0
        end as is_first_page_visit

    from events_in_scope

),

cumulative as (

    select
        user_id,
        page_name,
        event_at,

        sum(is_first_page_visit) over (
            partition by user_id
            order by event_at
        ) as distinct_pages_so_far

    from flag_first_visits

),

final as (

    select
        ---------- ids
        user_id,

        ---------- text
        page_name,

        ---------- numerics
        distinct_pages_so_far,

        ---------- timestamps
        event_at

    from cumulative

)

select * from final
```
