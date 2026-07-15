# Debugging dbt Errors

Start with the cheapest command that can reproduce the failure, then inspect the artifact closest to the error.

## Artifacts

| Artifact | Use |
| --- | --- |
| `logs/dbt.log` | Full SQL and adapter error context; newest entries at bottom |
| `target/run_results.json` | Node status, timing, compiled SQL references |
| `target/compiled/` | Rendered model SQL as SELECTs |
| `target/run/` | Rendered DDL or materialization SQL |

```bash
jq '.results[] | select(.status != "success")' target/run_results.json
```

## Error Classes

### Project / YAML

```text
error: dbt1013: YAML error: did not find expected key at line 14 column 7
```

Fix YAML first. If the project is on v2/Fusion or preparing for it, check deprecated config shapes in [CLI Reference](cli-commands-reference.md) and consider `uvx dbt-autofix deprecations`.

### Model Code / SQL

```text
error: dbt0101: mismatched input 'orders' expecting one of 'SELECT', 'TABLE', '('
```

Open the rendered SQL under `target/compiled/`; debug that SQL, not the unrendered model. Fusion catches more SQL issues at compile time than Python Core.

### Unit Test Failures

```text
actual differs from expected:
->,2,San Andreas,2079-10-27 00:00:00->2079-10-27 23:59:59.999900
```

Compare the expected fixture to the intended logic. Either the test expectation is wrong or the model is.

### Data Test Failures

```text
Failure in test accepted_values_customers_customer_type__new__returning
  Got 1 result, configured to fail if != 0
```

Query the compiled failed-test SQL. Fix the data transformation where the bad value originates. Do not remove or weaken a test without explicit permission.

## Verification Ladder

| Command | Cost | Catches |
| --- | --- | --- |
| `dbt parse` | Free | YAML and project config |
| `dbt compile --select model` | Low | Jinja and SQL syntax |
| `dbt build --select model` | Medium | Run behavior and tests |

Always scope warehouse commands with `--select`.
