# CLI Reference

Advanced selectors, defer, artifacts, validation tiers, new v2/Fusion commands, and the deprecation list that must be cleared before a project runs on v2 or Fusion. For basics, see SKILL.md.

## Selection

```bash
--select my_model                  # Single model
--select staging.*                 # Path pattern
--select fqn:*stg_*                # FQN pattern
--select model_a model_b           # Union (space)
--select tag:x,config.mat:y        # Intersection (comma)
--exclude my_model                 # Exclude
--select "source:ecom.*"           # Sources (quote for shell safety)
--select state:modified+ result:error+ --defer --state path/to/prod   # Slim CI
```

### Resource type filters

```bash
resource-type:model
resource-type:unit_test
dbt build --exclude resource_type:seed
```

Valid types: `model`, `test`, `unit_test`, `snapshot`, `seed`, `source`, `exposure`, `metric`, `semantic_model`, `saved_query`, `analysis`, `function` (v1.11+ UDFs).

> **Deprecated:** `--models` / `-m` are removed under v2/Fusion. Always use `--select` / `-s`.

## Impact assessment

Before modifying an existing model:

```bash
dbt ls --select model_name+ --output name        # list downstream
dbt ls --select model_name+ --output name | wc -l
```

Low (1-5): proceed. Medium (6-15): consider limiting depth via `+N`. High (16+): confirm with user. Build modified + downstream: `dbt build --select state:modified+` (or `+N` for limited depth). For column renames/removals, grep downstream SQL for the column name first.

## dbt list

Preview selections before running. JSON for scripting.

```bash
dbt list --select my_model+
dbt list --output json
dbt list --select my_model --output json --output-keys unique_id name resource_type config
```

JSON keys: `unique_id`, `name`, `resource_type`, `package_name`, `original_file_path`, `path`, `alias`, `description`, `columns`, `meta`, `tags`, `config`, `depends_on`, `patch_path`, `schema`, `database`, `relation_name`, `raw_code`, `compiled_code`, `language`, `docs`, `group`, `access`, `version`, `fqn`, `refs`, `sources`, `metrics`.

## dbt show

Use `--limit` flag, **not** a SQL `LIMIT` clause — `LIMIT` in the SQL causes syntax errors with `dbt show`.

Push limits early in CTEs when exploring:

```sql
-- Good: limits at the source
with orders as (
    select * from {{ source('ecom', 'orders') }} limit 100
)
select ... from orders
```

## Defer

Reference production state instead of rebuilding upstream.

```bash
dbt build --select my_model --defer --state path/to/prod-artifacts
dbt build --select my_model --defer --state path/to/prod-artifacts --favor-state
```

| Flag | Purpose |
| --- | --- |
| `--defer` | Enable deferral to state manifest |
| `--state <path>` | Path to manifest from previous run |
| `--favor-state` | Prefer node definitions from state even if local |

## Build artifacts

Inspect `target/run_results.json` after any command:

```bash
jq '.results[] | {node: .unique_id, status: .status, time: .execution_time}' target/run_results.json
jq '.results[] | select(.status != "success")' target/run_results.json
jq '.results[] | select(.status == "error") | .compiled_code' target/run_results.json
```

| Field | Values |
| --- | --- |
| `status` | `success`, `error`, `fail`, `skipped`, `warn` |
| `execution_time` | Seconds |
| `compiled_code` | Rendered SQL |
| `adapter_response` | Database metadata (rows, bytes) |

Other artifacts: `logs/dbt.log`, `target/compiled/` (rendered SELECTs), `target/run/` (rendered DDL).

## Validation tiers (cheapest first)

| Command | Cost | Catches |
| --- | --- | --- |
| `dbt parse` | Free | YAML / project config errors |
| `dbt compile --select model` | Low | SQL errors (Fusion's SQL comprehension catches far more than Python Core) |
| `dbt build --select model` | Medium | Everything: parse + compile + run + test |

## New in v2 / Fusion

| Command | Status | Use |
| --- | --- | --- |
| `dbt login` | GA (v2, 1.12) | Browser OAuth to dbt platform; `dbt login status`. CI uses env vars (`DBT_CLOUD_ACCOUNT_HOST`, `DBT_CLOUD_ACCOUNT_ID`, `DBT_CLOUD_TOKEN`, `DBT_CLOUD_PROJECT_ID`). Creds at `~/.dbt/`. |
| `dbt lint` | Beta | SQLFluff-compatible (reads `.sqlfluff`, same rule codes, `-- noqa`), ~50x faster than SQLFluff. |
| `dbt sl <subcommand>` | GA | Unified semantic-layer surface: `list metrics`, `list dimensions`, `list dimension-values`, `list entities`, `list saved-queries`, `query`, `validate`, `export`, `export-all`. |
| `dbt run --select "resource_type:function"` | v1.11+ | Build UDFs declared in `functions/`. Reference in SQL with `{{ function('name') }}`. |
| `--use-v2-parser` | Beta (1.12) | Delegate parse to the Rust parser. 5–10x faster. |
| `--manage-state` / `--no-manage-state` | 1.12 | dbt state management on/off. |
| `dbt run-operation --sql "..."` | Beta | Ad-hoc SQL through the Jinja pipeline. |
| `dbt seed --empty` | 1.12 | Create the seed schema without loading data. |
| `--select selector:my_selector` | Beta | Compose named selectors. |

## Deprecations cleared before v2 / Fusion

These error under v2/Fusion. Auto-fix most with `uvx dbt-autofix deprecations`.

### Project config

| Old | New |
| --- | --- |
| `data-paths` | `seed-paths` |
| `source-paths` | `model-paths` |
| `target-path` / `log-path` in `dbt_project.yml` | CLI flags only |
| Custom top-level keys | Nest under `config.meta` |
| Inline `freshness`/`meta`/`tags`/`docs`/`group`/`access` on resources | Move into the resource's `config:` block |
| `profiles.yml` `config:` block | `dbt_project.yml` `flags:` |
| Hierarchical configs without `+` prefix | `+materialized:` etc. |

### CLI flags

| Old | New |
| --- | --- |
| `--models` / `-m` | `--select` / `-s` |
| `dbt source freshness --output` | `--target-path` |
| `warn_error_options.include` | `warn_error_options.error` |

### Names

- Resource names cannot contain spaces.
- Exposure names: letters, numbers, underscores only — use `label:` for display.
- `generate_schema_name` macro must never return `null`.

### Behavior flags (default `false` in 1.11, always-on in v2/Fusion)

Set these to `true` in `flags:` before upgrading so you fix errors on 1.11 first:

- `require_unique_project_resource_names`
- `require_ref_searches_node_package_before_root`
- `require_valid_schema_from_generate_schema_name`
- `require_sql_header_in_test_configs`
- `require_corrected_analysis_fqns`
- `require_source_and_semantic_model_names_without_spaces`
- `require_generic_test_arguments_property` — generic test args must nest under `arguments:`

Run `uvx dbt-autofix deprecations` to migrate most of these automatically.
