SELECT
    channel,
    currency,
    COUNT(*) AS record_count

FROM {{ ref('fct_channel_performance_summary') }}

GROUP BY
    channel,
    currency

HAVING COUNT(*) > 1