SELECT
    user_pseudo_id,

    (
        SELECT value.int_value
        FROM UNNEST(event_params)
        WHERE key = 'ga_session_id'
    ) AS ga_session_id,

    event_name,
    event_date,
    event_timestamp

FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

WHERE
    event_name IN (
        'session_start',
        'page_view',
        'purchase'
    )

LIMIT 100;