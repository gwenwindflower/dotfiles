# Legacy Semantic Layer YAML Spec

For **dbt Core 1.6-1.11**. Supported by Core 1.12+ for backward compatibility, but [latest spec](semantic-layer-latest-spec.md) is recommended for new projects.

## Implementation Workflow

### Step 1: Define Semantic Model

```yaml
semantic_models:
  - name: orders
    model: ref('orders')          # Required, no curly braces
    defaults:
      agg_time_dimension: ordered_at
```

### Step 2: Define Entities

```yaml
    entities:
      - name: order
        type: primary              # primary | foreign | unique | natural (SCD II)
        expr: order_id             # Column name (defaults to name if omitted)
      - name: customer
        type: foreign
        expr: customer_id
```

If no physical primary key, use `primary_entity: entity_name` at the semantic model level.

### Step 3: Define Dimensions

```yaml
    dimensions:
      - name: ordered_at
        type: time
        type_params:
          time_granularity: day    # Must nest under type_params
      - name: order_status
        type: categorical
```

Computed dimensions use `expr`.

### Step 4: Define Measures and Metrics

Aggregation types: `sum`, `min`, `max`, `average`, `sum_boolean`, `count_distinct`, `median`, `percentile`.

```yaml
    measures:
      - name: order_count
        agg: sum
        expr: 1
      - name: total_revenue
        agg: sum
        expr: amount

metrics:
  - name: total_revenue
    type: simple
    label: Total Revenue
    type_params:
      measure: total_revenue
```

### Measure Properties

| Property | Required | Description |
| --- | --- | --- |
| `name` | Yes | Unique across all semantic models |
| `agg` | Yes | Aggregation type |
| `expr` | No | Column or SQL expression (defaults to name) |
| `create_metric` | No | Auto-generate simple metric (`true`/`false`) |
| `agg_time_dimension` | No | Override default time dimension |
| `agg_params` | No | Extra params (e.g., percentile) |
| `non_additive_dimension` | No | For measures that shouldn't sum across time |

### Percentile and Non-Additive Measures

```yaml
    measures:
      # Percentile
      - name: p99_transaction_value
        expr: transaction_amount_usd
        agg: percentile
        agg_params:
          percentile: .99
          use_discrete_percentile: false
      # Non-additive (account balances, MRR)
      - name: mrr
        expr: subscription_value
        agg: sum
        non_additive_dimension:
          name: subscription_date
          window_choice: max     # max (period end) | min (period start)
          window_groupings:      # Optional
            - user_id
```

## Metrics

All metrics use top-level `metrics:` key, referencing measures via `type_params`.

### Simple

```yaml
metrics:
  - name: customers
    type: simple
    label: Count of customers
    type_params:
      measure:
        name: customers
        fill_nulls_with: 0
        join_to_timespine: true
        filter: "{{ Dimension('customer__customer_total') }} >= 20"
```

Shorthand: `type_params: { measure: total_revenue }`.

### Derived

```yaml
metrics:
  - name: order_gross_profit
    type: derived
    label: Order gross profit
    type_params:
      expr: revenue - cost
      metrics:
        - name: order_total
          alias: revenue
        - name: order_cost
          alias: cost
```

Offset window and filter on input metrics:

```yaml
      metrics:
        - name: order_total
        - name: order_total
          offset_window: 1 month
          alias: order_total_prev_month
        - name: order_total
          alias: revenue
          filter: |
            {{ Dimension('order__is_food_order') }} = True
```

### Cumulative

Requires a [time spine](time-spine.md). `window` and `grain_to_date` cannot be used together.

```yaml
metrics:
  - name: cumulative_l1m
    type: cumulative
    type_params:
      measure: { name: order_total }
      cumulative_type_params:
        window: 1 month            # Omit for all-time cumulative
  - name: cumulative_mtd
    type: cumulative
    type_params:
      measure: { name: order_total }
      cumulative_type_params:
        grain_to_date: month
  - name: cumulative_revenue
    type: cumulative
    type_params:
      measure: revenue
      cumulative_type_params:
        period_agg: first          # first | last | average
```

### Ratio

```yaml
metrics:
  - name: food_order_pct
    type: ratio
    type_params:
      numerator: food_orders       # Shorthand
      denominator: orders
  - name: frequent_purchaser_pct
    type: ratio
    type_params:
      numerator:
        name: distinct_purchasers
        filter: |
          {{ Dimension('customer__is_frequent_purchaser') }}
        alias: frequent_purchasers
      denominator:
        name: distinct_purchasers
```

### Conversion

```yaml
metrics:
  - name: visit_to_buy_7d
    type: conversion
    label: Visit to buy (7-day)
    type_params:
      conversion_type_params:
        base_measure:
          name: visits
          filter: "{{ Dimension('visits__referrer_id') }} = 'facebook'"
        conversion_measure:
          name: buys
        entity: user
        window: 7 days
        constant_properties:
          - base_property: product
            conversion_property: product
```

## SCD Type II

Cannot contain measures. Entity type must be `natural`.

```yaml
semantic_models:
  - name: sales_person_tiers
    model: ref('sales_person_tiers')
    defaults:
      agg_time_dimension: tier_start
    primary_entity: sales_person
    dimensions:
      - name: tier_start
        type: time
        expr: start_date
        type_params:
          time_granularity: day
          validity_params:
            is_start: True
      - name: tier_end
        type: time
        expr: end_date
        type_params:
          time_granularity: day
          validity_params:
            is_end: True
    entities:
      - name: sales_person
        type: natural
        expr: sales_person_id
```

## Key Rules

- Top-level `semantic_models:` key (not nested under `models:`)
- `model: ref('...')` required, no curly braces
- `defaults.agg_time_dimension` required for any semantic model with measures
- All metrics at top-level `metrics:` referencing measures via `type_params`
- `expr` for column aliasing or computed values

## Common Pitfalls

| Pitfall | Fix |
| --- | --- |
| `time_granularity` outside `type_params` | Must nest under `type_params` |
| Missing `model: ref('...')` | Required for every semantic model |
| Metrics without `type_params` | All metrics must reference measures through `type_params` |
| `window` + `grain_to_date` together | Pick one |
| Missing `type_params.metrics` on derived | Must list metrics used in `expr` |
| Using `semantic_model:` on models or `agg` on metrics | Those are latest spec syntax |
