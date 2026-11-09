-- Export one row per observed GA4 session.
-- Run in BigQuery, then download the results as ga4_sessions.csv.
WITH event_rows AS (
  SELECT
    CAST(user_pseudo_id AS STRING) AS user_pseudo_id,
    (SELECT value.int_value
     FROM UNNEST(event_params)
     WHERE key = 'ga_session_id'
     LIMIT 1) AS ga_session_id,
    event_date,
    event_timestamp,
    event_name,
    traffic_source.source AS first_user_source,
    traffic_source.medium AS first_user_medium,
    traffic_source.name AS first_user_campaign,
    (SELECT value.string_value
     FROM UNNEST(event_params)
     WHERE key = 'source'
     LIMIT 1) AS event_source,
    (SELECT value.string_value
     FROM UNNEST(event_params)
     WHERE key = 'medium'
     LIMIT 1) AS event_medium,
    (SELECT value.string_value
     FROM UNNEST(event_params)
     WHERE key = 'campaign'
     LIMIT 1) AS event_campaign
  FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`
  WHERE
    user_pseudo_id IS NOT NULL
)
SELECT
  user_pseudo_id,
  CAST(ga_session_id AS STRING) AS ga_session_id,
  MIN(PARSE_DATE('%Y%m%d', event_date)) AS session_event_date,
  TIMESTAMP_MICROS(MIN(event_timestamp)) AS session_first_event_timestamp_utc,
  COUNT(*) AS events_in_session,
  COUNTIF(event_name = 'purchase') AS purchase_events,
  ARRAY_AGG(event_source IGNORE NULLS ORDER BY event_timestamp LIMIT 1)[SAFE_OFFSET(0)]
    AS observed_event_source,
  ARRAY_AGG(event_medium IGNORE NULLS ORDER BY event_timestamp LIMIT 1)[SAFE_OFFSET(0)]
    AS observed_event_medium,
  ARRAY_AGG(event_campaign IGNORE NULLS ORDER BY event_timestamp LIMIT 1)[SAFE_OFFSET(0)]
    AS observed_event_campaign,
  ANY_VALUE(first_user_source) AS first_user_source,
  ANY_VALUE(first_user_medium) AS first_user_medium,
  ANY_VALUE(first_user_campaign) AS first_user_campaign
FROM event_rows
WHERE ga_session_id IS NOT NULL
GROUP BY user_pseudo_id, ga_session_id;
