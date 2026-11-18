SELECT
    campaign_id,
    campaign_name,
    total_ad_spend,
    total_impressions,
    total_clicks,
    total_simulated_conversions,
    ctr_percentage,
    cost_per_click,
    cost_per_simulated_conversion

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_campaign_performance_summary`

ORDER BY
    total_ad_spend DESC;