SELECT

    COUNT(DISTINCT transaction_id)
        AS transactions_with_touchpoints,

    COUNT(*) AS conversion_touchpoint_rows,

    COUNT(DISTINCT touchpoint_session_key)
        AS distinct_touchpoint_sessions,

    COUNT(DISTINCT journey_id)
        AS distinct_journeys,

    SUM(order_revenue_usd)
        AS repeated_touchpoint_revenue

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_conversion_journeys`;