SELECT
    MIN(event_date) AS first_event_date,
    MAX(event_date) AS last_event_date,
    COUNT(*) AS total_events,
    COUNT(DISTINCT event_name) AS total_event_types,
    COUNT(DISTINCT user_pseudo_id) AS total_users
FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;