# Unit Testing

Unit tests validate SQL logic with given rows and expected rows. Use them for regex, date math, windows, multi-branch `case`, incremental logic, and complex joins. Data tests validate production data.

## Shape

```yaml
unit_tests:
  - name: <test_name>
    description: <string>
    model: <model_name>
    versions:
      include: [2]
    given:
      - input: ref('upstream_model')
        format: dict
        rows:
          - {id: 1, status: active}
    expect:
      format: dict
      rows:
        - {id: 1, is_active: true}
    overrides:
      macros:
        is_incremental: false
      vars: {key: value}
      env_vars: {KEY: value}
    config:
      tags: [unit]
```

Rules:

- Place unit tests in YAML under `model-paths` (`models/` by default).
- Put fixtures under `test-paths/fixtures/` (`tests/fixtures/` by default).
- Include every `ref`/`source` dependency as an `input`; use `rows: []` for irrelevant dependencies.
- Use table aliases when testing join logic.
- Seeds without explicit inputs use their CSV files.

## Formats

| Format | Use when | Notes |
| --- | --- | --- |
| `dict` | Default inline rows | Subset columns allowed; no fixture files |
| `csv` | Larger readable fixtures | Inline or fixture file |
| `sql` | Ephemeral deps or unsupported types | Requires all columns; no Jinja |

```yaml
given:
  - input: ref('customers')
    rows:
      - {customer_id: 1, customer_name: gerda}
  - input: ref('orders')
    format: csv
    rows: |
      order_id,customer_id
      10,1
  - input: ref('ephemeral_model')
    format: sql
    rows: |
      select 1 as id, 'emily' as name
```

## Special Cases

### Incremental Models

Override `is_incremental` and test both full-refresh and incremental paths. For incremental mode, `input: this` is the existing table state; expected rows are what dbt merges or inserts, not the final table. Load [Incremental Models](incremental-models.md) when test expectations depend on incremental state or materialization behavior.

```yaml
unit_tests:
  - name: incremental_filters_existing_events
    model: events_incremental
    overrides:
      macros:
        is_incremental: true
    given:
      - input: ref('events')
        rows:
          - {event_id: 1, event_time: 2020-01-01}
          - {event_id: 2, event_time: 2020-01-02}
      - input: this
        rows:
          - {event_id: 1, event_time: 2020-01-01}
    expect:
      rows:
        - {event_id: 2, event_time: 2020-01-02}
```

The incremental model must exist before unit tests run:

```bash
dbt run --select "config.materialized:incremental" --empty
```

### Macro Overrides

```yaml
overrides:
  macros:
    dbt_utils.star: col_a,col_b,col_c
```

### Versioned Models

By default, tests run on all versions:

```yaml
versions:
  include: [2]
  # exclude: [1]
```

## Running

```bash
dbt build --select my_model
dbt test --select "my_model,test_type:unit"
dbt test --select test_my_specific_test
```

Exclude from production with `--exclude-resource-type unit_test` or `DBT_EXCLUDE_RESOURCE_TYPES=unit_test`.

## Failures

Row diffs mean either the expected rows are wrong or the model logic is wrong:

```text
actual differs from expected:
->,cool@example.com,True->False
  ,cool@unknown.com,False
```

## Warehouse Caveats

| Warehouse | Caveat |
| --- | --- |
| BigQuery | `STRUCT` fields require complete values; use expressions for geography/structs |
| Snowflake | Variant/object/geo/array/binary values need warehouse literals |
| Postgres / Redshift | Arrays are unsupported in `dict`; use `sql` |
| Redshift | Sources must share the model database; some aggregate functions fail in CTEs |
| Spark | Arrays, maps, and structs need Spark SQL literal strings |
