# MATCH_RECOGNIZE

Row-pattern recognition: regex-style pattern matching directly over ordered rows. Vastly more readable than the equivalent self-join + window stack, when the dialect supports it.

**Supported:** Snowflake, Oracle, Trino/Presto, Apache Flink SQL, Databricks (recent), Vertica, Exasol, SingleStore.
**Not supported:** BigQuery, Postgres, Redshift, DuckDB, MySQL, ClickHouse, SQL Server. Port to [window functions](window-functions.md).

`match_recognize` is one of the few places in this skill where uppercase is used inside the clause — it's the canonical convention in the SQL:2016 row-pattern spec and every vendor's docs. Keep the surrounding query in lowercase per [effective-sql](../effective-sql/SKILL.md); leave clause keywords (`PATTERN`, `DEFINE`, `MEASURES`, etc.) and pattern symbols (`A`, `B`, `C`) uppercase so the pattern reads as a regex.

Reference: <https://docs.snowflake.com/en/user-guide/match-recognize-introduction>

## Anatomy

```sql
with

events_in_scope as (

    select
        user_id,
        event_name,
        event_at

    from events

),

funnel_matches as (

    select
        user_id,
        match_id,
        started_at,
        converted_at,
        browse_event_count

    from events_in_scope
        match_recognize (
            partition by user_id
            order by event_at
            measures
                MATCH_NUMBER()        as match_id,
                A.event_at            as started_at,
                LAST(C.event_at)      as converted_at,
                COUNT(B.*)            as browse_event_count
            one row per match
            after match skip past last row
            pattern (A B+ C)
            define
                A as event_name = 'signup',
                B as event_name = 'browse',
                C as event_name = 'purchase'
                   and C.event_at <= A.event_at + interval '7 days'
        )

),

final as (

    select
        ---------- ids
        user_id,
        match_id,

        ---------- numerics
        browse_event_count,

        ---------- timestamps
        started_at,
        converted_at

    from funnel_matches

)

select * from final
```

Read top-down: partition the stream, order it, define what symbols mean, write a regex over them, declare what to extract.

## The clauses

### `PATTERN`

Regex over the symbol names defined in `DEFINE`. Quantifiers:

| Token | Meaning |
| --- | --- |
| `A` | Exactly one row matching A |
| `A?` | Zero or one |
| `A*` | Zero or more (greedy) |
| `A+` | One or more |
| `A{3}` | Exactly 3 |
| `A{2,5}` | 2 to 5 |
| `A*?`, `A+?` | Reluctant (non-greedy) variants |
| `A \| B` | Alternation |
| `(A B)` | Grouping |
| `^`, `$` | Partition start/end anchors |
| `{- A -}` | Exclude from output (still required to match) |

A symbol with no `DEFINE` entry matches any row (useful for "any event in between").

### `DEFINE`

Boolean predicates per symbol. Can reference:

- Current row's columns: `event_name = 'view'`
- Other symbols' rows via `LAST()`, `FIRST()`, `PREV()`, `NEXT()`: `event_at <= FIRST(A.event_at) + interval '1 hour'`
- Aggregates over already-matched rows: `COUNT(B.*) < 5`

This is where window-function logic becomes one-liners.

### `MEASURES`

Expressions computed per match. Use:

- `MATCH_NUMBER()` — sequential id of match within partition
- `CLASSIFIER()` — symbol name of current row (only useful with `ALL ROWS PER MATCH`)
- `FIRST(A.col)`, `LAST(C.col)` — values from specific symbols
- `COUNT(B.*)`, `AVG(B.amount_cents)` — aggregates over matched rows of a symbol

### `ONE ROW PER MATCH` vs `ALL ROWS PER MATCH`

- `one row per match` (default) — one summary row per match. Use for funnels, conversion times, pattern counts.
- `all rows per match` — every input row that participated, annotated with `CLASSIFIER()` and measures. Use for labeling event streams (e.g. "tag every event with which session/funnel-stage it belongs to").

### `AFTER MATCH SKIP`

Where the matcher resumes:

- `skip past last row` (default) — non-overlapping matches
- `skip to next row` — allow overlapping matches starting on the next row
- `skip to first <symbol>` / `skip to last <symbol>` — resume at a named symbol; useful when the tail of one match should anchor the next

## Idiomatic examples

### Detect rage-clicks (3+ clicks within 2 seconds)

```sql
with

clicks_in_scope as (

    select
        session_id,
        event_name,
        event_at

    from events

),

rage_click_matches as (

    select
        session_id,
        rage_started_at,
        click_count

    from clicks_in_scope
        match_recognize (
            partition by session_id
            order by event_at
            measures
                FIRST(C.event_at) as rage_started_at,
                COUNT(*)          as click_count
            pattern (C{3,})
            define
                C as event_name = 'click'
                  and event_at <= FIRST(C.event_at) + interval '2 seconds'
        )

),

final as (

    select
        ---------- ids
        session_id,

        ---------- numerics
        click_count,

        ---------- timestamps
        rage_started_at

    from rage_click_matches

)

select * from final
```

### V-shaped price dip (down then up)

```sql
with

ticks_in_scope as (

    select
        symbol,
        price_cents,
        tick_at

    from price_ticks

),

dip_matches as (

    select
        symbol,
        dip_started_at,
        recovered_at,
        bottom_price_cents

    from ticks_in_scope
        match_recognize (
            partition by symbol
            order by tick_at
            measures
                FIRST(D.tick_at)     as dip_started_at,
                LAST(U.tick_at)      as recovered_at,
                MIN(D.price_cents)   as bottom_price_cents
            pattern (D+ U+)
            define
                D as price_cents < PREV(price_cents),
                U as price_cents > PREV(price_cents)
        )

),

final as (

    select
        ---------- ids
        symbol,

        ---------- numerics
        bottom_price_cents,

        ---------- timestamps
        dip_started_at,
        recovered_at

    from dip_matches

)

select * from final
```

### Sessionize by gap (the gaps-and-islands canonical case)

```sql
with

events_in_scope as (

    select
        user_id,
        event_at

    from events

),

session_labels as (

    select
        user_id,
        session_id,
        event_role,
        event_at

    from events_in_scope
        match_recognize (
            partition by user_id
            order by event_at
            measures
                MATCH_NUMBER() as session_id,
                CLASSIFIER()   as event_role
            all rows per match
            pattern (S X*)
            define
                X as event_at <= PREV(event_at) + interval '30 minutes'
            -- S has no define → matches any row, anchors session start
        )

),

final as (

    select
        ---------- ids
        user_id,
        session_id,

        ---------- text
        event_role,

        ---------- timestamps
        event_at

    from session_labels

)

select * from final
```

Compare to the gaps-and-islands version in [window-functions](window-functions.md#sessionize-by-inactivity-gap) — same result, dramatically less code.

## Porting to plain SQL

When the warehouse doesn't support `match_recognize`:

1. **Pattern of fixed length (A then B then C):** self-joins or `lag`/`lead` with a chain of comparisons.
2. **Pattern with `+` or `*` quantifiers:** sessionize first (gaps-and-islands), then filter sessions whose event sequence matches.
3. **`all rows per match` with classifier:** label each row with its symbol via `case` over windowed lookups, then group by `match_number` equivalent (a session id).

The mechanical recipe for `A B+ C`:

```sql
with

events_in_scope as (

    select
        user_id,
        event_id,
        event_name,
        event_at

    from events
    where event_name in ('signup', 'browse', 'purchase')

),

label_symbols as (

    select
        user_id,
        event_id,
        event_at,

        case event_name
            when 'signup'   then 'A'
            when 'browse'   then 'B'
            when 'purchase' then 'C'
        end as symbol

    from events_in_scope

),

assign_match_ids as (

    select
        user_id,
        event_id,
        event_at,
        symbol,

        sum(case when symbol = 'A' then 1 else 0 end) over (
            partition by user_id
            order by event_at, event_id
        ) as match_id

    from label_symbols

),

candidate_matches as (

    select
        user_id,
        match_id,

        min(event_at) filter (where symbol = 'A') as started_at,
        min(event_at) filter (where symbol = 'C') as converted_at,
        count(*)      filter (where symbol = 'B') as browse_event_count,
        bool_or(symbol = 'C')                     as has_conversion

    from assign_match_ids
    where match_id > 0
    group by all

),

final as (

    select
        ---------- ids
        user_id,
        match_id,

        ---------- numerics
        browse_event_count,

        ---------- timestamps
        started_at,
        converted_at

    from candidate_matches
    where has_conversion
      and browse_event_count >= 1

)

select * from final
```

The pattern grows fast. If you have `match_recognize`, use it.
