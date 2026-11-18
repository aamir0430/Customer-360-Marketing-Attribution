SELECT

    eligible_touchpoint_count,

    COUNT(DISTINCT transaction_id)
        AS transaction_count,

    SUM(order_revenue_usd)
        AS repeated_revenue

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_conversion_journeys`

GROUP BY
    eligible_touchpoint_count

ORDER BY
    eligible_touchpoint_count;