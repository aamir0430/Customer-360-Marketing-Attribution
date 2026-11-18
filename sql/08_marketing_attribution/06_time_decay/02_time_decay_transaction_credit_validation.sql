SELECT

    transaction_id,

    COUNT(*) AS touchpoint_count,

    SUM(attribution_credit) AS total_transaction_credit,

    SUM(attributed_revenue)
        AS total_transaction_attributed_revenue,

    MAX(order_revenue_usd) AS original_order_revenue

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_time_decay_attribution`

GROUP BY
    transaction_id

HAVING

    ABS(
        SUM(attribution_credit) - 1.0
    ) > 0.000001

    OR ABS(
        SUM(attributed_revenue) - MAX(order_revenue_usd)
    ) > 0.01

ORDER BY
    transaction_id;