SELECT *
FROM
    `customer-360-mta.customer_360_dbt_dev.fct_ad_spend_performance`
WHERE
    campaign_id IS NULL
    OR campaign_date IS NULL
    OR impressions IS NULL
    OR clicks IS NULL
    OR simulated_conversions IS NULL
    OR ad_spend IS NULL
    OR impressions < 0
    OR clicks < 0
    OR simulated_conversions < 0
    OR ad_spend < 0;