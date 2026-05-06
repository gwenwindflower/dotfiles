# Analytical Patterns

Recipes for the most common event-sequencing questions. All patterns are written in portable SQL (window functions + CTEs); `match_recognize` versions are noted where dramatically simpler.

SQL style follows [effective-sql](../effective-sql/SKILL.md): lowercase, CTE pipelines, explicit `as` aliases, type/unit suffixes on column names.

## Funnels

A funnel asks: of users who did A, how many went on to do B, then C, within some time window? Three valid approaches; pick by tradeoff.

### 1. Boolean-flag aggregation (simplest, no time constraint)

```sql
with

events_in_scope as (

    select
        user_id,
        event_name

    from events
    where event_name in ('signup', 'activate', 'purchase')

),

user_funnel_flags as (

    select
        user_id,
        bool_or(event_name = 'signup')   as did_signup,
        bool_or(event_name = 'activate') as did_activate,
        bool_or(event_name = 'purchase') as did_purchase

    from events_in_scope
    group by all

),

funnel_counts as (

    select
        count(*) filter (
            where did_signup
        ) as step_1_signed_up_user_count,

        count(*) filter (
            where did_signup and did_activate
        ) as step_2_activated_user_count,

        count(*) filter (
            where did_signup and did_activate and did_purchase
        ) as step_3_purchased_user_count

    from user_funnel_flags

),

final as (

    select
        step_1_signed_up_user_count,
        step_2_activated_user_count,
        step_3_purchased_user_count

    from funnel_counts

)

select * from final
```

Loses ordering and time constraints. Fine for "ever-did" funnels.

### 2. Self-join with first-occurrence per step (ordered, with time window)

```sql
with

funnel_events as (

    select
        user_id,
        event_name,
        event_at

    from events
    where event_name in ('signup', 'activate', 'purchase')

),

first_event_per_step as (

    select
        user_id,
        event_name,
        min(event_at) as first_event_at

    from funnel_events
    group by all

),

signups as (

    select
        user_id,
        first_event_at as signed_up_at

    from first_event_per_step
    where event_name = 'signup'

),

activations as (

    select
        user_id,
        first_event_at as activated_at

    from first_event_per_step
    where event_name = 'activate'

),

purchases as (

    select
        user_id,
        first_event_at as purchased_at

    from first_event_per_step
    where event_name = 'purchase'

),

ordered_funnel as (

    select
        signups.user_id,
        signups.signed_up_at,
        activations.activated_at,
        purchases.purchased_at

    from signups
    left join activations
        on activations.user_id = signups.user_id
        and activations.activated_at >  signups.signed_up_at
        and activations.activated_at <= signups.signed_up_at + interval '7 days'
    left join purchases
        on purchases.user_id = signups.user_id
        and purchases.purchased_at >  activations.activated_at
        and purchases.purchased_at <= signups.signed_up_at + interval '30 days'

),

final as (

    select
        count(*)                  as signed_up_user_count,
        count(activated_at)       as activated_user_count,
        count(purchased_at)       as purchased_user_count,

        avg(
            extract(epoch from purchased_at - signed_up_at) / 86400
        ) as avg_days_to_purchase

    from ordered_funnel

)

select * from final
```

### 3. MATCH_RECOGNIZE (when supported — usually the cleanest)

See [match-recognize](match-recognize.md). One block expresses ordering, time bounds, intermediate event allowance, and measures.

### Drop-off attribution

To answer "where did users drop off", compute the last completed step per user:

```sql
with

user_funnel_flags as (
    /* same as the boolean-flag CTE above */
    select
        user_id,
        did_signup,
        did_activate,
        did_purchase

    from {{ ref('user_funnel_flags') }}

),

drop_off_status as (

    select
        case
            when did_purchase then 'completed'
            when did_activate then 'dropped_after_activate'
            when did_signup   then 'dropped_after_signup'
        end as funnel_status,
        count(*) as user_count

    from user_funnel_flags
    group by all

),

final as (

    select
        funnel_status,
        user_count

    from drop_off_status

)

select * from final
```

## Clickstream paths

### Next-event distribution

"What do users do after viewing the pricing page?"

```sql
with

events_in_scope as (

    select
        user_id,
        event_name,
        event_at

    from events

),

with_next_event as (

    select
        user_id,
        event_name,
        event_at,

        lead(event_name) over (
            partition by user_id
            order by event_at
        ) as next_event_name

    from events_in_scope

),

pricing_page_exits as (

    select
        next_event_name,
        count(*) as transition_count

    from with_next_event
    where event_name = 'view_pricing'
    group by all

),

final as (

    select
        next_event_name,
        transition_count

    from pricing_page_exits
    order by transition_count desc

)

select * from final
```

### Top N paths (Sankey-ready)

Sessionize first (see [window-functions](window-functions.md#gaps-and-islands)), then concatenate event names per session.

```sql
with

sessionized as (
    /* produces user_id, session_id, event_name, event_at */
    select
        user_id,
        session_id,
        event_name,
        event_at

    from {{ ref('sessionized_events') }}

),

session_paths as (

    select
        user_id,
        session_id,

        listagg(event_name, ' → ') within group (order by event_at) as path
        -- BigQuery / Postgres: string_agg(event_name, ' → ' order by event_at)

    from sessionized
    group by all

),

path_counts as (

    select
        path,
        count(*) as session_count

    from session_paths
    group by all

),

final as (

    select
        path,
        session_count

    from path_counts
    order by session_count desc
    limit 20

)

select * from final
```

For Sankey input, emit edge pairs instead:

```sql
with

sessionized as (

    select
        user_id,
        session_id,
        event_name,
        event_at

    from {{ ref('sessionized_events') }}

),

edges as (

    select
        event_name as from_event_name,

        lead(event_name) over (
            partition by user_id, session_id
            order by event_at
        ) as to_event_name

    from sessionized

),

final as (

    select
        from_event_name,
        to_event_name,
        count(*) as transition_count

    from edges
    group by all

)

select * from final
```

### Time-to-next-event

```sql
with

events_in_scope as (

    select
        user_id,
        event_name,
        event_at

    from events

),

with_dwell as (

    select
        user_id,
        event_name,
        event_at,

        lead(event_at) over (
            partition by user_id
            order by event_at
        ) - event_at as dwell_duration

    from events_in_scope

),

final as (

    select
        ---------- ids
        user_id,

        ---------- text
        event_name,

        ---------- timestamps
        event_at,

        ---------- intervals
        dwell_duration

    from with_dwell

)

select * from final
```

Useful for engagement metrics, page-view-time analysis, attribution windows.

## Retention and cohorts

### Cohort retention matrix

```sql
with

events_in_scope as (

    select
        user_id,
        event_at

    from events

),

cohorts as (

    select
        user_id,
        date_trunc('week', min(event_at)) as cohort_week_date

    from events_in_scope
    group by all

),

weekly_activity as (

    select distinct
        user_id,
        date_trunc('week', event_at) as active_week_date

    from events_in_scope

),

cohort_activity as (

    select
        cohorts.cohort_week_date,
        date_diff(
            'week', cohorts.cohort_week_date, weekly_activity.active_week_date
        ) as week_offset,

        count(distinct weekly_activity.user_id) as active_user_count

    from cohorts
    join weekly_activity
        using (user_id)
    group by all

),

final as (

    select
        ---------- numerics
        week_offset,
        active_user_count,

        ---------- dates
        cohort_week_date

    from cohort_activity
    order by cohort_week_date, week_offset

)

select * from final
```

Pivot `week_offset` to columns for the classic triangle view. Divide each cell by `week 0` for retention rates.

### Churn (no-event window)

"Users active in week N but absent for the next K weeks":

```sql
with

events_in_scope as (

    select
        user_id,
        event_at

    from events

),

weekly_activity as (

    select
        user_id,
        date_trunc('week', event_at) as active_week_date

    from events_in_scope
    group by all

),

with_next_active_week as (

    select
        user_id,
        active_week_date,

        lead(active_week_date) over (
            partition by user_id
            order by active_week_date
        ) as next_active_week_date

    from weekly_activity

),

final as (

    select
        user_id,
        active_week_date as churned_after_week_date

    from with_next_active_week
    where next_active_week_date is null
       or next_active_week_date > active_week_date + interval '4 weeks'

)

select * from final
```

## Time-series

### Detect spikes (z-score over rolling window)

```sql
with

daily_metrics_in_scope as (

    select
        metric_date,
        metric_value

    from daily_metrics

),

rolling_baseline as (

    select
        metric_date,
        metric_value,

        avg(metric_value) over rolling_28d    as baseline_mean,
        stddev(metric_value) over rolling_28d as baseline_stddev

    from daily_metrics_in_scope
    window rolling_28d as (
        order by metric_date
        rows between 27 preceding and 1 preceding
    )

),

with_zscore as (

    select
        metric_date,
        metric_value,
        (metric_value - baseline_mean) / nullif(baseline_stddev, 0) as zscore

    from rolling_baseline

),

final as (

    select
        metric_date,
        metric_value,
        zscore

    from with_zscore
    qualify zscore > 3

)

select * from final
```

The frame ends at `1 preceding` so the current row isn't part of its own baseline.

### Change-point detection (consecutive direction)

Find runs of `N` consecutive increases/decreases via gaps-and-islands on the sign of the diff. See [window-functions](window-functions.md#consecutive-runs-status-streaks-login-streaks).

### Time-bucketed gauges (state at time T)

When events represent state transitions and you want "active state per hour":

```sql
with

hour_buckets as (

    select hour_at
    from unnest(generate_timestamp_array(...)) as hour_at  -- dialect-specific

),

state_changes_in_scope as (

    select
        entity_id,
        status,
        changed_at

    from state_changes

),

state_intervals as (

    select
        entity_id,
        status,
        changed_at as valid_from_at,

        lead(changed_at, 1, timestamp '9999-01-01') over (
            partition by entity_id
            order by changed_at
        ) as valid_until_at

    from state_changes_in_scope

),

final as (

    select
        ---------- ids
        state_intervals.entity_id,

        ---------- text
        state_intervals.status,

        ---------- timestamps
        hour_buckets.hour_at

    from hour_buckets
    join state_intervals
        on hour_buckets.hour_at >= state_intervals.valid_from_at
        and hour_buckets.hour_at <  state_intervals.valid_until_at

)

select * from final
```

`match_recognize` with `all rows per match` and `CLASSIFIER()` produces the same labeling much more cleanly when supported.

### Anomalies via deviation from same-day-last-week

```sql
with

daily_metrics_in_scope as (

    select
        metric_date,
        metric_value

    from daily_metrics

),

with_prior_week as (

    select
        metric_date,
        metric_value,

        lag(metric_value, 7) over (order by metric_date) as prior_week_value

    from daily_metrics_in_scope

),

final as (

    select
        ---------- numerics
        metric_value,
        prior_week_value,
        metric_value - prior_week_value as wow_delta,

        (metric_value - prior_week_value)
            / nullif(prior_week_value, 0) as wow_change_rate,

        ---------- dates
        metric_date

    from with_prior_week

)

select * from final
```

Robust to weekly seasonality without needing a model.
