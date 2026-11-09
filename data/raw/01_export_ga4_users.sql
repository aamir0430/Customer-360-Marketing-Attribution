-- Export one row per GA4 pseudonymous user.
-- Run in BigQuery, then download the results as ga4_users.csv.
SELECT
  CAST(user_pseudo_id AS STRING) AS user_pseudo_id,
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS first_seen_date,
  MAX(PARSE_DATE('%Y%m%d', event_date)) AS last_seen_date,
  COUNT(*) AS total_events,
  COUNTIF(event_name = 'session_start') AS session_start_events,
  COUNTIF(event_name = 'purchase') AS purchase_events,
  COUNT(DISTINCT IF(
    event_name = 'purchase',
    ecommerce.transaction_id,
    NULL
  )) AS distinct_transaction_ids,
  SUM(IF(
    event_name = 'purchase',
    COALESCE(ecommerce.purchase_revenue_in_usd, 0),
    0
  )) AS purchase_event_revenue_usd
FROM
  `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
WHERE
  user_pseudo_id IS NOT NULL
GROUP BY
  user_pseudo_id;
