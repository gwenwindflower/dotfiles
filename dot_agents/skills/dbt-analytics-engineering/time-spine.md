# Time Spine Setup

Required for time-based joins and aggregations in MetricFlow: cumulative metrics, time-window metrics, and `join_to_timespine`.

## Daily Time Spine Model

`models/marts/time_spine_daily.sql`:

```sql
{{
    config(
        materialized = 'table',
    )
}}

with base_dates as (
    {{ dbt.date_spine('day', "DATE('2000-01-01')", "DATE('2030-01-01')") }}
),

final as (
    select cast(date_day as date) as date_day
    from base_dates
)

select *
from final
where date_day > dateadd(year, -5, current_date())
  and date_day < dateadd(day, 30, current_date())
```

> `dbt.date_spine()` is not available for all adapters. Use `generate_series` or your warehouse's equivalent if unsupported.

```yaml
models:
  - name: time_spine_daily
    description: One row per day, 5 years past to 30 days future.
    time_spine:
      standard_granularity_column: date_day
    columns:
      - name: date_day
        granularity: day
```

## Using an Existing dim_date

```yaml
models:
  - name: dim_date
    time_spine:
      standard_granularity_column: date_day
    columns:
      - name: date_day
        granularity: day
```

## Yearly Granularity

`models/marts/time_spine_yearly.sql`:

```sql
{{ config(materialized = 'table') }}

with years as (
    {{ dbt.date_spine('year', "to_date('01/01/2000','mm/dd/yyyy')", "to_date('01/01/2025','mm/dd/yyyy')") }}
),
final as (
    select cast(date_year as date) as date_year from years
)
select * from final
where date_year >= date_trunc('year', dateadd(year, -4, current_timestamp()))
  and date_year < date_trunc('year', dateadd(year, 1, current_timestamp()))
```

```yaml
models:
  - name: time_spine_yearly
    time_spine:
      standard_granularity_column: date_year
    columns:
      - name: date_year
        granularity: year
```

## Custom Granularities (Fiscal Calendar)

Build on the daily time spine:

```sql
select
    date_day,
    case when extract(month from date_day) >= 10
         then extract(year from date_day) + 1
         else extract(year from date_day)
    end as fiscal_year,
    extract(week from date_day) + 1 as fiscal_week
from {{ ref('time_spine_daily') }}
```

```yaml
models:
  - name: fiscal_calendar
    time_spine:
      standard_granularity_column: date_day
      custom_granularities:
        - name: fiscal_year
          column_name: fiscal_year
        - name: fiscal_week
          column_name: fiscal_week
    columns:
      - name: date_day
        granularity: day
```

Query: `mf query --metrics orders --group-by metric_time__fiscal_year`

## Build and Validate

```bash
dbt run --select time_spine_daily
dbt show --select time_spine_daily
mf validate-configs
```

## Common Mistakes

| Mistake | Fix |
| --- | --- |
| Using `semantic_models:` instead of `time_spine:` | Time spines use `time_spine:` under `models:` |
| Missing `standard_granularity_column` | Required to tell MetricFlow which column to use |
| Missing `granularity` on columns | Each time column needs a `granularity:` attribute |
