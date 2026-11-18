-- AD SPEND CAMPAIGN DISTRIBUTION
-- Project: Customer 360 & Marketing Attribution
-- Source: customer_360_raw.ad_spend_unpartitioned

SELECT
    campaign_id,
    campaign_name,
    campaign_type,
    channel,
    source,
    medium,

    COUNT(*) AS total_records,

    SUM(impressions) AS total_impressions,

    SUM(clicks) AS total_clicks,

    SUM(simulated_conversions) AS total_conversions,

    ROUND(SUM(ad_spend), 2) AS total_ad_spend,

    ROUND(
        SAFE_DIVIDE(SUM(clicks), SUM(impressions)) * 100,
        2
    ) AS click_through_rate,

    ROUND(
        SAFE_DIVIDE(SUM(simulated_conversions), SUM(clicks)) * 100,
        2
    ) AS conversion_rate

FROM
    `customer-360-mta.customer_360_raw.ad_spend_unpartitioned`

GROUP BY
    campaign_id,
    campaign_name,
    campaign_type,
    channel,
    source,
    medium

ORDER BY
    total_ad_spend DESC;