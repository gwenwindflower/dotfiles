# Semantic Layer

Routing and overview for dbt Semantic Layer work: semantic models, entities, dimensions, and metrics.

## Components

- **Semantic models** -- metadata mapping dbt models to business concepts
- **Entities** -- keys defining grain and enabling joins
- **Dimensions** -- attributes for filtering/grouping (categorical or time-based)
- **Metrics** -- business calculations on top of semantic models

## Determine Which Spec

Two YAML specs exist:

| Spec | Supported By | Key Differences |
| --- | --- | --- |
| **Latest** | Core 1.12+, Fusion | `semantic_model:` nested under `models:`, simple metrics replace measures |
| **Legacy** | Core 1.6-1.11 (also 1.12+ backward compat) | Top-level `semantic_models:`, measures as building blocks, `type_params` |

### Detection

- Top-level `semantic_models:` key -> **legacy**
- `semantic_model:` nested under a model -> **latest**

### Routing

| Situation | Action |
| --- | --- |
| Legacy + Core 1.6-1.11 | Use [legacy spec](semantic-layer-legacy-spec.md) |
| Legacy + Core 1.12+/Fusion | Compatible. Offer upgrade via `uvx dbt-autofix deprecations --semantic-layer`. Continuing legacy is fine. |
| Latest + Core 1.12+/Fusion | Use [latest spec](semantic-layer-latest-spec.md) |
| Latest + Core <1.12 | Incompatible. Help upgrade to 1.12+. |
| No semantic layer + Core 1.12+/Fusion | Use [latest spec](semantic-layer-latest-spec.md) |
| No semantic layer + Core 1.6-1.11 | Ask about upgrading. If no, use [legacy spec](semantic-layer-legacy-spec.md) |

## Entry Points

**Business question first** -- User describes a metric need ("track CLV by segment"). Search project models/semantic models by name, description, columns. Present matches, confirm model(s), then work backwards: entities -> dimensions -> metrics.

**Model first** -- User specifies a model ("add semantic layer to `customers`"). Read model SQL and existing YAML. Identify grain (primary key/entity), suggest dimensions from column types, ask what metrics to define.

**Open-ended** -- User asks to "build the semantic layer". Identify high-importance models, suggest metrics and dimensions, ask for confirmation.

## Metric Types

Both specs support these types. For YAML syntax, see the spec-specific guides.

| Type | Purpose | Notes |
| --- | --- | --- |
| **Simple** | Aggregate a single column | Most common. Building block for all others. |
| **Derived** | Combine metrics with math | Profit (`revenue - cost`), growth rates (`offset_window`). |
| **Cumulative** | Running totals or windowed aggregations | Requires a [time spine](time-spine.md). Supports `window` (trailing) or `grain_to_date` (MTD/YTD) -- not both. |
| **Ratio** | Numerator / denominator | Both can have optional filters. |
| **Conversion** | Funnel analysis (event A -> event B) | Matches entities within a time window. `constant_properties` for dimension matching across events. |

## Filtering

Filters reference declared dimensions/entities, not raw columns:

```text
filter: |
  {{ Dimension('primary_entity__dimension_name') }} > 100

filter: |
  {{ TimeDimension('time_dimension', 'granularity') }} > '2026-01-01'

filter: |
  {{ Entity('entity_name') }} = 'value'

filter: |
  {{ Metric('metric_name', group_by=['entity_name']) }} > 100
```

## Validation

Two-stage validation after writing YAML:

1. **Parse**: `dbt parse` (or `dbtf parse`) -- confirms YAML syntax and references
2. **Semantic**: `dbt sl validate` (Cloud/Fusion) or `mf validate-configs` (MetricFlow CLI)

`mf validate-configs` reads from compiled manifest -- re-run `dbt parse` after YAML edits. Fusion with local MetricFlow shows `warning: dbt1005: Skipping semantic manifest validation` -- this is expected; use `mf validate-configs` directly.

Work is not complete until both validations pass.

## Development Workflow

```bash
dbt parse                                                    # Refresh manifest
dbt sl list dimensions --metrics <metric_name>               # List dimensions (Cloud/Fusion)
mf list dimensions --metrics <metric_name>                   # List dimensions (MetricFlow CLI)
dbt sl query --metrics <metric_name> --group-by <dimension>  # Test query
mf query --metrics <metric_name> --group-by <dimension>      # Test query (MetricFlow CLI)
```

## Best Practices

1. **Prefer normalization** -- let MetricFlow denormalize for end users
2. **Compute in metrics, not rollups** -- define calculations in metrics, not frozen aggregations
3. **Start simple** -- build simple metrics first, advance to ratio/derived later
4. **Entities**: one primary per semantic model, singular naming (`order` not `order_id`) with `expr`
5. **Dimensions**: always include primary time dimension when metrics exist
6. **Define components consistently**: entities -> dimensions -> metrics/measures

## Common Pitfalls

| Pitfall | Fix |
| --- | --- |
| Missing time dimension | Every semantic model with metrics needs a default time dimension |
| `window` + `grain_to_date` together | Cumulative metrics support only one |
| Mixing spec syntax | Don't use `type_params` in latest or direct keys in legacy |
| Filtering on non-dimension columns | Only declared dimensions/entities work in filters |
| `mf validate-configs` stale results | Re-run `dbt parse` first |
| `metricflow` without `dbt-metricflow` | Install `dbt-metricflow` for compatible dependencies |
| Pre-computing rollups in dbt models | Define calculations as metrics instead |
| Mixing specs in same project | Pick one and use consistently |
