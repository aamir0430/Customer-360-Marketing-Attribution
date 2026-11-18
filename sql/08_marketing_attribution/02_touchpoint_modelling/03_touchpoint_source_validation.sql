SELECT
    touchpoint_source_status,
    touchpoint_source,
    touchpoint_medium,

    COUNT(*) AS session_count,

    COUNT(DISTINCT journey_id) AS distinct_journeys,

    COUNTIF(has_purchase) AS sessions_with_purchase

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_marketing_touchpoints`

GROUP BY
    touchpoint_source_status,
    touchpoint_source,
    touchpoint_medium

ORDER BY
    session_count DESC;SELECT
    touchpoint_source_status,
    touchpoint_source,
    touchpoint_medium,

    COUNT(*) AS session_count,

    COUNT(DISTINCT journey_id) AS distinct_journeys,

    COUNTIF(has_purchase) AS sessions_with_purchase

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_marketing_touchpoints`

GROUP BY
    touchpoint_source_status,
    touchpoint_source,
    touchpoint_medium

ORDER BY
    session_count DESC;