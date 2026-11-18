{{ config(
    materialized = 'table'
) }}

WITH touchpoints AS (

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

        seconds_before_conversion,

        days_before_conversion

    FROM {{ ref('fct_conversion_journeys') }}

),

decay_weights AS (

    SELECT

        *,

        7 AS decay_half_life_days,

        POW(
            0.5,
            SAFE_DIVIDE(
                seconds_before_conversion,
                7 * 24 * 60 * 60
            )
        ) AS initial_decay_weight

    FROM touchpoints

    WHERE
        seconds_before_conversion >= 0

),

normalized_weights AS (

    SELECT

        *,

        SUM(initial_decay_weight) OVER (

            PARTITION BY transaction_id

        ) AS total_decay_weight

    FROM decay_weights

),

time_decay_attribution AS (

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

        seconds_before_conversion,
        days_before_conversion,

        decay_half_life_days,

        initial_decay_weight,
        total_decay_weight,

        'TIME_DECAY' AS attribution_model,

        SAFE_DIVIDE(
            initial_decay_weight,
            total_decay_weight
        ) AS attribution_credit,

        order_revenue_usd * SAFE_DIVIDE(
            initial_decay_weight,
            total_decay_weight
        ) AS attributed_revenue

    FROM normalized_weights

)

SELECT *
FROM time_decay_attribution