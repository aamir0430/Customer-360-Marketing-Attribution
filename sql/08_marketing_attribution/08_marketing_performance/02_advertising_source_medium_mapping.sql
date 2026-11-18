SELECT DISTINCT
    source,
    medium,
    channel,
    campaign_type

FROM
    `customer-360-mta.customer_360_raw.ad_spend_unpartitioned`

ORDER BY
    source,
    medium;