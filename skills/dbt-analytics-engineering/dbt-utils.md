# dbt-utils

`dbt-utils` is the standard community utility package for common dbt tests and macros. It is present in many mature dbt projects; if a project does not have it and you need one of these utilities, adding it is usually better than rebuilding the macro locally.

Before writing utility logic that feels broadly reusable across dbt projects, search dbt-utils first. This doc covers a useful sample, not the whole package.

## Install

Check whether the project already has `dbt-labs/dbt_utils` in `packages.yml` or `dependencies.yml`.

For a new install, use the current dbt Hub version:

```yaml
packages:
  - package: dbt-labs/dbt_utils
    version: <current dbt Hub version>
```

Then install packages:

```bash
dbt deps
```

Pin a real version before committing. dbt Hub packages handle duplicate dependencies better than Git URLs, so prefer Hub unless the project has an explicit reason to install from Git.

## Expanded Data Tests

Use these when core `unique`, `not_null`, `relationships`, and `accepted_values` are too limited.

### `expression_is_true`

Checks a row-level SQL expression:

```yaml
models:
  - name: orders
    data_tests:
      - dbt_utils.expression_is_true:
          arguments:
            expression: "gross_amount = subtotal_amount + tax_amount"
```

### `accepted_range`

Checks numeric, date, or comparable values against a range:

```yaml
models:
  - name: orders
    columns:
      - name: discount_percent
        data_tests:
          - dbt_utils.accepted_range:
              arguments:
                min_value: 0
                max_value: 1
                inclusive: true
```

### `equal_rowcount`

Checks that two relations have the same number of rows, optionally grouped:

```yaml
models:
  - name: transformed_events
    data_tests:
      - dbt_utils.equal_rowcount:
          arguments:
            compare_model: ref('stg_events')
```

## Introspective Macros

These hit the warehouse during compilation/execution. Keep queries small, deterministic, and scoped.

### `get_query_results_as_dict`

Useful for pulling a small lookup table into Jinja, such as a set of categories from another model:

```sql
{% set status_sql %}
    select distinct status
    from {{ ref('stg_orders') }}
    where status is not null
{% endset %}

{% if execute %}
    {% set statuses = dbt_utils.get_query_results_as_dict(status_sql)['STATUS'] %}
{% else %}
    {% set statuses = [] %}
{% endif %}

select
    customer_id
    {% for status in statuses %}
    , sum(case when status = '{{ status }}' then 1 else 0 end) as {{ status | lower }}_order_count
    {% endfor %}
from {{ ref('orders') }}
group by 1
```

Use for small lookup sets, not unbounded data profiling. Column keys may be adapter-cased; inspect compiled behavior when portability matters. Only turn values into column names after normalizing or allowlisting them.

### `get_relations_by_prefix`

Useful in well-maintained projects with consistent naming, such as gathering `stg_cli_events__*` relations:

```sql
{% set cli_event_relations = dbt_utils.get_relations_by_prefix(
    schema=target.schema,
    prefix='stg_cli_events__'
) %}

{{ dbt_utils.union_relations(relations=cli_event_relations) }}
```

If deprecation warnings appear, use `get_relations_by_pattern`; it is the more flexible version. The prefix form is still a good mental model for projects with disciplined names.

## SQL Generator Macros

### `date_spine`

Generates a date or timestamp spine:

```sql
{{ dbt_utils.date_spine(
    datepart='day',
    start_date="cast('2026-01-01' as date)",
    end_date="current_date"
) }}
```

Use it for dense calendars, missing-date fills, and cohort scaffolding. Do not nest curlies inside the macro call; pass Jinja expressions directly.

### `union_relations`

Unions relations by column name, filling missing columns with `null` and adding `_dbt_source_relation`:

```sql
{{ dbt_utils.union_relations(
    relations=[
        ref('stg_stripe__payments'),
        ref('stg_paypal__payments')
    ],
    exclude=['_loaded_at']
) }}
```

Pair with `get_relations_by_prefix` or `get_relations_by_pattern` when consistent model naming lets the project discover relation sets safely.
