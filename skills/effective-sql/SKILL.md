---
name: effective-sql
description: Write maintainable SQL with CTE pipelines (import, transform, output). Use when writing non-trivial SQL meant to be committed, reviewed, or reused. Skip for one-off ad-hoc queries.
---

# Effective SQL

Write SQL as a readable pipeline: import the minimum data, transform it in named steps, and expose a clean final shape.

## CTE Pipeline

Use CTEs for non-trivial queries:

```sql
with
orders as (
    select
        id as order_id,
        customer_id,
        amount_cents,
        created_at
    from orders
    where customer_id is not null
),
customers as (
    select
        id as customer_id,
        name as customer_name
    from customers
),
orders_joined_to_customers as (
    select
        orders.order_id,
        orders.customer_id,
        customers.customer_name,
        orders.amount_cents,
        orders.created_at
    from orders
    inner join customers
        on orders.customer_id = customers.customer_id
),
final as (
    select
        order_id,
        customer_id,
        customer_name,
        amount_cents,
        created_at
    from orders_joined_to_customers
)
select * from final
```

Pipeline rules:

- **Import CTEs:** one source each; select only needed columns, rename vague fields immediately, push filters down early.
- **Transformation CTEs:** one logical step each; read only from imports or prior transformations, never from base tables.
- **Final CTE:** define the exposed schema; keep business logic above it.
- End with `select * from final` so debugging can swap `final` for an earlier CTE.

## Shape and Style

- Lowercase SQL, 4-space indentation, line-ending commas, explicit `as`.
- Use blank lines between major clauses, not decorative spacing.
- Prefer `inner join` / `left join`; avoid bare `join`, `right join`, and single-letter aliases.
- Use full table/CTE names unless a role alias clarifies self-joins (`employees as managers`).
- Use `union all` unless deduplication is required.
- Use positional `group by 1, 2` or `group by all` only when idiomatic for the warehouse and stable for the select list.
- Prefer the efficient warehouse-specific pattern, not merely valid SQL.

## Review Checks

- For each window function, check partition grain, deterministic ordering, and scan/shuffle cost. Pre-aggregate when it meaningfully reduces windowed data.
- Prefer `qualify` for window filters; if unsupported, filter in the next CTE rather than nesting.
- Prefer named CTEs over nested subqueries when they expose grain, filters, or reuse.
- Avoid correlated subqueries unless the warehouse plan proves they are faster and the intent stays clear.
- Use warehouse-native syntax when it reads better: `iff`/`if` for simple branches, `qualify` for window filters, `except`/`replace` for projection shaping, and null-safe comparison helpers where available.
- Avoid short aliases like `orders as o` or `customer_payments as cp`; keep the relation name, or use a semantic role alias for self-joins. In inherited SQL, rewrite when in scope; otherwise flag the style drift.
- Treat `distinct` as a last resort after checking whether grouping, join grain, window ranking, or a tighter CTE boundary removes duplicates at the source.
- Tighten `select *` in import and transformation CTEs once the final column list is known. The final `select * from final` is the debugging-friendly exception.
- Preserve pruning by filtering partition and timestamp columns with range predicates instead of wrapping them in functions; confirm the query plan once performance matters.
- Make casts and timezone choices explicit at the boundary where data enters the model.

## Select Lists

Order wide select lists consistently:

1. ids
2. text
3. numerics
4. booleans
5. dates
6. timestamps

Use comments only when a wide list needs scannable groups:

```sql
select
    -- ids
    order_id,
    customer_id,

    -- text
    order_status,

    -- numerics
    amount_cents,

    -- booleans
    is_refunded,

    -- dates
    order_date,

    -- timestamps
    created_at
```

## Naming

Names should be specific enough to survive downstream use without table context.

| Type | Pattern | Examples |
| --- | --- | --- |
| IDs | `<entity>_id`, `<entity>_uuid`, `<entity>_ulid` | `order_id`, `event_uuid` |
| Text | semantic noun | `customer_name`, `event_type`, `payment_method` |
| Numerics | unit or meaning suffix | `amount_cents`, `conversion_rate`, `confidence_score` |
| Booleans | `is_`, `was_`, `has_` | `is_active`, `has_payment_method` |
| Dates | `<event>_date` | `signup_date`, `cancellation_date` |
| Timestamps | `<event>_at` | `created_at`, `deleted_at` |

Rules:

- Tables are plural; row entities are singular.
- Never expose generic `id`, `name`, `type`, or `status` unless unambiguous everywhere downstream.
- Store dates and timestamps in UTC; localize only in downstream marts or BI layers.
- Read entity + column as a phrase: `order is_refunded` works, `order refund` does not.

## Defaults

- Start with CTEs and keep base-table access in import CTEs.
- Shrink data early; revisit imports as the query evolves.
- Name each transformation for its actual step (`orders_joined_to_customers`, `lifetime_value_calculated`).
- Prefer a few clear CTEs over one dense expression.
- Make the final dataset clean enough for downstream consumers.
