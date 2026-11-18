-- ============================================================
-- PHASE 6: CAMPAIGN EFFICIENCY VALIDATION
-- ============================================================

WITH final_model AS (

    SELECT *
    FROM `customer-360-mta.customer_360_dbt_dev.fct_campaign_efficiency`

),

source_model AS (

    SELECT *
    FROM `customer-360-mta.customer_360_dbt_dev.fct_campaign_performance_summary`

)

SELECT

    -- Campaign coverage
    COUNT(*) AS total_campaign_records,

    COUNT(DISTINCT campaign_id) AS distinct_campaigns,

    -- Advertising performance
    SUM(total_impressions) AS total_impressions,

    SUM(total_clicks) AS total_clicks,

    SUM(total_simulated_conversions)
        AS total_simulated_conversions,

    ROUND(SUM(total_ad_spend), 2)
        AS total_ad_spend,

    -- Efficiency metrics
    ROUND(
        SAFE_DIVIDE(
            SUM(total_ad_spend),
            SUM(total_simulated_conversions)
        ),
        2
    ) AS overall_cost_per_simulated_conversion,

    -- ROI measurement limitations
    COUNTIF(actual_ga4_acquisitions IS NOT NULL)
        AS actual_acquisition_records,

    COUNTIF(actual_ga4_attributed_revenue IS NOT NULL)
        AS actual_revenue_records,

    COUNTIF(return_on_ad_spend IS NOT NULL)
        AS roas_records,

    COUNTIF(roi_percentage IS NOT NULL)
        AS roi_records,

    COUNTIF(
        roi_measurement_status = 'UNVERIFIED_CAMPAIGN_MAPPING'
    ) AS correctly_flagged_campaigns,

    -- Source reconciliation
    (
        SELECT COUNT(*)
        FROM source_model
    ) AS source_campaign_records,

    ROUND(
        SUM(total_ad_spend) -
        (
            SELECT SUM(total_ad_spend)
            FROM source_model
        ),
        2
    ) AS advertising_spend_difference,

    SUM(total_simulated_conversions) -
    (
        SELECT SUM(total_simulated_conversions)
        FROM source_model
    ) AS simulated_conversion_difference

FROM final_model;