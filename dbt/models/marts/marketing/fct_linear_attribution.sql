{{ config(
    materialized = 'table'
) }}

WITH conversion_touchpoints AS (

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

        eligible_touchpoint_count

    FROM {{ ref('fct_conversion_journeys') }}

),

linear_attribution AS (

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

        'LINEAR' AS attribution_model,

        SAFE_DIVIDE(
            1.0,
            eligible_touchpoint_count
        ) AS attribution_credit,

        order_revenue_usd * SAFE_DIVIDE(
            1.0,
            eligible_touchpoint_count
        ) AS attributed_revenue

    FROM conversion_touchpoints

    WHERE
        eligible_touchpoint_count > 0

)

SELECT *
FROM linear_attribution