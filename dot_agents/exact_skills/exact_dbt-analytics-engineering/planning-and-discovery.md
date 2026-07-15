# Planning and Discovery

When a user is unclear on the model shape, plan from the desired output backward. Then, verify the data before writing production SQL.

## Planning Workflow

1. Mock the final output with the user; nail down grain, primary key, columns, sample rows, and materialization.
2. Identify unknowns — date fields, aggregation rules, edge cases, required joins — and settle on solutions.
3. Understand mutability and solidify your approach to it. Look for soft deletes and status columns (`deleted_at`, `is_active`, `user_status`, `order_state`). You may need to build an SCD from an append-only source, or melt append-only logs into a current-state status table. Be clear on both your sources and your output goal. This matters most with incremental models, which add another layer of transformation around these fields.
4. Identify gaps in upstream dependencies. If new sources or models are needed, apply this same process recursively up the chain, then loop back to the original model.
5. Write tests to prove the model meets requirements and to guard against regressions; data can change underneath a model without the code changing. Always test primary keys, add relationship tests for foreign keys, and add unit tests for complex column transformations.

Existing-model priority:

| Priority | Scenario | Action |
| --- | --- | --- |
| 1 | Model with needed fields exists | Use it |
| 2 | Model with right grain but missing columns | Extend it and adjust plan, repeat as needed |
| 3 | No match for needed grain | Add a model with a clear grain |

The crucial point is to avoid model sprawl. Churning out new models is easy; it's much *better* to be intentional and build flexible models that can be reused across contexts.

## Data Discovery

Get clear on sources when there are many candidates.

### 1. Inventory Candidate Resources

```bash
dbt ls --select "source:ecom.*" --output json
dbt ls --select "my_model another_model" --output json
```

Read related YAML and SQL to understand what exists.

### 2. Sample and Profile

```bash
dbt show --inline "select * from {{ source('source_name', 'table_name') }}" --limit 10 --output json
```

`--limit` caps returned rows, not necessarily scanned data; use warehouse-supported sampling for large sources when scan cost matters.

Profile what you find:

- Note column types, primary and foreign keys, null rates, and low-cardinality values.
- Identify columns that need casting, renaming, or dropping in a clean version of the model. When a column is almost what you need, prefer a simple transformation over a new model.
- Note the relationships you'll need to test and enforce.
- Validate date and numeric ranges. Filtering out data you don't need (e.g. older than two years) is high-impact — note it.
- For large tables, consider partitioning at a coarseness that lands individual partitions between 2GB and 50GB; warehouse metadata helps size this.

### 3. Build

Now both you and the user should have a clear understanding of the model shape, and you can build, fix, or extend the models you need in the most performant and maintainable way possible. The fundamental key is working backward from desired output to available sources, making the minimum necessary changes — not bouncing around the DAG or building new verticals on already-modeled sources when it can be avoided.
