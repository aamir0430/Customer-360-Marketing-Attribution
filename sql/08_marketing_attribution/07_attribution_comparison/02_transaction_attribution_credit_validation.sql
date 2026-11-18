SELECT

    attribution_model,

    transaction_id,

    SUM(attribution_credit) AS total_credit,

    SUM(attributed_revenue) AS total_attributed_revenue,

    MAX(order_revenue_usd) AS original_order_revenue

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_attribution_comparison`

GROUP BY
    attribution_model,
    transaction_id

HAVING

    ABS(
        SUM(attribution_credit) - 1.0
    ) > 0.000001

    OR ABS(
        SUM(attributed_revenue) - MAX(order_revenue_usd)
    ) > 0.01

ORDER BY
    attribution_model,
    transaction_id;