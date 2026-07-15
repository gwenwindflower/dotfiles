# Data Tests

Add tests where the risk originates. Do not duplicate tests for pass-through columns.

> v2/Fusion generic test arguments must nest under `arguments:`. Examples use current syntax.

## Placement

### Staging

Structural integrity and source hygiene:

```yaml
models:
  - name: stg_stripe__payments
    columns:
      - name: payment_id
        data_tests:
          - unique
          - not_null
      - name: customer_id
        data_tests:
          - not_null
          - relationships:
              arguments:
                to: ref('stg_jaffle_shop__customers')
                field: customer_id
      - name: status
        data_tests:
          - accepted_values:
              arguments:
                values: ['pending', 'completed', 'cancelled']
```

### Intermediate

Test only when grain changes. If an internal CTE changes grain and needs tests, extract it as a model.

```yaml
models:
  - name: int_orders_enriched
    columns:
      - name: order_customer_key
        description: Composite key from the join.
        data_tests:
          - unique
          - not_null
```

### Marts

Test business expectations:

```yaml
models:
  - name: orders
    data_tests:
      - dbt_utils.expression_is_true:
          arguments:
            expression: "total_amount >= 0 or is_refund = true"
```

## Discovery to Tests

Use `dbt show` findings; do not guess.

| Discovery finding | Test |
| --- | --- |
| Verified unique, no nulls | `unique` + `not_null` |
| Foreign-key orphans matter | `relationships`; use `severity: warn` only with intent |
| Small known value set | `accepted_values` |
| Meaningful nullable field | Skip `not_null`; document null meaning |
| Date or amount bounded by business rule | `dbt_utils.accepted_range` |

## Cost Control

Scope expensive tests with `where`:

```yaml
- relationships:
    arguments:
      to: ref('dim_users')
      field: user_id
    config:
      where: "created_at >= current_date - interval '7 days'"
```

Non-obvious tests should include a first debug step:

```yaml
- dbt_utils.expression_is_true:
    arguments:
      expression: "total_amount >= 0 or is_refund = true"
    description: |
      Negative totals indicate calculation errors.
      Debug: query failed rows, then inspect line item discounts and refunds.
```

## Constraints

Constraints are table metadata and, on some adapters, warehouse-enforced checks. They complement data tests; they do not replace tests unless the adapter enforces the exact invariant.

Use constraints when a table or incremental model has a clear contract:

```yaml
models:
  - name: customers
    config:
      contract:
        enforced: true
    columns:
      - name: customer_id
        data_type: integer
        constraints:
          - type: not_null
          - type: primary_key
        data_tests:
          - unique
          - not_null
      - name: account_id
        data_type: integer
        data_tests:
          - relationships:
              arguments:
                to: ref('accounts')
                field: account_id
```

Rules:

- Constraints apply to `table` and `incremental` models, not `view` or `ephemeral`.
- Enforced contracts require `data_type` on every column.
- `not_null` is the most commonly enforced analytical-warehouse constraint.
- Primary key, foreign key, unique, and check constraints are often metadata-only; keep data tests for behavior dbt must verify.
- Foreign-key constraints need adapter-specific care; prefer `relationships` data tests unless the project already uses warehouse FK metadata.
- Add informational constraints when they improve catalog, lineage, ERD, or optimizer metadata and are cheap to maintain.
- Use `warn_unenforced: false` or `warn_unsupported: false` only when the metadata value is intentional.

## Avoid

- Guessing at `accepted_values`.
- Using data tests for SQL logic that needs unit tests.
- Stacking many `expression_is_true` tests on one model.
- Blanket `not_null` on nullable business fields.
- `unique` on non-key columns.
