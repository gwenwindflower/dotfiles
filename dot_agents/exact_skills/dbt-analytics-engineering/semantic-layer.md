# Semantic Layer

Routing + concepts for semantic models, entities, dimensions, metrics. Pick a spec, use the matching reference.

## Components

- **Semantic model** — metadata mapping a dbt model to a business concept.
- **Entities** — keys defining grain and enabling joins.
- **Dimensions** — attributes for filter/group (`categorical` or `time`).
- **Metrics** — business calculations on top of semantic models.

## Two specs

| Spec | Supported by | Shape |
| --- | --- | --- |
| **Current** | v2, Fusion, Core 1.12+ | `semantic_model:` nested under `models:`; simple metrics replace measures |
| **Legacy** | Core 1.11 (last Python release) | Top-level `semantic_models:`; measures as building blocks; `type_params` wrappers |

Detect spec by shape:

- Top-level `semantic_models:` key → **legacy** ([semantic-layer-legacy-spec.md](semantic-layer-legacy-spec.md))
- `semantic_model:` nested under a model → **current** ([semantic-layer-latest-spec.md](semantic-layer-latest-spec.md))

### Routing

| Situation | Action |
| --- | --- |
| Legacy syntax on 1.11 | Use legacy spec. Offer upgrade to current via `uvx dbt-autofix deprecations --semantic-layer`. |
| Legacy syntax on v2/Fusion/1.12+ | Compatible for backward compat, but new work goes in current spec. Recommend migration. |
| Current syntax on 1.12+ / v2 / Fusion | Use current spec. |
| Current syntax on 1.11 | Incompatible — help upgrade to 1.12+ first. |
| No semantic layer yet | Use current spec. |

Mixing specs in one project is forbidden — pick one.

## Best practices baked in

- **One semantic model per mart.** Keep marts narrower (normalized) when adopting the Semantic Layer — MetricFlow joins, so wide marts duplicate work.
- **One primary entity per semantic model.** Singular naming (`order` not `order_id`) with `expr:` pointing at the actual `_id` column.
- **At least one primary time dimension** when metrics exist; declare the default via `agg_time_dimension`.
- **Define small reusable measures**, not aggregations baked into a single metric — required for ratio/derived flexibility.
- **Components in order:** entities → dimensions → metrics. Reads like a build script and matches the spec layout.
- **Prefer normalization**; let MetricFlow denormalize at query time for end users.
- **Compute in metrics, not rollups.** No frozen pre-aggregations.
- **Build simple metrics first**, then advance to ratio / derived / cumulative / conversion.

## Entry points

- **Business question first.** User describes a need ("track CLV by segment"). Search models by name, description, columns. Confirm model, then entities → dimensions → metrics.
- **Model first.** User specifies a model. Read SQL + YAML, identify grain, suggest dimensions from column types, ask what to measure.
- **Open-ended.** User asks to "build the semantic layer". Identify high-importance marts, propose metrics + dimensions, confirm.

## Metric types (both specs)

| Type | Purpose | Notes |
| --- | --- | --- |
| **Simple** | Aggregate a single column | Most common. Building block for everything else. |
| **Ratio** | Numerator / denominator | Both can have filters. |
| **Derived** | Combine metrics with math | Profit (`revenue - cost`), growth (`offset_window`). |
| **Cumulative** | Running totals / windowed aggs | Requires a [time spine](time-spine.md). `window` (trailing) **OR** `grain_to_date` (MTD/YTD) — not both. |
| **Conversion** | Funnel A → B | Matches entities within a time window. `constant_properties` for cross-event dimension matching. |

## Filtering

Filters reference declared dimensions/entities, never raw columns:

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

Two stages — both must pass:

1. **`dbt parse`** — confirms YAML syntax and refs.
2. **`dbt sl validate`** — semantic manifest validity.

`dbt sl` is the unified CLI for both engines (replaces standalone `mf` from older setups). Re-run `dbt parse` after YAML edits before `dbt sl validate` — it reads the compiled manifest.

## Development workflow

```bash
dbt parse                                                       # Refresh manifest
dbt sl list dimensions --metrics <metric_name>                  # Inspect
dbt sl query --metrics <metric_name> --group-by <dimension>     # Test query
dbt sl validate                                                 # Final check
```

## Common pitfalls

| Pitfall | Fix |
| --- | --- |
| Missing time dimension | Every semantic model with metrics needs one |
| `window` + `grain_to_date` together | Cumulative metrics support only one |
| Mixing spec syntax | Don't put `type_params` in current spec or direct keys in legacy |
| Filtering on a raw column | Only declared dimensions / entities work |
| Stale `dbt sl validate` | Re-run `dbt parse` first |
| Pre-computing rollups | Define as metrics |
| Mixing specs in one project | Pick one |
| Wide marts feeding semantic layer | Normalize marts when adopting the Semantic Layer |
