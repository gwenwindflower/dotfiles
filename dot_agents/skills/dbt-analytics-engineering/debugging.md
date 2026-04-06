# Debugging dbt Errors

## Logs and Artifacts

| Artifact | Contains |
| --- | --- |
| `logs/dbt.log` | All queries, additional logging. Recent errors at bottom. |
| `target/run_results.json` | Status of each model in most recent invocation |
| `target/compiled/` | Rendered model SQL as SELECT statements |
| `target/run/` | Rendered SQL inside DDL (`CREATE TABLE AS SELECT`) |

```bash
jq '.results[] | select(.status != "success")' target/run_results.json
```

## Error Classification

### Invalid Project Configuration (YAML/Parsing)

```text
error: dbt1013: YAML error: did not find expected key at line 14 column 7
  --> models/anchor_tests.yml:14:7
```

Fix: update the YAML to conform to correct structure.

### Invalid Model Code (Compilation/SQL)

```text
error: dbt0101: mismatched input 'orders' expecting one of 'SELECT', 'TABLE', '('
  --> models/marts/customers.sql:9:1 (target/compiled/models/marts/customers.sql:9:1)
```

Fix: update the SQL. Check `target/compiled/` for rendered SQL to see actual error context.

### Unit Test Failures

```text
actual differs from expected:

@@,location_id,location_name,opened_date
  ,1          ,Vice City    ,2016-09-01 00:00:00
->,2          ,San Andreas  ,2079-10-27 00:00:00->2079-10-27 23:59:59.999900
```

Either the test is wrong or the model has a bug. Review both the test definition and model logic.

### Invalid Data (Test Failures)

```text
Failure in test accepted_values_customers_customer_type__new__returning
  Got 1 result, configured to fail if != 0
  compiled code at target/compiled/.../accepted_values_...sql
```

Resolve by transforming data in the staging layer. Do not remove or weaken a test without explicit permission.

## Verification

Choose the cheapest command that validates the fix:

| Command | Cost | Use When |
| --- | --- | --- |
| `dbt parse` | Free | YAML/project config errors |
| `dbt compile --select model` | Low | SQL syntax (Fusion detects more) |
| `dbt build --select model` | Medium | Model logic + test failures |

Always use `--select` for warehouse commands to avoid processing the entire project.
