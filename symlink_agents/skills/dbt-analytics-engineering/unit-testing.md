# Unit Testing Reference

YAML spec, data formats, special cases, and warehouse caveats for dbt unit tests.

## YAML Spec

```yaml
unit_tests:
  - name: <test-name>            # Required, unique
    description: <string>        # Optional
    model: <model-name>          # Required
    versions:                    # Optional (for versioned models)
      include: [2]               # or exclude: [1]
    given:                       # Required
      - input: ref('model')      # or source('schema', 'table')
        format: dict | csv | sql # Default: dict
        rows: [{...}]            # Inline data, or:
        fixture: <fixture-name>  # For csv/sql formats
    expect:                      # Required
      format: dict | csv | sql
      rows: [{...}]
      fixture: <fixture-name>
    overrides:                   # Optional
      macros:
        is_incremental: true | false
        dbt_utils.star: col_a,col_b
      vars: {key: value}
      env_vars: {KEY: value}
    config:                      # Optional
      tags: [tag]
      enabled: false             # v1.9+, disable without deleting
```

### Placement and file conventions

- Unit tests go in YAML files in `model-paths` (`models/` by default)
- Fixture files go in `test-paths` (`tests/fixtures/` by default)
- Include all `ref`/`source` dependencies as `input`s -- even irrelevant ones with `rows: []`
- Seeds without an explicit `input` use their CSV file as-is
- Use table aliases when testing `join` logic

## Data Formats

### Choosing a format

| Format | Subset Columns? | Fixture Files? | Ephemeral Models? | Jinja? |
| --- | --- | --- | --- | --- |
| `dict` (default) | Yes | No (inline only) | No | No |
| `csv` | Yes | Yes | No | No |
| `sql` | No (all columns) | Yes | Yes | No |

Default to `dict`. Use `csv` for fixture files. Use `sql` for ephemeral dependencies or unsupported data types.

### Dict (default)

```yaml
given:
  - input: ref('my_model')
    rows:
      - {id: 1, name: gerda}
      - {id: 2, name: michelle}
```

### CSV

```yaml
given:
  - input: ref('my_model')
    format: csv
    rows: |                    # Inline
      id,name
      1,gerda
      2,michelle
  - input: ref('other_model')
    format: csv
    fixture: my_fixture        # tests/fixtures/my_fixture.csv
```

### SQL

```yaml
given:
  - input: ref('my_model')
    format: sql
    rows: |                    # Inline
      select 1 as id, 'gerda' as name union all
      select 2 as id, 'michelle' as name
  - input: ref('other_model')
    format: sql
    fixture: my_fixture        # tests/fixtures/my_fixture.sql
```

`sql` format requires all columns. Jinja is not supported in fixtures.

## Special Cases

### Incremental models

Override `is_incremental` macro. Test both modes (full-refresh with `false`, incremental with `true`):

```yaml
unit_tests:
  - name: test_incremental
    model: my_incremental_model
    overrides:
      macros:
        is_incremental: true
    given:
      - input: ref('events')
        rows:
          - {event_id: 1, event_time: 2020-01-01}
          - {event_id: 2, event_time: 2020-01-02}
      - input: this              # Existing table state
        rows:
          - {event_id: 1, event_time: 2020-01-01}
    expect:
      # Expected = what gets merged/inserted, NOT final table state
      rows:
        - {event_id: 2, event_time: 2020-01-02}
```

Incremental models must exist in the database before unit tests run:

```bash
dbt run --select "config.materialized:incremental" --empty
```

### Ephemeral dependencies

Must use `format: sql` for ephemeral model inputs:

```yaml
given:
  - input: ref('ephemeral_model')
    format: sql
    rows: |
      select 1 as id, 'emily' as name
```

### `dbt_utils.star` override

If the model uses `star()`, override with an explicit column list:

```yaml
overrides:
  macros:
    dbt_utils.star: col_a,col_b,col_c
```

### Versioned models

By default, unit tests run on all versions. Use `versions:` to target specific ones:

```yaml
unit_tests:
  - name: test_email_validation
    model: my_model
    versions:
      include: [2]      # Only version 2
      # or exclude: [1] # All except version 1
```

## Running Unit Tests

```bash
dbt build --select my_model                      # Unit tests + build + data tests
dbt test --select "my_model,test_type:unit"      # Only unit tests for a model
dbt test --select test_my_specific_test          # Single unit test by name
```

Exclude from production: `--exclude-resource-type unit_test` or `DBT_EXCLUDE_RESOURCE_TYPES=unit_test`.

## Interpreting Failures

Output shows a diff between actual and expected:

```text
actual differs from expected:

@@ ,email           ,is_valid_email_address
->  ,cool@example.com,True->False
   ,cool@unknown.com,False
```

Two possibilities: (1) the test expectation is wrong, or (2) the model has a bug. Requires judgment based on the intended logic.

## Warehouse-Specific Caveats

### BigQuery

- Must specify **all** fields in a `STRUCT` -- subsets not supported
- Complex types: `geography_field: 'st_geogpoint(75, 45)'`, `struct_field: 'struct("Isha" as name, 22 as age)'`
- JSON: `json_field: {"name": "Cooper", "forname": "Alice"}`
- Arrays: `str_array_field: ['a','b','c']`

### Redshift

- No unit tests with CTE functions like `LISTAGG`, `MEDIAN`, `PERCENTILE_CONT` (unsupported in CTEs)
- Sources must be in the same database as models
- `array` not supported in `dict` format -- use `sql`

### Postgres

- `array` not supported in `dict` format -- use `sql`
- JSON: `json_field: '{"bar": "baz", "balance": 7.77, "active": false}'`

### Snowflake

- Variant: `variant_field: 3`
- Geo: `geography_field: POINT(-122.35 37.55)`, `geometry_field: POINT(1820.12 890.56)`
- Object: `object_field: {'Alberta':'Edmonton','Manitoba':'Winnipeg'}`
- Arrays: `str_array_field: ['a','b','c']`, `int_array_field: [1, 2, 3]`
- Binary: `binary_field: 19E1FFDCCB6CDEE788BF631C1C4905D1`

### Spark

- Arrays: `int_array_field: 'array(1, 2, 3)'`
- Maps: `map_field: 'map("10", "t", "15", "f", "20", NULL)'`
- Structs: `named_struct_field: 'named_struct("a", 1, "b", 2, "c", 3)'`
