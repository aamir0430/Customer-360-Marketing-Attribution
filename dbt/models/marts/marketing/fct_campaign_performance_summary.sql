{{ config(
    materialized = 'table',
    description = 'Aggregated campaign-level marketing performance metrics derived from daily synthetic advertising spend data.'
) }}

WITH campaign_aggregation AS (

    SELECT
        campaign_id,
        campaign_name,
        campaign_type,
        channel,
        source,
        medium,
        currency,

        MIN(campaign_date) AS campaign_start_date,
        MAX(campaign_date) AS campaign_end_date,

        COUNT(DISTINCT campaign_date) AS active_days,

        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        SUM(simulated_conversions) AS total_simulated_conversions,
        SUM(ad_spend) AS total_ad_spend

    FROM {{ ref('fct_ad_spend_performance') }}

    GROUP BY
        campaign_id,
        campaign_name,
        campaign_type,
        channel,
        source,
        medium,
        currency

)

SELECT
    *,

    SAFE_DIVIDE(
        total_clicks,
        total_impressions
    ) * 100 AS ctr_percentage,

    SAFE_DIVIDE(
        total_ad_spend,
        total_clicks
    ) AS cost_per_click,

    SAFE_DIVIDE(
        total_simulated_conversions,
        total_clicks
    ) * 100 AS simulated_conversion_rate_percentage,

    SAFE_DIVIDE(
        total_ad_spend,
        total_simulated_conversions
    ) AS cost_per_simulated_conversion

FROM campaign_aggregation