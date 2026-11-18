{{ config(
    materialized = 'table',
    description = 'Aggregated advertising performance metrics by marketing channel using synthetic advertising spend data.'
) }}

WITH channel_aggregation AS (

    SELECT
        channel,
        currency,

        COUNT(DISTINCT campaign_id) AS total_campaigns,

        MIN(campaign_date) AS campaign_start_date,
        MAX(campaign_date) AS campaign_end_date,

        SUM(impressions) AS total_impressions,
        SUM(clicks) AS total_clicks,
        SUM(simulated_conversions) AS total_simulated_conversions,
        SUM(ad_spend) AS total_ad_spend

    FROM {{ ref('fct_ad_spend_performance') }}

    GROUP BY
        channel,
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

FROM channel_aggregation