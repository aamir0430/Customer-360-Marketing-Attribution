SELECT
    attribution_model,

    SUM(attributed_revenue) AS attributed_revenue,

    MAX(order_revenue_usd) AS sample_order_revenue,

    COUNT(DISTINCT transaction_id) AS transaction_count

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_first_last_touch_attribution`

GROUP BY
    attribution_model

ORDER BY
    attribution_model;