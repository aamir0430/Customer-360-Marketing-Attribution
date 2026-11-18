SELECT
    channel,
    total_campaigns,
    total_impressions,
    total_clicks,
    total_simulated_conversions,
    total_ad_spend,
    ctr_percentage,
    cost_per_click,
    simulated_conversion_rate_percentage,
    cost_per_simulated_conversion

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_channel_performance_summary`

ORDER BY
    total_ad_spend DESC;