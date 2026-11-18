SELECT
    campaign_id,
    campaign_name,
    channel,
    source,
    medium,
    currency,

    COUNT(*) AS campaign_date_rows,

    MIN(campaign_date) AS first_campaign_date,

    MAX(campaign_date) AS last_campaign_date,

    SUM(impressions) AS total_impressions,

    SUM(clicks) AS total_clicks,

    SUM(conversions) AS total_ad_conversions,

    SUM(ad_spend) AS total_ad_spend

FROM
    `customer-360-mta.customer_360_raw.ad_spend`

GROUP BY
    campaign_id,
    campaign_name,
    channel,
    source,
    medium,
    currency

ORDER BY
    campaign_id;