SELECT
    ep.key AS parameter_name,
    COUNT(*) AS occurrences

FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`,
    UNNEST(event_params) AS ep

WHERE
    ep.key IN (
        'source',
        'medium',
        'campaign',
        'ga_session_id',
        'page_location'
    )

GROUP BY
    parameter_name

ORDER BY
    occurrences DESC;