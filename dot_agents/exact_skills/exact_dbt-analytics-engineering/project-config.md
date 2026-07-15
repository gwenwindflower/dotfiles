# Project Config

Load this when changing project-level dbt configuration, environment routing, selection behavior, or inherited resource defaults.

## Profiles

`profile:` in `dbt_project.yml` names the connection profile dbt should use locally:

```yaml
name: jaffle_shop
profile: jaffle_shop
```

Rules:

- Local CLI runs need `profile:` unless the command passes `--profile`.
- `--profile` overrides `dbt_project.yml`.
- The active profile output is `target`; use `target.name` in Jinja for environment-specific logic.
- Do not commit credentials. `profiles.yml` should read secrets from env vars or local config.

## Resource Paths

Resource paths are nested keys under a resource type in `dbt_project.yml`: project name, directories, then optional resource name.

Directory-wide model config:

```yaml
name: jaffle_shop

models:
  jaffle_shop:
    staging:
      +materialized: view
    intermediate:
      +schema: intermediate
      +materialized: view
    marts:
      +materialized: table
```

Specific model config:

```yaml
models:
  jaffle_shop:
    staging:
      stripe:
        payments:
          +materialized: table
```

Use the `+` prefix for inherited config under resource paths. Without `+`, dbt can interpret nested keys as paths or resource names.

## Materialization Placement

| Place | Use when |
| --- | --- |
| `dbt_project.yml` directory config | A whole folder follows the same default |
| Model SQL `config(...)` | One model needs behavior different from its directory |
| Model YAML `config:` | Keeping resource metadata and config together is clearer |

Closest config wins. Model-level config overrides directory defaults.

Example model-local config:

```sql
{{
    config(
        materialized='incremental',
        unique_key='event_id'
    )
}}
```

Example YAML config:

```yaml
models:
  - name: orders
    config:
      materialized: table
      contract:
        enforced: true
```

## Selectors

A selector is either an inline `--select` expression or a named selector in `selectors.yml`.

```yaml
selectors:
  - name: nightly_marts
    definition:
      union:
        - method: path
          value: models/marts
        - method: tag
          value: nightly
```

Run with:

```bash
dbt build --select selector:nightly_marts
```

Before changing selectors, run `dbt ls --select <selector>` to confirm the selected resources.
