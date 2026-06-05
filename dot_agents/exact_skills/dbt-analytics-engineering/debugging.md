# Debugging dbt Errors

## Logs and artifacts

| Artifact | Contains |
| --- | --- |
| `logs/dbt.log` | All queries, error context. Most recent at the bottom. |
| `target/run_results.json` | Status of each model in the last invocation |
| `target/compiled/` | Rendered model SQL as SELECTs |
| `target/run/` | Rendered SQL inside DDL (`CREATE TABLE AS SELECT`) |

```bash
jq '.results[] | select(.status != "success")' target/run_results.json
```

## Error classes

### Project / YAML

```text
error: dbt1013: YAML error: did not find expected key at line 14 column 7
  --> models/anchor_tests.yml:14:7
```

Fix the YAML. Many YAML errors under v2/Fusion come from deprecated shapes — see the deprecation tables in [cli-commands-reference.md](cli-commands-reference.md), then try `uvx dbt-autofix deprecations`.

### Model code / SQL

```text
error: dbt0101: mismatched input 'orders' expecting one of 'SELECT', 'TABLE', '('
  --> models/marts/customers.sql:9:1 (target/compiled/models/marts/customers.sql:9:1)
```

Check `target/compiled/` for the rendered SQL — that's the actual error context. Fusion's SQL comprehension catches more than Python Core; if a column or function ref is wrong, Fusion will say so at compile time.

### Unit test failures

```text
actual differs from expected:

@@,location_id,location_name,opened_date
  ,1          ,Vice City    ,2016-09-01 00:00:00
->,2          ,San Andreas  ,2079-10-27 00:00:00->2079-10-27 23:59:59.999900
```

Either the test is wrong or the model has a bug. Review both.

### Data test failures

```text
Failure in test accepted_values_customers_customer_type__new__returning
  Got 1 result, configured to fail if != 0
  compiled code at target/compiled/.../accepted_values_...sql
```

Resolve by transforming data in staging. **Do not remove or weaken a test without explicit permission.**

## Verification ladder

Cheapest first:

| Command | Cost | Use when |
| --- | --- | --- |
| `dbt parse` | Free | YAML / project config |
| `dbt compile --select model` | Low | SQL syntax (Fusion catches far more) |
| `dbt build --select model` | Medium | Logic + tests |

Always `--select` for warehouse commands.
