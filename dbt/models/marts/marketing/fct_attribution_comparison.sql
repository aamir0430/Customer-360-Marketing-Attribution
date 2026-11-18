{{ config(
    materialized = 'table'
) }}

WITH first_last_touch AS (

    SELECT

        transaction_id,
        journey_id,

        customer_id,
        user_pseudo_id,

        order_date,
        conversion_timestamp,

        order_revenue_usd,
        currency,

        touchpoint_session_key,
        touchpoint_timestamp,

        touchpoint_source,
        touchpoint_medium,
        touchpoint_campaign,

        touchpoint_source_status,

        eligible_touchpoint_count,

        attribution_model,
        attribution_credit,
        attributed_revenue

    FROM {{ ref('fct_first_last_touch_attribution') }}

),

linear AS (

    SELECT

        transaction_id,
        journey_id,

        customer_id,
        user_pseudo_id,

        order_date,
        conversion_timestamp,

        order_revenue_usd,
        currency,

        touchpoint_session_key,
        touchpoint_timestamp,

        touchpoint_source,
        touchpoint_medium,
        touchpoint_campaign,

        touchpoint_source_status,

        eligible_touchpoint_count,

        attribution_model,
        attribution_credit,
        attributed_revenue

    FROM {{ ref('fct_linear_attribution') }}

),

time_decay AS (

    SELECT

        transaction_id,
        journey_id,

        customer_id,
        user_pseudo_id,

        order_date,
        conversion_timestamp,

        order_revenue_usd,
        currency,

        touchpoint_session_key,
        touchpoint_timestamp,

        touchpoint_source,
        touchpoint_medium,
        touchpoint_campaign,

        touchpoint_source_status,

        eligible_touchpoint_count,

        attribution_model,
        attribution_credit,
        attributed_revenue

    FROM {{ ref('fct_time_decay_attribution') }}

),

combined_attribution AS (

    SELECT * FROM first_last_touch

    UNION ALL

    SELECT * FROM linear

    UNION ALL

    SELECT * FROM time_decay

)

SELECT

    transaction_id,
    journey_id,

    customer_id,
    user_pseudo_id,

    order_date,
    conversion_timestamp,

    order_revenue_usd,
    currency,

    touchpoint_session_key,
    touchpoint_timestamp,

    touchpoint_source,
    touchpoint_medium,
    touchpoint_campaign,

    touchpoint_source_status,

    eligible_touchpoint_count,

    attribution_model,
    attribution_credit,
    attributed_revenue

FROM combined_attribution