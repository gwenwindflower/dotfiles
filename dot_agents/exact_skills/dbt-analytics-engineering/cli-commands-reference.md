# CLI Reference

Selectors, impact checks, defer, artifacts, validation tiers, v2/Fusion commands, and migration blockers. For defaults, see [dbt Analytics Engineering](SKILL.md).

## Selection

```bash
--select my_model
--select staging.*
--select fqn:*stg_*
--select model_a model_b                 # union
--select tag:x,config.mat:y              # intersection
--exclude my_model
--select "source:ecom.*"
--select state:modified+ result:error+ --defer --state path/to/prod
```

Resource type filters:

```bash
resource-type:model
resource-type:unit_test
dbt build --exclude resource_type:seed
```

Valid types include `model`, `test`, `unit_test`, `snapshot`, `seed`, `source`, `exposure`, `analysis`, and `function` (v1.11+ UDFs).

`--models` / `-m` are removed under v2/Fusion. Use `--select` / `-s`.

## Impact Assessment

Before modifying an existing model:

```bash
dbt ls --select model_name+ --output name
dbt ls --select model_name+ --output name | wc -l
```

Impact tiers:

| Downstream count | Action |
| --- | --- |
| 1-5 | Proceed after reading downstream YAML/SQL |
| 6-15 | Consider limited depth (`+N`) |
| 16+ | Confirm scope with the user |

For column renames or removals, grep downstream SQL for the column first.

## dbt List

Use `dbt list`/`dbt ls` to preview selections. JSON output is best for scripting:

```bash
dbt list --select my_model+
dbt list --select my_model --output json --output-keys unique_id name resource_type config
```

Useful JSON keys: `unique_id`, `name`, `resource_type`, `original_file_path`, `path`, `description`, `columns`, `config`, `depends_on`, `relation_name`, `raw_code`, `compiled_code`, `fqn`, `refs`, and `sources`.

## dbt Show

Use `--limit` for the final row cap. `limit` often does not reduce table scans; use adapter-supported sampling when the goal is warehouse cost savings.

```bash
dbt show --select my_model --limit 10
dbt show --inline "select * from {{ ref('orders') }}" --limit 5
```

For cheap exploration, sample where the adapter supports it:

```sql
with orders as (
    select * from {{ source('ecom', 'orders') }}
    {{ limit_in_dev() }}
)
select * from orders
```

## Defer

Reuse production state instead of rebuilding upstream:

```bash
dbt build --select my_model --defer --state path/to/prod-artifacts
dbt build --select my_model --defer --state path/to/prod-artifacts --favor-state
```

| Flag | Purpose |
| --- | --- |
| `--defer` | Resolve unbuilt upstreams from state |
| `--state <path>` | Manifest/artifact directory |
| `--favor-state` | Prefer state definitions even when local differs |

## Artifacts

Inspect `target/run_results.json` after commands:

```bash
jq '.results[] | {node: .unique_id, status: .status, time: .execution_time}' target/run_results.json
jq '.results[] | select(.status != "success")' target/run_results.json
jq '.results[] | select(.status == "error") | .compiled_code' target/run_results.json
```

Other useful paths: `logs/dbt.log`, `target/compiled/`, `target/run/`.

## Validation Tiers

| Command | Cost | Catches |
| --- | --- | --- |
| `dbt parse` | Free | YAML and project config |
| `dbt compile --select model` | Low | Jinja and SQL syntax |
| `dbt build --select model` | Medium | Run behavior and tests |

## New in v2 / Fusion

| Command | Status | Use |
| --- | --- | --- |
| `dbt lint` | Beta | SQLFluff-compatible linting |
| `dbt build --select "resource_type:function"` | v1.11+ | Build UDFs declared in `functions/` |
| `--use-v2-parser` | Beta | Rust parser in Core 1.12 |
| `--manage-state` / `--no-manage-state` | 1.12 | Toggle dbt state management |
| `dbt run-operation --sql "..."` | Beta | Ad-hoc SQL through Jinja |
| `dbt seed --empty` | 1.12 | Create seed schema without loading data |
| `--select selector:my_selector` | Beta | Named selectors |

## v2 / Fusion Migration Blockers

These error under v2/Fusion. Auto-fix most with `uvx dbt-autofix deprecations`.

### Project Config

| Old | New |
| --- | --- |
| `data-paths` | `seed-paths` |
| `source-paths` | `model-paths` |
| `target-path` / `log-path` in `dbt_project.yml` | CLI flags only |
| Custom top-level keys | `config.meta` |
| Inline `freshness`/`meta`/`tags`/`docs`/`group`/`access` | Resource `config:` |
| `profiles.yml` `config:` block | `dbt_project.yml` `flags:` |
| Hierarchical configs without `+` prefix | `+materialized:` etc. |

### CLI and Names

- `--models` / `-m` -> `--select` / `-s`.
- `dbt source freshness --output` -> `--target-path`.
- `warn_error_options.include` -> `warn_error_options.error`.
- Resource names cannot contain spaces.
- Exposure names use letters, numbers, and underscores; use `label:` for display.
- `generate_schema_name` must never return `null`.

### Behavior Flags

Set these to `true` on 1.11 before upgrading:

- `require_unique_project_resource_names`
- `require_ref_searches_node_package_before_root`
- `require_valid_schema_from_generate_schema_name`
- `require_sql_header_in_test_configs`
- `require_corrected_analysis_fqns`
- `require_generic_test_arguments_property`
