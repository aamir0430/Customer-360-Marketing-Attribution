SELECT
    COUNT(*) AS total_channel_rows,

    SUM(total_campaigns) AS total_campaign_assignments,

    SUM(total_impressions) AS total_impressions,
    SUM(total_clicks) AS total_clicks,
    SUM(total_simulated_conversions) AS total_simulated_conversions,
    SUM(total_ad_spend) AS total_ad_spend

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_channel_performance_summary`;