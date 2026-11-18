SELECT
    identity_type,
    COUNT(*) AS session_count,
    COUNT(DISTINCT journey_id) AS distinct_journeys,
    COUNT(DISTINCT session_key) AS distinct_sessions

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_marketing_touchpoints`

GROUP BY
    identity_type

ORDER BY
    identity_type;