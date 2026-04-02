# Data Tests

High-value tests that catch real data issues without burning warehouse credits on low-signal checks.

The SKILL.md summarizes the 4-tier priority framework. This reference expands on placement, discovery mapping, cost control, and debugging.

## Test Placement by Layer

Don't duplicate tests for pass-through columns. Test where the risk originates.

### Staging

Structural integrity and source hygiene:

```yaml
models:
  - name: stg_orders
    columns:
      - name: order_id
        data_tests:
          - unique
          - not_null
      - name: customer_id
        data_tests:
          - not_null
          - relationships:
              arguments:
                to: ref('stg_customers')
                field: customer_id
      - name: status
        data_tests:
          - accepted_values:
              arguments:
                values: ['pending', 'completed', 'cancelled']
```

### Intermediate

Test only when grain changes or joins create new keys:

```yaml
models:
  - name: int_orders_enriched
    columns:
      - name: order_customer_key
        description: "Composite key created by join"
        data_tests:
          - unique
          - not_null
```

### Marts

Business expectations on end-user data:

```yaml
models:
  - name: fct_orders
    data_tests:
      - dbt_utils.expression_is_true:
          arguments:
            expression: "total_amount >= 0 OR is_refund = true"
```

## Mapping Discovery to Tests

Use `dbt show` findings to decide what to test. Don't guess.

| Discovery Finding | Test Action |
| --- | --- |
| Verified unique, no nulls | `unique` + `not_null` |
| X% orphan records | `relationships` with `severity: warn` if >1% |
| Small set of known values | `accepted_values` |
| Y% null rate | Do NOT add `not_null` -- nulls are expected |
| Creation date always in past | `dbt_utils.accepted_range` |

## Cost-Conscious Testing

For large tables, scope expensive tests with `where`:

```yaml
- relationships:
    arguments:
      to: ref('dim_users')
      field: user_id
    config:
      where: "created_at >= current_date - interval '7 days'"
```

Combine with conditional dev limits (`target.name`) from the SKILL.md to keep iteration fast.

## Documenting Debugging Steps

Non-obvious tests need a debug path. Include concrete first steps:

```yaml
data_tests:
  - dbt_utils.expression_is_true:
      arguments:
        expression: "total_amount >= 0 OR is_refund = true"
      description: |
        Negative totals indicate calculation errors.
        Debug: 1. Query failed rows  2. Check line_items in staging  3. Verify discount logic
```

## Common Mistakes

- **Over-testing business logic with data tests**: Data tests check data assumptions. Use unit tests for logic validation.
- **Guessing at `accepted_values`**: Always verify actual values via `dbt show` during discovery.
- **Stacking `expression_is_true` on one model**: Pick the one critical invariant. Multiple complex expressions are expensive and hard to maintain.
- **`not_null` on every column**: Low signal, high cost. Only add when discovery confirms 0% nulls and regression would matter.
- **`unique` on non-PK columns**: Almost always wrong. Reserve for actual keys.
