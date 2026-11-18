SELECT
    COUNT(*) AS total_orders,

    COUNT(DISTINCT transaction_id) AS distinct_transactions,

    COUNTIF(session_key IS NOT NULL) AS orders_with_session_key,

    COUNTIF(session_key IS NULL) AS orders_without_session_key,

    COUNTIF(customer_id IS NOT NULL) AS orders_with_customer_id,

    COUNTIF(customer_id IS NULL) AS orders_without_customer_id,

    COUNTIF(order_revenue_usd IS NULL) AS orders_with_null_revenue,

    SUM(order_revenue_usd) AS total_order_revenue_usd,

    SUM(
        CASE
            WHEN session_key IS NOT NULL
            THEN order_revenue_usd
            ELSE 0
        END
    ) AS revenue_with_session_key,

    SUM(
        CASE
            WHEN session_key IS NULL
            THEN order_revenue_usd
            ELSE 0
        END
    ) AS revenue_without_session_key

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_orders`;