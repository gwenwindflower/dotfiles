# CLI Reference

Advanced selector syntax, `dbt list`, `dbt show` gotchas, deferral, run results, and static analysis. For basics (graph operators, variables, command patterns), see SKILL.md.

## Selection Methods

```bash
--select my_model                  # Single model
--select staging.*                 # Path pattern
--select fqn:*stg_*               # FQN pattern
--select model_a model_b          # Union (space-separated)
--select tag:x,config.mat:y       # Intersection (comma)
--exclude my_model                 # Exclude from selection
--select "source:ecom.*"          # Sources (quote for shell safety)
```

### Resource Type Filters

```bash
resource-type:model
resource-type:unit_test

# Skip seed data during build
dbt build --exclude resource_type:seed
```

Valid types: `model`, `test`, `unit_test`, `snapshot`, `seed`, `source`, `exposure`, `metric`, `semantic_model`, `saved_query`, `analysis`

## dbt list

Preview selections before running. Use JSON output for scripting.

```bash
dbt list --select my_model+
dbt list --output json
dbt list --select my_model --output json --output-keys unique_id name resource_type config
```

**JSON output keys**: `unique_id`, `name`, `resource_type`, `package_name`, `original_file_path`, `path`, `alias`, `description`, `columns`, `meta`, `tags`, `config`, `depends_on`, `patch_path`, `schema`, `database`, `relation_name`, `raw_code`, `compiled_code`, `language`, `docs`, `group`, `access`, `version`, `fqn`, `refs`, `sources`, `metrics`

## dbt show Gotchas

Use `--limit` flag, **not** a SQL `LIMIT` clause -- SQL LIMIT causes syntax errors with `dbt show`.

Push limits early in CTEs when exploring to minimize scanning:

```sql
-- Good: limits at the source
with orders as (
    select * from {{ source('ecom', 'orders') }} limit 100
)
select ... from orders

-- Bad: full table scan before limiting
with orders as (
    select * from {{ source('ecom', 'orders') }}
)
select ... from orders
```

## Defer (Skip Upstream Builds)

Reference production data instead of rebuilding upstream models.

```bash
dbt build --select my_model --defer --state prod-artifacts
dbt build --select my_model --defer --state prod-artifacts --favor-state
```

| Flag | Purpose |
| --- | --- |
| `--defer` | Enable deferral to state manifest |
| `--state <path>` | Path to manifest from previous run (e.g., production artifacts) |
| `--favor-state` | Prefer node definitions from state even if they exist locally |

## Build Artifacts

Inspect `target/run_results.json` after any dbt command:

```bash
# Quick status
jq '.results[] | {node: .unique_id, status: .status, time: .execution_time}' target/run_results.json

# Find failures
jq '.results[] | select(.status != "success")' target/run_results.json

# Get compiled SQL for failed models
jq '.results[] | select(.status == "error") | .compiled_code' target/run_results.json
```

| Field | Values / Description |
| --- | --- |
| `status` | `success`, `error`, `fail`, `skipped`, `warn` |
| `execution_time` | Seconds spent executing |
| `compiled_code` | Rendered SQL |
| `adapter_response` | Database metadata (rows affected, bytes processed) |

**Other artifacts**:

- `logs/dbt.log` -- full query log, errors at bottom
- `target/compiled/` -- rendered model SQL as SELECT statements
- `target/run/` -- rendered SQL inside DDL (`CREATE TABLE AS SELECT`)

## Validation Commands (Cheapest First)

| Command | Cost | Catches |
| --- | --- | --- |
| `dbt parse` | Free (no warehouse) | YAML / project config errors |
| `dbt compile --select model` | Low | SQL errors (Fusion only) |
| `dbt build --select model` | Medium | Everything: parse + compile + run + test |
