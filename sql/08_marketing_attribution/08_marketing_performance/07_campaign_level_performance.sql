SELECT
    campaign_id,
    campaign_name,

    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(simulated_conversions) AS total_simulated_conversions,
    SUM(ad_spend) AS total_ad_spend,

    SAFE_DIVIDE(
        SUM(clicks),
        SUM(impressions)
    ) * 100 AS ctr_percentage,

    SAFE_DIVIDE(
        SUM(ad_spend),
        SUM(clicks)
    ) AS cost_per_click,

    SAFE_DIVIDE(
        SUM(ad_spend),
        SUM(simulated_conversions)
    ) AS cost_per_simulated_conversion

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_ad_spend_performance`

GROUP BY
    campaign_id,
    campaign_name

ORDER BY
    total_ad_spend DESC;