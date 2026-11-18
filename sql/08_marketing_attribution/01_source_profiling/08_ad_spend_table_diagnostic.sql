SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT campaign_id) AS distinct_campaigns,
    COUNTIF(campaign_id IS NULL) AS missing_campaign_ids,
    COUNTIF(ad_spend IS NULL) AS missing_ad_spend,
    SUM(impressions) AS total_impressions,
    SUM(clicks) AS total_clicks,
    SUM(conversions) AS total_conversions,
    SUM(ad_spend) AS total_ad_spend,
    MIN(campaign_date) AS first_campaign_date,
    MAX(campaign_date) AS last_campaign_date
FROM
    `customer-360-mta.customer_360_raw.ad_spend`;