# Data Tests

High-value tests that catch real issues without burning credits on low-signal checks. SKILL.md has the 4-tier priority summary; this expands on placement, discovery mapping, cost control.

> **v2/Fusion:** generic test arguments must nest under `arguments:` (see [cli-commands-reference.md](cli-commands-reference.md)). Examples below use the current syntax.

## Placement by layer

Test where risk originates — don't duplicate for pass-through columns.

### Staging — structural integrity, source hygiene

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

### Intermediate — only when grain changes

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

If a CTE inside a model changes grain, pull it out as its own model so it's independently testable.

### Marts — business expectations

```yaml
models:
  - name: orders
    data_tests:
      - dbt_utils.expression_is_true:
          arguments:
            expression: "total_amount >= 0 or is_refund = true"
```

## Mapping discovery to tests

Use `dbt show` findings, never guess.

| Discovery finding | Test |
| --- | --- |
| Verified unique, no nulls | `unique` + `not_null` |
| X% orphan records | `relationships` with `severity: warn` if >1% |
| Small known value set | `accepted_values` |
| Y% null rate | **Skip** `not_null` — nulls are expected |
| Creation date always in past | `dbt_utils.accepted_range` |

## Cost-conscious testing

Scope expensive tests with `where`:

```yaml
- relationships:
    arguments:
      to: ref('dim_users')
      field: user_id
    config:
      where: "created_at >= current_date - interval '7 days'"
```

Combine with `target.name` dev limits (SKILL.md) to keep iteration fast.

## Documenting debug paths

Non-obvious tests need a first step on failure:

```yaml
- dbt_utils.expression_is_true:
    arguments:
      expression: "total_amount >= 0 or is_refund = true"
    description: |
      Negative totals indicate calculation errors.
      Debug: 1. Query failed rows  2. Check line_items in staging  3. Verify discount logic
```

## Common mistakes

- **Over-testing business logic with data tests.** Data tests check data; unit tests check logic.
- **Guessing at `accepted_values`.** Always verify via `dbt show` during discovery.
- **Stacking `expression_is_true` on one model.** Pick the one critical invariant.
- **`not_null` on every column.** Low signal, high cost. Only when discovery confirms 0% nulls and regression would matter.
- **`unique` on non-PK columns.** Almost always wrong.
