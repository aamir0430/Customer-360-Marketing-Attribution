SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT campaign_id) AS distinct_campaigns,
    MIN(campaign_date) AS first_campaign_date,
    MAX(campaign_date) AS last_campaign_date,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(simulated_conversions) AS total_conversions,
    ROUND(SUM(ad_spend), 2) AS total_ad_spend
FROM
    `customer-360-mta.customer_360_raw.ad_spend_unpartitioned`;