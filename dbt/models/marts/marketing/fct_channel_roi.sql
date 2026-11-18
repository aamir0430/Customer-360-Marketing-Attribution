-- PHASE 6: CHANNEL-LEVEL ROI AND CPA
-- Model: fct_channel_roi
-- Purpose: Calculate attributed marketing efficiency

{{ config(
    materialized = 'table'
) }}

WITH advertising_spend AS (

    SELECT

        LOWER(TRIM(source)) AS source,
        LOWER(TRIM(medium)) AS medium,

        ANY_VALUE(channel) AS channel,
        ANY_VALUE(currency) AS currency,

        COUNT(DISTINCT campaign_id) AS campaigns_included,

        SUM(total_ad_spend) AS total_ad_spend

    FROM {{ ref('fct_campaign_performance_summary') }}

    GROUP BY
        LOWER(TRIM(source)),
        LOWER(TRIM(medium))

),

ga4_attribution AS (

    SELECT

        LOWER(TRIM(touchpoint_source)) AS source,
        LOWER(TRIM(touchpoint_medium)) AS medium,

        attribution_model,

        COUNT(DISTINCT transaction_id)
            AS attributed_transactions,

        SUM(attribution_credit)
            AS attribution_credit,

        SUM(attributed_revenue)
            AS attributed_revenue

    FROM {{ ref('fct_attribution_comparison') }}

    GROUP BY

        LOWER(TRIM(touchpoint_source)),
        LOWER(TRIM(touchpoint_medium)),
        attribution_model

),

channel_efficiency AS (

    SELECT

        a.source,
        a.medium,
        a.channel,
        a.currency,

        a.campaigns_included,
        a.total_ad_spend,

        g.attribution_model,
        g.attributed_transactions,
        g.attribution_credit,
        g.attributed_revenue

    FROM advertising_spend a

    LEFT JOIN ga4_attribution g

        ON a.source = g.source
        AND a.medium = g.medium

)

SELECT

    source,
    medium,
    channel,
    currency,

    campaigns_included,
    total_ad_spend,

    attribution_model,

    attributed_transactions,
    attribution_credit,
    attributed_revenue,

    -- Attributed acquisition cost
    SAFE_DIVIDE(
        total_ad_spend,
        attribution_credit
    ) AS attributed_cpa,

    -- Return on advertising spend
    SAFE_DIVIDE(
        attributed_revenue,
        total_ad_spend
    ) AS roas,

    -- Return on investment
    SAFE_MULTIPLY(
        SAFE_DIVIDE(
            attributed_revenue - total_ad_spend,
            total_ad_spend
        ),
        100
    ) AS roi_percentage,

    CASE

        WHEN attribution_model IS NOT NULL
        THEN 'SOURCE_MEDIUM_MATCH'

        ELSE 'NO_VERIFIED_MAPPING'

    END AS mapping_status

FROM channel_efficiency