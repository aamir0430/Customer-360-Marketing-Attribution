SELECT
    COALESCE(
        NULLIF(TRIM(observed_event_source), ''),
        '(not set)'
    ) AS observed_source,

    COALESCE(
        NULLIF(TRIM(observed_event_medium), ''),
        '(not set)'
    ) AS observed_medium,

    COALESCE(
        NULLIF(TRIM(observed_event_campaign), ''),
        '(not set)'
    ) AS observed_campaign,

    COUNT(*) AS session_count,

    COUNT(DISTINCT customer_id) AS customer_count,

    COUNTIF(purchase_events > 0) AS sessions_with_purchase

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_sessions`

GROUP BY
    observed_source,
    observed_medium,
    observed_campaign

ORDER BY
    session_count DESC;