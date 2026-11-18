{{ config(
    materialized = 'table',
    description = 'Daily campaign-level advertising performance metrics derived from synthetic advertising spend data.'
) }}

WITH source_data AS (

    SELECT
        campaign_date,
        campaign_id,
        campaign_name,
        campaign_type,
        channel,
        source,
        medium,
        currency,
        impressions,
        clicks,
        simulated_conversions,
        ad_spend

    FROM
        `customer-360-mta.customer_360_raw.ad_spend_unpartitioned`

),

performance_metrics AS (

    SELECT
        campaign_date,
        campaign_id,
        campaign_name,
        campaign_type,
        channel,
        source,
        medium,
        currency,

        impressions,
        clicks,
        simulated_conversions,
        ad_spend,

        SAFE_DIVIDE(clicks, impressions) * 100
            AS ctr_percentage,

        SAFE_DIVIDE(ad_spend, clicks)
            AS cost_per_click,

        SAFE_DIVIDE(simulated_conversions, clicks) * 100
            AS simulated_conversion_rate_percentage,

        SAFE_DIVIDE(ad_spend, simulated_conversions)
            AS cost_per_simulated_conversion

    FROM source_data

)

SELECT *
FROM performance_metrics