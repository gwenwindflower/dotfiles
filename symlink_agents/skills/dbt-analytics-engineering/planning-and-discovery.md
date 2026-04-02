# Planning and Discovery

## Planning New Models

Start with the desired output and work backwards.

### 8-Step Workflow

1. **Mock the final output** -- table with primary key, columns, sample data, target grain, materialization
2. **Mock the SQL** -- write pseudocode/SQL for that output, even if source tables are unknown
3. **Identify gaps** -- questions about date fields, aggregation logic, edge cases
4. **Mock upstream models** -- what inputs does your SQL need?
5. **Update SQL** -- refine with real upstream structure
6. **Match with existing data** -- find what already exists in the project:

| Priority | Scenario | Action |
| --- | --- | --- |
| 1 | Exact match exists | Use it directly |
| 2 | Partial match | Extend it, plan changes recursively |
| 3 | No match | Create new model, repeat planning process |

1. **Write failing unit tests** -- cover edge cases with mocked inputs before implementing
2. **Implement** -- build the model, run unit tests to verify

### Placeholder Columns

Define the interface early, even before logic is complete:

```sql
select
  transaction_date,
  product_id,
  null::integer as quantity_on_hand -- TODO: implement window function
from {{ ref('stg_inventory_transactions') }}
```

### Inline Planning Docs

```markdown
## Goal: Daily inventory levels per product
## Grain: One row per product per day
## Transformations:
1. Combine transaction types
2. Window function for cumulative quantity
3. Filter to end-of-day balance
```

## Discovering Data

### Complete All Steps for Every Table You Build Models On

| Rationalization | Reality |
| --- | --- |
| "I'll do proper discovery later" | You won't. Document now. |
| "47 tables is too many" | Scope ruthlessly first, full discovery on scoped tables only. |
| "Standard patterns, I know this" | You know the pattern. This instance's data might vary. Verify. |

### Step 1: Inventory

```bash
# Sources
dbt ls --select "source:ecom.*" --output json

# Models
dbt ls --select "my_model another_model" --output json
```

Review existing YAML documentation at `original_file_path`.

### Step 2: Sample and Profile

```bash
dbt show --inline "SELECT * FROM {{ source('source_name', 'table_name') }}" --limit 50 --output json
```

Document immediately: column types, identifiers vs attributes, nulls, low-cardinality values.

### Step 3: Standard EDA

For each table:

- Identify the grain
- Check for duplicate/null primary keys
- Validate data ranges (timestamps in the past, etc.)
- Profile key columns (distinct counts, null rates, min/max)
- Identify foreign key relationships
- Check for soft deletes (`deleted_at`, `is_active`, `status`)

### Discovery Report Template

```markdown
## Source: {source_name}.{table_name}

### Overview
- **Row count**: X
- **Grain**: One row per [entity] per [time period]
- **Primary key**: column_name (verified unique)

### Column Analysis
| Column | Type | Nulls | Notes |
| --- | --- | --- | --- |
| id | integer | 0% | Primary key |
| status | string | 2% | Values: active, inactive, pending |

### Data Quality Issues
- [ ] `status` has 15 rows with "unknown" - clarify with stakeholder
- [ ] `amount` has negative values - confirm if valid

### Relationships
- `user_id` -> `users.id` (5 orphan records)
- `product_id` -> `products.id` (clean join)

### Recommended Staging Transformations
1. Filter or map `status = 'unknown'`
2. Cast `created_at` to consistent timezone
```

### Pitfalls

- **Assuming column names reflect content**: `customer_id` might contain account IDs. Always verify.
- **Skipping documentation**: Discovery without documentation wastes effort.
- **Testing relationships on sampled data only**: Orphan records may exist outside your sample.
- **Ignoring soft deletes**: Check for `deleted_at`, `is_active`, `status` columns.
