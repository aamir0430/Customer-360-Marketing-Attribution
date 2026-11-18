{{ config(
    materialized = 'table',
    description = 'Consolidated marketing reporting model containing independent advertising performance and GA4 attribution performance records. Advertising spend is not directly joined to GA4 attributed revenue because campaign-level mapping has not been established.'
) }}

WITH advertising_performance AS (

    SELECT
        'ADVERTISING_PERFORMANCE' AS reporting_category,

        'SYNTHETIC_AD_SPEND' AS data_source,

        channel,
        source,
        medium,

        campaign_id,
        campaign_name AS campaign,

        CAST(NULL AS STRING) AS attribution_model,

        currency,

        -- Each record represents exactly one campaign.
        CAST(1 AS INT64) AS total_campaigns,

        total_impressions,
        total_clicks,
        total_simulated_conversions,
        total_ad_spend,

        CAST(NULL AS INT64) AS attributed_transactions,

        CAST(NULL AS FLOAT64) AS total_attribution_credit,

        CAST(NULL AS FLOAT64) AS total_attributed_revenue,

        ctr_percentage,
        cost_per_click,

        simulated_conversion_rate_percentage,
        cost_per_simulated_conversion

    FROM {{ ref('fct_campaign_performance_summary') }}

),

attribution_performance AS (

    SELECT
        'GA4_ATTRIBUTION_PERFORMANCE' AS reporting_category,

        'GA4_SAMPLE_ECOMMERCE' AS data_source,

        CAST(NULL AS STRING) AS channel,

        touchpoint_source AS source,
        touchpoint_medium AS medium,

        CAST(NULL AS STRING) AS campaign_id,
        touchpoint_campaign AS campaign,

        attribution_model,

        'USD' AS currency,

        CAST(NULL AS INT64) AS total_campaigns,
        CAST(NULL AS INT64) AS total_impressions,
        CAST(NULL AS INT64) AS total_clicks,
        CAST(NULL AS INT64) AS total_simulated_conversions,
        CAST(NULL AS FLOAT64) AS total_ad_spend,

        COUNT(DISTINCT transaction_id) AS attributed_transactions,

        SUM(attribution_credit) AS total_attribution_credit,

        SUM(attributed_revenue) AS total_attributed_revenue,

        CAST(NULL AS FLOAT64) AS ctr_percentage,
        CAST(NULL AS FLOAT64) AS cost_per_click,

        CAST(NULL AS FLOAT64) AS simulated_conversion_rate_percentage,
        CAST(NULL AS FLOAT64) AS cost_per_simulated_conversion

    FROM {{ ref('fct_attribution_comparison') }}

    GROUP BY
        attribution_model,
        touchpoint_source,
        touchpoint_medium,
        touchpoint_campaign

)

SELECT *
FROM advertising_performance

UNION ALL

SELECT *
FROM attribution_performance