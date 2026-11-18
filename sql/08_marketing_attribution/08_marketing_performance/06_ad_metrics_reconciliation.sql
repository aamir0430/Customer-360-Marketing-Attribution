SELECT
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(simulated_conversions) AS total_simulated_conversions,
    SUM(ad_spend) AS total_ad_spend
FROM
    `customer-360-mta.customer_360_dbt_dev.fct_ad_spend_performance`;