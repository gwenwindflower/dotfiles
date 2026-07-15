# Macros and UDFs

Use macros for templating, dbt-specific behavior, and generated SQL structure. Use UDFs for reusable transformations, calculations, computations, and case logic that should run in the warehouse.

## Macro vs. UDF

| Need | Use |
| --- | --- |
| Insert a warehouse-specific SQL fragment | Macro |
| Change dbt behavior such as schema naming | Macro |
| Generate SQL from project metadata, vars, or relation lists | Macro |
| Encapsulate repeatable business calculations | UDF |
| Share callable logic with BI tools, notebooks, or raw SQL | UDF |
| Run procedural logic at query time | UDF |

Macros render before SQL reaches the warehouse. UDF arguments are evaluated when the warehouse query runs.

## Macros

Macros live in `macros/*.sql`:

```sql
{% macro get_payment_methods() %}
    {% set payment_methods_query %}
        select distinct payment_method
        from {{ ref('raw_payments') }}
        order by 1
    {% endset %}

    {% if execute %}
        {% set results = run_query(payment_methods_query) %}
        {% set payment_methods = results.columns[0].values() %}
    {% else %}
        {% set payment_methods = [] %}
    {% endif %}

    {{ return(payment_methods) }}
{% endmacro %}
```

Use the macro output to generate repeated SQL:

```sql
{% set payment_methods = get_payment_methods() %}

select
    order_id
    {% for payment_method in payment_methods %}
    , sum(case when payment_method = '{{ payment_method }}' then amount end) as {{ payment_method }}_amount
    {% endfor %}
    , sum(amount) as total_amount
from {{ ref('raw_payments') }}
group by 1
```

Use macros when SQL structure changes from dbt context, project metadata, relation metadata, or arguments.

### `limit_in_dev`

`limit` usually caps returned rows, not scanned rows. For development cost control, prefer a warehouse-supported random or deterministic sample. Keep the syntax behind a project macro because sampling support varies by adapter.

```sql
{% macro limit_in_dev() %}
    {% if target.name != 'prod' %}
        {{ return(adapter.dispatch('limit_in_dev')()) }}
    {% endif %}
{% endmacro %}

{% macro default__limit_in_dev() %}
    -- Add adapter-specific sampling for this project.
{% endmacro %}
```

Override per adapter or project convention:

```sql
{% macro snowflake__limit_in_dev() %}
    sample row (100 rows)
{% endmacro %}
```

Use it at the relation read point:

```sql
with events as (
    select * from {{ source('app', 'events') }}
    {{ limit_in_dev() }}
)

select * from events
```

Rules:

- Prefer sampling over `limit` when the warehouse supports it.
- Keep dev filters early in the model, where they can reduce downstream work.
- Document whether the sample is random, deterministic, row-count based, or percentage based.
- Check compiled SQL on the target adapter before relying on sampling for cost control.

### `generate_schema_name`

`generate_schema_name(custom_schema_name, node)` controls where dbt builds relations. Override it only when the project needs a clear environment/schema policy.

Common pattern: production honors custom schemas under the default schema prefix; non-production writes every model into the target schema so dev and CI are easy to clean up.

```sql
{% macro generate_schema_name(custom_schema_name, node) -%}
    {%- set default_schema = target.schema -%}

    {%- if target.name == 'prod' -%}
        {%- if custom_schema_name is none -%}
            {{ default_schema }}
        {%- else -%}
            {{ default_schema }}_{{ custom_schema_name | trim }}
        {%- endif -%}
    {%- else -%}
        {{ default_schema }}
    {%- endif -%}
{%- endmacro %}
```

Rules:

- Never return `none` or an empty schema name.
- Preserve `target.schema` unless the project intentionally disables per-user/dev isolation.
- Confirm `target.name` values across dev, CI, and prod before changing schema generation.
- Treat overrides of built-in macros as project architecture, not local helper code.

## UDFs

Function bodies live under `functions/`:

```sql
-- functions/is_positive_int.sql
regexp_instr(a_string, '^[0-9]+$')
```

Properties live beside them:

```yaml
functions:
  - name: is_positive_int
    description: Returns 1 when a string is a positive integer.
    arguments:
      - name: a_string
        data_type: string
        description: String to check.
    returns:
      data_type: integer
```

Build all functions or one function:

```bash
dbt build --select "resource_type:function"
dbt build --select is_positive_int
```

Models that call a UDF should depend on it through dbt's function context when available:

```sql
select {{ function('is_positive_int') }}(customer_code) as is_positive_customer_code
from {{ ref('stg_customers') }}
```

## SQL, Python, and JavaScript

| Type | Use when | Notes |
| --- | --- | --- |
| SQL | Logic is expressible in warehouse SQL | Most portable option, but syntax still varies by adapter |
| Python | Logic needs Python libraries or procedural code | Requires `runtime_version` and `entry_point`; Snowflake and BigQuery support |
| JavaScript | Existing warehouse JS UDF pattern exists | Beta in Core 1.12; Snowflake and BigQuery support |

Python UDF YAML:

```yaml
functions:
  - name: normalize_email
    config:
      runtime_version: "3.11"
      entry_point: main
      packages:
        - idna
      volatility: deterministic
    arguments:
      - name: raw_email
        data_type: string
    returns:
      data_type: string
```

Warehouse package installation happens when the UDF is created, so pin versions when reproducibility matters and check warehouse policy before adding dependencies.

UDF definitions can contain Jinja, but that Jinja resolves when dbt creates the function. Function arguments are evaluated later, when the warehouse query runs.

## Safety

- Check adapter and language support before adding a UDF.
- Keep UDF names stable; renames create warehouse object churn.
- Add unit tests for models that depend on UDF behavior, especially boundary cases.
- Before unit-testing a model that calls a UDF, create the function with `dbt build --select "+model_name" --empty`.
- Use data tests on downstream model outputs when warehouse UDF behavior could drift by adapter or package version.
- Treat UDFs as deployable warehouse resources, not just helper code.
