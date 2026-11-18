-- PHASE 6: CAMPAIGN ROI AND CPA
-- Model: fct_campaign_efficiency
-- Purpose: Consolidated campaign efficiency analysis

{{ config(
    materialized = 'table'
) }}

WITH campaign_performance AS (

    SELECT
        campaign_id,
        campaign_name,
        campaign_type,
        channel,
        source,
        medium,
        currency,

        campaign_start_date,
        campaign_end_date,
        active_days,

        total_impressions,
        total_clicks,
        total_simulated_conversions,
        total_ad_spend,

        ctr_percentage,
        cost_per_click,
        simulated_conversion_rate_percentage,
        cost_per_simulated_conversion

    FROM {{ ref('fct_campaign_performance_summary') }}

)

SELECT

    campaign_id,
    campaign_name,
    campaign_type,
    channel,
    source,
    medium,
    currency,

    campaign_start_date,
    campaign_end_date,
    active_days,

    -- Advertising performance
    total_impressions,
    total_clicks,
    total_simulated_conversions,
    total_ad_spend,

    ctr_percentage,
    cost_per_click,
    simulated_conversion_rate_percentage,

    -- Simulated acquisition efficiency
    cost_per_simulated_conversion,

    -- Actual GA4 acquisition metrics
    CAST(NULL AS INT64) AS actual_ga4_acquisitions,

    CAST(NULL AS FLOAT64)
        AS actual_ga4_attributed_revenue,

    CAST(NULL AS FLOAT64)
        AS actual_cost_per_acquisition,

    CAST(NULL AS FLOAT64)
        AS return_on_ad_spend,

    CAST(NULL AS FLOAT64)
        AS roi_percentage,

    -- Measurement status
    'UNVERIFIED_CAMPAIGN_MAPPING'
        AS roi_measurement_status,

    'GA4 purchase revenue cannot be reliably linked '
    || 'to synthetic advertising campaign IDs. '
    || 'Actual CPA, ROAS and ROI are therefore unavailable.'
        AS measurement_limitation

FROM campaign_performance