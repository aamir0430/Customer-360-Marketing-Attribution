-- Check duplicate transactions

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS distinct_transactions,
    COUNT(*) - COUNT(DISTINCT transaction_id) AS duplicate_transaction_rows,
    COUNTIF(transaction_id IS NULL) AS null_transaction_ids
FROM `customer-360-mta.customer_360_dbt_dev.fct_orders`;

-- Check revenue aggregation

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT transaction_id) AS distinct_transactions,
    SUM(order_revenue_usd) AS total_revenue,
    SUM(DISTINCT order_revenue_usd) AS distinct_revenue_values_sum,
    AVG(order_revenue_usd) AS average_order_value,
    COUNTIF(order_revenue_usd = 0) AS zero_value_orders,
    COUNTIF(order_revenue_usd < 0) AS negative_value_orders,
    COUNTIF(order_revenue_usd IS NULL) AS null_revenue_orders
FROM `customer-360-mta.customer_360_dbt_dev.fct_orders`;

-- Compare customer-level order counts and revenue

WITH order_metrics AS (
    SELECT
        customer_id,
        COUNT(DISTINCT transaction_id) AS fact_orders,
        SUM(order_revenue_usd) AS fact_revenue
    FROM `customer-360-mta.customer_360_dbt_dev.fct_orders`
    GROUP BY customer_id
),

profile_metrics AS (
    SELECT
        customer_id,
        total_orders AS profile_orders,
        total_revenue_usd AS profile_revenue
    FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`
)

SELECT
    p.customer_id,
    p.profile_orders,
    COALESCE(o.fact_orders, 0) AS fact_orders,
    p.profile_revenue,
    COALESCE(o.fact_revenue, 0) AS fact_revenue,
    COALESCE(o.fact_orders, 0) - p.profile_orders AS order_difference,
    COALESCE(o.fact_revenue, 0) - p.profile_revenue AS revenue_difference
FROM profile_metrics p
LEFT JOIN order_metrics o
    ON p.customer_id = o.customer_id
WHERE
    p.profile_orders != COALESCE(o.fact_orders, 0)
    OR ABS(
        p.profile_revenue - COALESCE(o.fact_revenue, 0)
    ) > 0.01
ORDER BY ABS(
    COALESCE(o.fact_revenue, 0) - p.profile_revenue
) DESC;

-- Compare overall totals using distinct transactions

SELECT
    COUNT(DISTINCT transaction_id) AS distinct_orders,
    COUNT(DISTINCT customer_id) AS purchasing_customers,
    SUM(order_revenue_usd) AS total_revenue_usd
FROM `customer-360-mta.customer_360_dbt_dev.fct_orders`;