# Jinja in dbt

Jinja renders before SQL reaches the warehouse. Write the template so the compiled SQL is readable and valid.

## Delimiters

| Syntax | Meaning | dbt examples |
| --- | --- | --- |
| `{{ ... }}` | Output an expression | `{{ ref('orders') }}`, `{{ var('lookback_days', 7) }}`, `{{ this }}` |
| `{% ... %}` | Run a statement | `{% if target.name != 'prod' %}`, `{% for col in cols %}`, `{% set cols = [...] %}` |
| `{# ... #}` | Jinja-only comment | `{# Explain template logic that should not compile into SQL. #}` |

Do not nest curlies:

```sql
{{ dbt_utils.date_spine(
    datepart='day',
    start_date=var('start_date')
) }}
```

Not:

```sql
{{ dbt_utils.date_spine(
    datepart='day',
    start_date="{{ var('start_date') }}"
) }}
```

Hooks are the key exception because dbt stores the hook string and renders it later:

```sql
{{ config(post_hook="grant select on {{ this }} to role bi_role") }}
```

## Control Flow

Conditionals:

```sql
select * from {{ ref('orders') }}

{% if target.name != 'prod' %}
{{ limit_in_dev() }}
{% endif %}
```

Loops:

```sql
{% set payment_methods = ['card', 'bank_transfer', 'gift_card'] %}

select
    order_id,
    {% for payment_method in payment_methods %}
    sum(case when payment_method = '{{ payment_method }}' then amount end) as {{ payment_method }}_amount{% if not loop.last %},{% endif %}
    {% endfor %}
from {{ ref('payments') }}
group by 1
```

Use `loop.last` or build a list and `join` it when commas get fragile.

## Variables and Context

Common dbt context:

| Function/variable | Use |
| --- | --- |
| `ref('model')` | Dependency-aware relation for a model, seed, or snapshot |
| `source('source', 'table')` | Dependency-aware relation for a source table |
| `var('name', default)` | Project or CLI variable |
| `env_var('NAME')` | Environment variable for config or secrets |
| `target.name` | Active profile output name |
| `this` | Current model relation |
| `is_incremental()` | True only for an existing incremental target without full-refresh |
| `config(...)` | Resource config inside a model, test, snapshot, or function |
| `doc('name')` | Reuse docs blocks in descriptions |

Use `var()` defaults unless missing input should fail:

```sql
{% set lookback_days = var('lookback_days', 7) %}
where event_at >= current_date - interval '{{ lookback_days }} days'
```

## Macros

Macros belong in `macros/*.sql` and return reusable SQL snippets:

```sql
{% macro select_columns(relation_alias, columns) %}
    {% for column in columns %}
        {{ relation_alias }}.{{ column }}{% if not loop.last %},{% endif %}
    {% endfor %}
{% endmacro %}
```

Call them without nested curlies:

```sql
select
    {{ select_columns('orders', ['order_id', 'customer_id', 'created_at']) }}
from {{ ref('orders') }} as orders
```

Use macros for compile-time SQL generation. Use [Macros and UDFs](macros-and-udfs.md) when logic might belong in a warehouse function or project-level macro.

## Cross-Database Macros

Use dbt's built-in cross-database macros when SQL must run on more than one adapter. Data types are the sharp edge: warehouse type names differ, and hand-written casts are easy to make non-portable.

Data type helpers:

```sql
select
    cast(order_id as {{ dbt.type_string() }}) as order_id,
    cast(amount as {{ dbt.type_numeric() }}) as amount,
    cast(created_at as {{ dbt.type_timestamp() }}) as created_at
from {{ ref('stg_orders') }}
```

Cast helpers:

```sql
select
    {{ dbt.cast('amount', dbt.type_numeric()) }} as amount,
    {{ dbt.safe_cast('raw_user_id', dbt.type_string()) }} as user_id
from {{ source('app', 'events') }}
```

Date helpers:

```sql
select
    order_id,
    {{ dbt.datediff('created_at', 'completed_at', 'day') }} as days_to_complete
from {{ ref('orders') }}
```

Rules:

- Prefer `dbt.type_*()` over hardcoded `varchar`, `string`, `numeric`, or `timestamp` in cross-db SQL.
- Use `dbt.safe_cast()` for dirty source fields when supported behavior is acceptable; use `dbt.cast()` when bad values should fail.
- Pass SQL expressions as strings. String literals need quotes inside the string, e.g. `"'2026-01-01'"`.
- Date parts are adapter-sensitive; verify unusual grains before relying on them.

## Warehouse Queries During Compilation

`run_query` and statement blocks hit the warehouse during execute mode. Guard them so `dbt parse` and compile-only flows still work:

```sql
{% set query %}
    select distinct payment_method from {{ ref('payments') }}
{% endset %}

{% if execute %}
    {% set payment_methods = run_query(query).columns[0].values() %}
{% else %}
    {% set payment_methods = [] %}
{% endif %}
```

Avoid side effects in parse/compile paths. Treat query results as untrusted input before injecting them into SQL.
