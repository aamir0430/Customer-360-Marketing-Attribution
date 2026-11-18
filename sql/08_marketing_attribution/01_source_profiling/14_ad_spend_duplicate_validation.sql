-- ============================================================
-- AD SPEND DUPLICATE VALIDATION
-- Project: Customer 360 & Marketing Attribution
-- Source: customer_360_raw.ad_spend_unpartitioned
-- ============================================================

SELECT
    campaign_id,
    campaign_date,
    source,
    medium,

    COUNT(*) AS duplicate_count

FROM
    `customer-360-mta.customer_360_raw.ad_spend_unpartitioned`

GROUP BY
    campaign_id,
    campaign_date,
    source,
    medium

HAVING
    COUNT(*) > 1

ORDER BY
    duplicate_count DESC;