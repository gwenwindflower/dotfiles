# Planning and Discovery

Plan backwards from output; discover data before writing SQL.

## Planning workflow

1. **Mock the final output** — table with PK, columns, sample rows, grain, materialization.
2. **Mock the SQL** — pseudocode for that output, even if upstream is unknown.
3. **Identify gaps** — date fields, aggregation logic, edge cases.
4. **Mock upstream models** — what inputs does your SQL need?
5. **Refine SQL** with real upstream structure.
6. **Match against existing models** — extend before adding:

   | Priority | Scenario | Action |
   | --- | --- | --- |
   | 1 | Exact match exists | Use it directly |
   | 2 | Partial match | Add a column or extend; replan recursively |
   | 3 | No match | New model, repeat planning |

7. **Write failing unit tests** for edge cases before implementing.
8. **Implement**, run unit tests, verify with `dbt show`.

### Placeholder columns

Lock the interface early, even before logic is complete:

```sql
select
  transaction_date,
  product_id,
  null::integer as quantity_on_hand   -- TODO: window function
from {{ ref('stg_inventory_transactions') }}
```

### Inline planning doc

```markdown
## Goal: Daily inventory levels per product
## Grain: One row per product per day
## Transformations:
1. Combine transaction types
2. Window function for cumulative quantity
3. Filter to end-of-day balance
```

## Data discovery

Required for every table you build on. The rationalizations:

| "..." | Reality |
| --- | --- |
| I'll do proper discovery later | You won't. |
| 47 tables is too many | Scope ruthlessly first, then discover the scoped set. |
| Standard pattern, I know this | The pattern is standard; this instance's data may not be. Verify. |

### Step 1 — Inventory

```bash
dbt ls --select "source:ecom.*" --output json
dbt ls --select "my_model another_model" --output json
```

Review existing YAML at `original_file_path`.

### Step 2 — Sample and profile

```bash
dbt show --inline "select * from {{ source('source_name', 'table_name') }}" --limit 50 --output json
```

Document column types, identifiers vs attributes, null rates, low-cardinality values.

### Step 3 — Standard EDA

For each table:

- Identify the grain (one row per ...).
- Check for duplicate / null primary keys.
- Validate data ranges (timestamps in the past, etc.).
- Profile key columns: distinct count, null rate, min/max.
- Identify foreign-key relationships and orphan rates.
- Check for soft deletes (`deleted_at`, `is_active`, `status`).

### Discovery report template

```markdown
## Source: {source_name}.{table_name}

- **Row count**: X
- **Grain**: one row per [entity] per [time period]
- **Primary key**: column_name (verified unique)

### Columns
| Column | Type | Nulls | Notes |
| --- | --- | --- | --- |
| id | integer | 0% | Primary key |
| status | string | 2% | Values: active, inactive, pending |

### Data quality
- [ ] `status` has 15 rows of "unknown" — clarify with stakeholder
- [ ] `amount` has negatives — confirm validity

### Relationships
- `user_id` -> `users.id` (5 orphans)
- `product_id` -> `products.id` (clean)

### Recommended staging transformations
1. Filter or map `status = 'unknown'`
2. Cast `created_at` to a consistent timezone
```

## Pitfalls

- **Column names lie.** `customer_id` may hold account IDs. Verify.
- **Discovery without documentation wastes the work.** Write it down now.
- **Relationship tests on sample data only.** Orphans hide outside the sample.
- **Ignoring soft deletes.** Always check.
