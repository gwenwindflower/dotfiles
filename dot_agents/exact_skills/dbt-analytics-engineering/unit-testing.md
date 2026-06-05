# Unit Testing

YAML spec, data formats, special cases, warehouse caveats. Unit tests validate complex SQL logic with given/expected rows — distinct from data tests, which check production data.

## YAML

```yaml
unit_tests:
  - name: <test-name>            # Required, unique
    description: <string>
    model: <model-name>          # Required
    versions:                    # Versioned models
      include: [2]               # or exclude: [1]
    given:                       # Required
      - input: ref('model')      # or source('schema', 'table')
        format: dict | csv | sql # Default: dict
        rows: [{...}]            # Inline, or:
        fixture: <fixture-name>  # csv / sql formats
    expect:                      # Required
      format: dict | csv | sql
      rows: [{...}]
      fixture: <fixture-name>
    overrides:
      macros:
        is_incremental: true | false
        dbt_utils.star: col_a,col_b
      vars: {key: value}
      env_vars: {KEY: value}
    config:
      tags: [tag]
      enabled: false             # Disable without deleting
```

Placement and conventions:

- Unit tests in YAML files under `model-paths` (`models/` by default).
- Fixtures under `test-paths/fixtures/` (`tests/fixtures/` by default).
- Include all `ref`/`source` deps as `input`s — even irrelevant ones with `rows: []`.
- Seeds without an explicit `input` use their CSV file as-is.
- Use table aliases when testing `join` logic.

## Data formats

| Format | Subset columns? | Fixture files? | Ephemeral models? | Jinja? |
| --- | --- | --- | --- | --- |
| `dict` (default) | Yes | No (inline only) | No | No |
| `csv` | Yes | Yes | No | No |
| `sql` | No (all columns) | Yes | Yes | No |

Default to `dict`. `csv` for fixture files. `sql` for ephemeral deps or unsupported types.

### Dict

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
    rows: |
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
    rows: |
      select 1 as id, 'gerda' as name union all
      select 2 as id, 'michelle' as name
  - input: ref('other_model')
    format: sql
    fixture: my_fixture        # tests/fixtures/my_fixture.sql
```

`sql` requires all columns. Jinja is not supported in fixtures.

## Special cases

### Incremental models

Override `is_incremental` and test both modes:

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
      # What gets merged/inserted, NOT final table state
      rows:
        - {event_id: 2, event_time: 2020-01-02}
```

The model must exist in the database before unit tests run:

```bash
dbt run --select "config.materialized:incremental" --empty
```

### Ephemeral inputs

`format: sql` required:

```yaml
given:
  - input: ref('ephemeral_model')
    format: sql
    rows: |
      select 1 as id, 'emily' as name
```

### `dbt_utils.star` override

```yaml
overrides:
  macros:
    dbt_utils.star: col_a,col_b,col_c
```

### Versioned models

Default: run on all versions. Target specific ones:

```yaml
versions:
  include: [2]      # Only version 2
  # exclude: [1]    # All except version 1
```

## Running

```bash
dbt build --select my_model                      # Unit + build + data tests
dbt test --select "my_model,test_type:unit"      # Unit tests for one model
dbt test --select test_my_specific_test          # Single unit test
```

Exclude from production: `--exclude-resource-type unit_test` or `DBT_EXCLUDE_RESOURCE_TYPES=unit_test`.

## Failures

Output shows a row-level diff:

```text
actual differs from expected:

@@ ,email           ,is_valid_email_address
->  ,cool@example.com,True->False
   ,cool@unknown.com,False
```

Two possibilities: test expectation wrong, or model has a bug. Judgment call from the intended logic.

## Warehouse caveats

### BigQuery

- **All** fields required in a `STRUCT` — subsets not supported.
- `geography_field: 'st_geogpoint(75, 45)'`, `struct_field: 'struct("Isha" as name, 22 as age)'`
- JSON: `json_field: {"name": "Cooper"}`. Arrays: `str_array_field: ['a','b','c']`.

### Snowflake

- Variant: `variant_field: 3`. Object: `object_field: {'Alberta':'Edmonton'}`.
- Geo: `geography_field: POINT(-122.35 37.55)`, `geometry_field: POINT(1820.12 890.56)`.
- Arrays: `str_array_field: ['a','b','c']`, `int_array_field: [1, 2, 3]`.
- Binary: `binary_field: 19E1FFDCCB6CDEE788BF631C1C4905D1`.

### Postgres / Redshift

- `array` not supported in `dict` — use `sql`.
- Postgres JSON: `json_field: '{"bar": "baz", "balance": 7.77, "active": false}'`.
- Redshift sources must share the database with models.
- Redshift CTE functions like `LISTAGG`, `MEDIAN`, `PERCENTILE_CONT` are unsupported in CTEs and so cannot be unit-tested.

### Spark

- Arrays: `int_array_field: 'array(1, 2, 3)'`. Maps: `'map("10", "t")'`. Structs: `'named_struct("a", 1, "b", 2)'`.
