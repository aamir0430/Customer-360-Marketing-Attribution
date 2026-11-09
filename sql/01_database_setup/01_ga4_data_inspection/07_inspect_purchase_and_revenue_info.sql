SELECT
    COUNT(*) AS total_purchase_events,

    COUNT(DISTINCT user_pseudo_id) AS purchasing_users,

    COUNT(DISTINCT ecommerce.transaction_id) AS unique_transactions,

    SUM(ecommerce.purchase_revenue_in_usd) AS total_revenue_usd,

    AVG(ecommerce.purchase_revenue_in_usd) AS average_purchase_revenue_usd

FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE
    event_name = 'purchase';