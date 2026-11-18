SELECT
    campaign_id,
    campaign_name,
    campaign_type,
    channel,
    source,
    medium,
    currency,

    COUNT(*) AS daily_records,

    COUNT(DISTINCT campaign_date) AS active_days,

    MIN(campaign_date) AS first_campaign_date,

    MAX(campaign_date) AS last_campaign_date,

    SUM(impressions) AS total_impressions,

    SUM(clicks) AS total_clicks,

    SUM(simulated_conversions) AS simulated_conversions,

    SUM(ad_spend) AS total_ad_spend

FROM
    `customer-360-mta.customer_360_raw.ad_spend_unpartitioned`

GROUP BY
    campaign_id,
    campaign_name,
    campaign_type,
    channel,
    source,
    medium,
    currency

ORDER BY
    total_ad_spend DESC;