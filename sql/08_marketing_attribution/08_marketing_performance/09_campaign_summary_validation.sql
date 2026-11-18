SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT campaign_id) AS distinct_campaigns,

    SUM(total_impressions) AS total_impressions,
    SUM(total_clicks) AS total_clicks,
    SUM(total_simulated_conversions) AS total_simulated_conversions,
    SUM(total_ad_spend) AS total_ad_spend

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_campaign_performance_summary`;