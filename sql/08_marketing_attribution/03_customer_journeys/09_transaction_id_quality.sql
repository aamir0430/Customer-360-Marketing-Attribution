SELECT
    COUNT(*) AS total_order_rows,

    COUNTIF(transaction_id IS NULL) AS null_transaction_ids,

    COUNTIF(
        LOWER(TRIM(transaction_id)) IN ('', '(not set)', 'null')
    ) AS invalid_transaction_ids,

    COUNT(DISTINCT transaction_id) AS distinct_transaction_ids,

    COUNTIF(order_revenue_usd = 0) AS zero_revenue_orders,

    SUM(order_revenue_usd) AS total_revenue

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_orders`;