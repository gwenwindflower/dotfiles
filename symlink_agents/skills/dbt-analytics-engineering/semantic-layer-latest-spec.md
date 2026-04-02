# Latest Semantic Layer YAML Spec

For **dbt Core 1.12+** and **Fusion**. Semantic models are metadata annotations on dbt models.

## Implementation Workflow

### Step 1: Enable Semantic Model

```yaml
models:
  - name: orders
    semantic_model:
      enabled: true
    agg_time_dimension: ordered_at
```

Without a time column, the model cannot contain time-based metrics.

### Step 2: Define Entities

```yaml
    columns:
      - name: order_id
        entity:
          type: primary    # primary | foreign | unique | natural (SCD II)
          name: order
      - name: customer_id
        entity:
          type: foreign
          name: customer
```

A column can be an entity **or** a dimension, not both.

### Step 3: Define Dimensions

```yaml
      - name: ordered_at
        granularity: day           # Required at column level for time dims
        dimension:
          type: time
      - name: order_status
        dimension:
          type: categorical
```

`granularity:` goes at column level, **not** inside `dimension:`.

### Step 4: Define Simple Metrics

Aggregation types: `sum`, `min`, `max`, `average`, `median`, `count`, `count_distinct`, `percentile`, `sum_boolean`.

```yaml
    metrics:
      - name: order_count
        type: simple
        label: Order Count
        agg: count
        expr: 1
      - name: total_revenue
        type: simple
        label: Total Revenue
        agg: sum
        expr: amount
      - name: customers
        type: simple
        label: Count of customers
        agg: count
        expr: customers
        fill_nulls_with: 0
        join_to_timespine: true
        agg_time_dimension: my_other_time_column   # Override default
        filter: "{{ Dimension('customer__customer_total') }} >= 20"
      - name: revenue_p95
        type: simple
        label: Revenue P95
        agg: percentile
        expr: amount
        percentile: 95.0
        percentile_type: discrete   # discrete | continuous
```

## Derived Semantics

For dimensions/entities not mapped 1:1 to a physical column:

```yaml
    derived_semantics:
      dimensions:
        - name: order_size_bucket
          type: categorical
          expr: "case when amount > 100 then 'large' else 'small' end"
      entities:
        - name: user
          type: foreign
          expr: "substring(id_order from 2)"
```

## Advanced Metrics

Same-model advanced metrics go under the model's `metrics:`. Cross-model advanced metrics go under top-level `metrics:`.

### Derived

```yaml
    metrics:
      - name: order_gross_profit
        type: derived
        label: Order gross profit
        expr: revenue - cost
        input_metrics:
          - name: order_total
            alias: revenue
          - name: order_cost
            alias: cost
      # Offset window (period-over-period)
      - name: order_total_growth_mom
        type: derived
        expr: (order_total - prev) * 100 / prev
        input_metrics:
          - name: order_total
          - name: order_total
            alias: prev
            offset_window: 1 month
```

Filter on input metric:

```yaml
        input_metrics:
          - name: order_total
            alias: revenue
            filter: |
              {{ Dimension('order__is_food_order') }} = True
```

### Cumulative

Requires a [time spine](time-spine.md). Top-level `metrics:` key. `window` and `grain_to_date` cannot be used together.

```yaml
metrics:
  - name: cumulative_order_total
    type: cumulative
    input_metric: order_total
  - name: cumulative_order_total_l1m
    type: cumulative
    window: 1 month
    input_metric: order_total
  - name: cumulative_order_total_mtd
    type: cumulative
    grain_to_date: month
    input_metric: order_total
  - name: cumulative_revenue
    type: cumulative
    input_metric: revenue
    period_agg: first   # first | last | average
```

### Ratio

```yaml
metrics:
  - name: food_order_pct
    type: ratio
    numerator: food_orders
    denominator: orders
  - name: frequent_purchaser_ratio
    type: ratio
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
    entity: user
    calculation: conversion_rate   # conversion_rate (default) | conversions
    base_metric:
      name: visits
      filter: "{{ Dimension('visits__referrer_id') }} = 'facebook'"
    conversion_metric: buys
    window: 7 days
    constant_properties:           # Optional: same dimension across events
      - base_property: product
        conversion_property: product
```

### Cross-Model Metrics

Top-level `metrics:` key, for metrics spanning multiple semantic models:

```yaml
metrics:
  - name: orders_per_session
    type: ratio
    numerator: orders
    denominator: sessions
    config:
      group: example_group
      tags: [example_tag]
```

## SCD Type II

Use `validity_params` on time dimensions and `natural` entity type. SCD Type II semantic models cannot contain simple metrics.

```yaml
models:
  - name: sales_person_tiers
    semantic_model:
      enabled: true
    agg_time_dimension: tier_start
    primary_entity: sales_person
    columns:
      - name: start_date
        granularity: day
        dimension:
          type: time
          name: tier_start
          validity_params:
            is_start: true
      - name: end_date
        granularity: day
        dimension:
          type: time
          name: tier_end
          validity_params:
            is_end: true
      - name: sales_person_id
        entity:
          type: natural
          name: sales_person
```

## Rules and Pitfalls

| Rule | Detail |
| --- | --- |
| `semantic_model: enabled: true` | Required at model level |
| `agg_time_dimension` | At model level, not nested under `semantic_model:` |
| `granularity` | At column level, not inside `dimension:` block |
| Entity or dimension | One per column, not both |
| Model-level `metrics:` | Single-model simple and advanced metrics |
| Top-level `metrics:` | Cross-model advanced metrics only |
| `derived_semantics:` | For computed dimensions/entities |
| `window` + `grain_to_date` | Pick one, cannot combine |
| `input_metrics` on derived | Must list all metrics used in `expr` |
| `type_params` / `measures` | Legacy syntax, do not use |
