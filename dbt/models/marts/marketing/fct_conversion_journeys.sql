{{ config(
    materialized = 'table'
) }}

WITH touchpoints AS (

    SELECT

        mt.session_key,
        mt.journey_id,
        mt.identity_type,

        mt.customer_id,
        mt.user_pseudo_id,

        mt.session_date,

        SAFE_CAST(
            s.session_first_event_timestamp_utc AS TIMESTAMP
        ) AS touchpoint_timestamp,

        mt.touchpoint_source,
        mt.touchpoint_medium,
        mt.touchpoint_campaign,

        mt.touchpoint_source_status,

        mt.first_user_source,
        mt.first_user_medium,
        mt.first_user_campaign,

        mt.has_purchase

    FROM {{ ref('fct_marketing_touchpoints') }} mt

    INNER JOIN {{ ref('fct_sessions') }} s

        ON mt.session_key = s.session_key

),

conversions AS (

    SELECT

        transaction_id,

        customer_id,
        user_pseudo_id,

        session_key,

        order_date,

        event_timestamp_utc AS conversion_timestamp,

        order_revenue_usd,

        currency,

        purchase_event_count,

        CASE

            WHEN customer_id IS NOT NULL

                THEN CONCAT(
                    'CRM:',
                    CAST(customer_id AS STRING)
                )

            WHEN user_pseudo_id IS NOT NULL

                THEN CONCAT(
                    'GA4:',
                    user_pseudo_id
                )

            ELSE NULL

        END AS journey_id

    FROM {{ ref('fct_orders') }}

    WHERE transaction_id IS NOT NULL

),

conversion_touchpoints AS (

    SELECT

        -- Conversion information
        c.transaction_id,
        c.journey_id,

        c.customer_id,
        c.user_pseudo_id,

        c.session_key AS conversion_session_key,

        c.order_date,
        c.conversion_timestamp,

        c.order_revenue_usd,
        c.currency,

        c.purchase_event_count,

        -- Touchpoint information
        t.session_key AS touchpoint_session_key,

        t.session_date AS touchpoint_date,

        t.touchpoint_timestamp,

        t.touchpoint_source,
        t.touchpoint_medium,
        t.touchpoint_campaign,

        t.touchpoint_source_status,

        t.first_user_source,
        t.first_user_medium,
        t.first_user_campaign,

        t.identity_type,

        -- Journey timing
        TIMESTAMP_DIFF(
            c.conversion_timestamp,
            t.touchpoint_timestamp,
            SECOND
        ) AS seconds_before_conversion,

        TIMESTAMP_DIFF(
            c.conversion_timestamp,
            t.touchpoint_timestamp,
            DAY
        ) AS days_before_conversion

    FROM conversions c

    INNER JOIN touchpoints t

        ON c.journey_id = t.journey_id

    WHERE

        c.journey_id IS NOT NULL

        AND c.conversion_timestamp IS NOT NULL

        AND t.touchpoint_timestamp IS NOT NULL

        AND t.touchpoint_timestamp <= c.conversion_timestamp

        AND t.touchpoint_timestamp >= TIMESTAMP_SUB(
            c.conversion_timestamp,
            INTERVAL 30 DAY
        )

),

ranked_touchpoints AS (

    SELECT

        *,

        ROW_NUMBER() OVER (

            PARTITION BY transaction_id

            ORDER BY
                touchpoint_timestamp ASC,
                touchpoint_session_key ASC

        ) AS first_touch_rank,

        ROW_NUMBER() OVER (

            PARTITION BY transaction_id

            ORDER BY
                touchpoint_timestamp DESC,
                touchpoint_session_key DESC

        ) AS last_touch_rank,

        COUNT(*) OVER (

            PARTITION BY transaction_id

        ) AS eligible_touchpoint_count

    FROM conversion_touchpoints

)

SELECT
*
FROM ranked_touchpoints