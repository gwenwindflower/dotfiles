# Planning and Discovery

Plan from the desired output backward, then verify the data before writing production SQL.

## Planning Workflow

1. Mock the final output: grain, primary key, columns, sample rows, materialization.
2. Sketch the SQL shape in pseudocode.
3. Identify unknowns: date fields, aggregation rules, edge cases, required joins.
4. Mock the upstream models or sources your SQL needs.
5. Check existing models before adding new ones.
6. Write failing unit tests for behavior-heavy logic.
7. Implement the smallest passing SQL, then verify with `dbt show`.

Existing-model priority:

| Priority | Scenario | Action |
| --- | --- | --- |
| 1 | Exact match exists | Use it |
| 2 | Partial match | Extend it, then replan if needed |
| 3 | No match | Add a model with a clear grain |

### Placeholder Columns

Lock the interface early when the final shape is known before the logic:

```sql
select
    transaction_date,
    product_id,
    cast(null as integer) as quantity_on_hand
from {{ ref('stg_inventory_transactions') }}
```

### Planning Note

```markdown
## Goal
Daily inventory levels per product.

## Grain
One row per product per day.

## Transformations
1. Combine transaction types.
2. Calculate cumulative quantity.
3. Keep end-of-day balance.
```

## Data Discovery

Discover every table you build on. Scope first when there are many candidates.

### 1. Inventory Candidate Resources

```bash
dbt ls --select "source:ecom.*" --output json
dbt ls --select "my_model another_model" --output json
```

Read existing YAML at `original_file_path`.

### 2. Sample and Profile

```bash
dbt show --inline "select * from {{ source('source_name', 'table_name') }}" --limit 50 --output json
```

Record column types, identifiers vs. attributes, null rates, and low-cardinality values.

### 3. Standard Checks

For each table:

- Identify the grain.
- Check duplicate and null primary keys.
- Validate date and numeric ranges.
- Profile key columns: distinct count, null rate, min/max.
- Check foreign-key relationships and orphan rates.
- Look for soft deletes (`deleted_at`, `is_active`, `status`).

## Discovery Report

```markdown
## Source: {source_name}.{table_name}

- Row count: X
- Grain: one row per ...
- Primary key: column_name (verified unique)

| Column | Type | Nulls | Notes |
| --- | --- | --- | --- |
| id | integer | 0% | Primary key |
| status | string | 2% | Values: active, inactive, pending |

## Data Quality

- `status` has 15 rows of "unknown" - clarify mapping.
- `amount` has negatives - confirm whether refunds create them.

## Relationships

- `user_id` -> `users.id` (5 orphans)
- `product_id` -> `products.id` (clean)

## Recommended Staging Changes

1. Map or preserve `status = 'unknown'`.
2. Cast `created_at` to the project timestamp standard.
```

## Pitfalls

- Column names lie; verify that IDs identify what they claim.
- Discovery without documentation is wasted context.
- Relationship tests on samples miss off-sample orphans.
- Soft deletes change grain and validity; check them early.
