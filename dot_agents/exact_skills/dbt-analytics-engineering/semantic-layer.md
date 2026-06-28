# Semantic Layer

Route semantic-model work to the right YAML spec, then build from business question -> model grain -> entities/dimensions -> metrics.

## Concepts

| Component | Purpose |
| --- | --- |
| Semantic model | Maps a dbt model to a business concept |
| Entity | Key that defines grain and enables joins |
| Dimension | Attribute used for filters or group-bys |
| Metric | Business calculation on top of semantic models |

## Pick One Spec

| Spec | Supported by | Shape |
| --- | --- | --- |
| Current | v2, Fusion, Core 1.12+ | `semantic_model:` nested under `models:` |
| Legacy | Core 1.11 | Top-level `semantic_models:` with measures and `type_params` |

Detection:

- Top-level `semantic_models:` -> [Legacy Semantic Spec](semantic-layer-legacy-spec.md)
- `semantic_model:` under a model -> [Current Semantic Spec](semantic-layer-latest-spec.md)

Routing:

| Situation | Action |
| --- | --- |
| Legacy syntax on 1.11 | Use legacy; offer `uvx dbt-autofix deprecations --semantic-layer` |
| Legacy syntax on 1.12+/v2/Fusion | Compatible, but new work should migrate to current |
| Current syntax on 1.12+/v2/Fusion | Use current |
| Current syntax on 1.11 | Upgrade dbt first |
| No semantic layer | Use current |

Do not mix specs in one project.

## Defaults

- One semantic model per mart.
- One primary entity per semantic model; use singular names (`order`) and `expr:` for `_id` columns.
- Every metrics-bearing semantic model needs a primary time dimension and `agg_time_dimension`.
- Keep marts narrower for semantic-layer projects; MetricFlow joins at query time.
- Define simple metrics first, then ratio, derived, cumulative, or conversion metrics.
- Compute in metrics, not pre-aggregated rollups.
- Order components entities -> dimensions -> metrics.

## Entry Points

| User starts with | Agent flow |
| --- | --- |
| Business question | Search models by name/description/columns, confirm model, then define entities, dimensions, metrics |
| Specific model | Read SQL/YAML, identify grain, suggest dimensions, ask what to measure |
| "Build the semantic layer" | Identify important marts, propose metrics/dimensions, confirm |

## Metric Types

| Type | Purpose | Note |
| --- | --- | --- |
| Simple | Aggregate a single expression | Building block for other metrics |
| Ratio | Numerator / denominator | Inputs can have filters |
| Derived | Metric math | Supports aliases and offsets |
| Cumulative | Running totals or windows | Requires [Time Spine](time-spine.md); `window` xor `grain_to_date` |
| Conversion | Funnel A -> B | Matches entities within a time window |

## Filters

Filters reference declared dimensions, entities, or metrics, not raw columns:

```text
{{ Dimension('primary_entity__dimension_name') }} > 100
{{ TimeDimension('time_dimension', 'granularity') }} > '2026-01-01'
{{ Entity('entity_name') }} = 'value'
{{ Metric('metric_name', group_by=['entity_name']) }} > 100
```

## Validate

```bash
dbt parse
dbt sl validate
dbt sl query --metrics <metric_name> --group-by <dimension>
```

`dbt sl` is the unified CLI for both engines. Re-run `dbt parse` after YAML edits because `dbt sl validate` reads the compiled manifest.

## Pitfalls

| Pitfall | Fix |
| --- | --- |
| Missing time dimension | Add one before defining time-based metrics |
| `window` + `grain_to_date` together | Pick one |
| Filtering on raw columns | Declare a dimension/entity first |
| Stale semantic validation | Re-run `dbt parse` |
| Precomputed rollups | Define metrics instead |
| Wide marts feeding MetricFlow | Normalize marts |
