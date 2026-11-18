SELECT *
FROM
    `customer-360-mta.customer_360_dbt_dev.fct_channel_performance_summary`
WHERE
    channel IS NULL
    OR total_campaigns IS NULL
    OR total_impressions IS NULL
    OR total_clicks IS NULL
    OR total_simulated_conversions IS NULL
    OR total_ad_spend IS NULL
    OR total_impressions < 0
    OR total_clicks < 0
    OR total_simulated_conversions < 0
    OR total_ad_spend < 0;