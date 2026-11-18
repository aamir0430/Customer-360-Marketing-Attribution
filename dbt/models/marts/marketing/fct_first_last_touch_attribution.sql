{{ config(
    materialized = 'table'
) }}

WITH ranked_touchpoints AS (

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

        first_touch_rank,
        last_touch_rank,

        eligible_touchpoint_count

    FROM {{ ref('fct_conversion_journeys') }}

),

first_touch AS (

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

        'FIRST_TOUCH' AS attribution_model,

        1.0 AS attribution_credit,

        order_revenue_usd AS attributed_revenue

    FROM ranked_touchpoints

    WHERE first_touch_rank = 1

),

last_touch AS (

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

        'LAST_TOUCH' AS attribution_model,

        1.0 AS attribution_credit,

        order_revenue_usd AS attributed_revenue

    FROM ranked_touchpoints

    WHERE last_touch_rank = 1

)

SELECT *
FROM first_touch

UNION ALL

SELECT *
FROM last_touch