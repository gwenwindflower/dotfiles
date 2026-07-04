# Incremental Models

Use incremental materialization only when a `table` model is too slow or expensive to rebuild. Incremental models are stateful, so prove both the full-refresh path and the incremental path.

## Core Pattern

```sql
{{
    config(
        materialized='incremental',
        unique_key='event_id'
    )
}}

with events as (
    select * from {{ source('app', 'events') }}

    {% if is_incremental() %}
        where event_at >= (select coalesce(max(event_at), '1900-01-01') from {{ this }})
    {% endif %}
)

select * from events
```

Rules:

- SQL must be valid when `is_incremental()` is true and false.
- Use a reliable `unique_key` unless append-only duplicates are impossible and acceptable.
- Filter early in the CTE pipeline when it reduces scanned data.
- Put late-arriving-data lookback windows in the source filter, then rely on `unique_key` to merge overlap safely.
- `{{ this }}` is the current model relation; guard every read from it with `is_incremental()`.
- Plan the `--full-refresh` behavior before shipping. A full rebuild should reproduce the intended table from source data.

## Config Placement

Use model-level config for one-off behavior:

```sql
{{
    config(
        materialized='incremental',
        unique_key=['account_id', 'event_id'],
        incremental_strategy='merge'
    )
}}
```

Use `dbt_project.yml` for a directory convention:

```yaml
models:
  my_project:
    marts:
      events:
        +materialized: incremental
        +incremental_strategy: merge
```

Model-local config overrides broader directory config. Load [Project Config](project-config.md) when materialization choices depend on inherited project configuration.

## Strategy Choices

| Strategy | Use when |
| --- | --- |
| `append` | Source rows are immutable, non-overlapping, and duplicate-safe |
| `merge` | Existing rows may receive updates by `unique_key` |
| `delete+insert` | Adapter/project convention prefers replacing matched keys |
| `insert_overwrite` | Partition replacement is cheaper and the adapter supports it |
| `microbatch` | Very large time-series data needs event-time batches |

Check adapter support before changing `incremental_strategy`. `merge_update_columns` and `merge_exclude_columns` tune which columns are overwritten on matched rows.

## Idempotence

Incremental models can break dbt's usual rerun safety because they depend on the existing target table.

Avoid:

- Append-only filters without `unique_key`.
- Boundary filters that re-select rows but have no dedupe or merge key.
- `current_timestamp()`, random values, or run-time dates in persisted columns.
- Surrogate keys that are not deterministic.
- Incremental predicates that exclude target rows still eligible for updates.

Prefer:

- Source-system timestamps over run timestamps.
- Deterministic keys such as source IDs or stable hashes.
- A small overlap window plus `unique_key` for late-arriving updates.
- Data tests that prove the `unique_key` is unique and not null after every build.

## Testing

Data tests for incremental models:

```yaml
models:
  - name: events_incremental
    columns:
      - name: event_id
        data_tests:
          - unique
          - not_null
```

Unit-test both paths. In incremental mode, `input: this` is the existing target relation. Expected rows are what the materialization will insert or merge, not the final table after the merge.

```yaml
unit_tests:
  - name: events_incremental_full_refresh
    model: events_incremental
    overrides:
      macros:
        is_incremental: false
    given:
      - input: ref('stg_events')
        rows:
          - {event_id: 1, event_at: 2026-01-01}
    expect:
      rows:
        - {event_id: 1, event_at: 2026-01-01}

  - name: events_incremental_filters_existing_events
    model: events_incremental
    overrides:
      macros:
        is_incremental: true
    given:
      - input: ref('stg_events')
        rows:
          - {event_id: 1, event_at: 2026-01-01}
          - {event_id: 2, event_at: 2026-01-02}
      - input: this
        rows:
          - {event_id: 1, event_at: 2026-01-01}
    expect:
      rows:
        - {event_id: 2, event_at: 2026-01-02}
```

Create empty incremental targets before unit tests when needed:

```bash
dbt run --select "config.materialized:incremental" --empty
```

## Verification

```bash
dbt parse
dbt compile --select events_incremental
dbt build --select events_incremental --warn-error-options '{"error": ["NoNodesForSelectionCriteria"]}'
dbt build --select events_incremental --full-refresh --warn-error-options '{"error": ["NoNodesForSelectionCriteria"]}'
```

Run full-refresh only with approval when it touches shared or production data.
