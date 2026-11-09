SELECT
    traffic_source.source AS source,
    traffic_source.medium AS medium,
    traffic_source.name AS campaign,

    COUNT(DISTINCT user_pseudo_id) AS unique_users,

    COUNT(*) AS total_events

FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

GROUP BY
    source,
    medium,
    campaign

ORDER BY
    unique_users DESC

LIMIT 100;