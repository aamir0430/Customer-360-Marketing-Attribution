SELECT
    COUNT(*) AS total_campaign_rows,
    SUM(total_impressions) AS total_impressions,
    SUM(total_clicks) AS total_clicks,
    SUM(total_simulated_conversions) AS total_simulated_conversions,
    SUM(total_ad_spend) AS total_ad_spend
FROM
    `customer-360-mta.customer_360_dbt_dev.fct_marketing_performance_reporting`
WHERE
    reporting_category = 'ADVERTISING_PERFORMANCE';