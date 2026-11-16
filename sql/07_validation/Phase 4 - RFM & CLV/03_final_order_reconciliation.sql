-- Compare aggregate totals directly

WITH profile_totals AS (
    SELECT
        COUNT(*) AS profile_customer_rows,
        COUNTIF(total_orders > 0) AS purchasing_customers,
        SUM(total_orders) AS total_orders,
        SUM(total_revenue_usd) AS total_revenue
    FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`
),

fact_totals AS (
    SELECT
        COUNT(*) AS fact_order_rows,
        COUNT(DISTINCT transaction_id) AS distinct_orders,
        COUNT(DISTINCT customer_id) AS purchasing_customers,
        SUM(order_revenue_usd) AS total_revenue
    FROM `customer-360-mta.customer_360_dbt_dev.fct_orders`
)

SELECT
    p.profile_customer_rows,
    p.purchasing_customers AS profile_purchasing_customers,
    p.total_orders AS profile_orders,
    f.fact_order_rows,
    f.distinct_orders,
    f.purchasing_customers AS fact_purchasing_customers,
    f.total_revenue AS fact_revenue,
    p.total_orders - f.distinct_orders AS order_difference,
    p.total_revenue - f.total_revenue AS revenue_difference
FROM profile_totals p
CROSS JOIN fact_totals f;

-- Compare every customer, including unmatched records

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
),

comparison AS (
    SELECT
        COALESCE(p.customer_id, o.customer_id) AS customer_id,
        p.profile_orders,
        o.fact_orders,
        p.profile_revenue,
        o.fact_revenue,

        CASE
            WHEN p.customer_id IS NULL THEN 'MISSING_FROM_PROFILE'
            WHEN o.customer_id IS NULL THEN 'MISSING_FROM_FACT'
            ELSE 'PRESENT_IN_BOTH'
        END AS customer_status,

        p.profile_orders IS DISTINCT FROM o.fact_orders
            AS order_count_mismatch,

        ABS(
            COALESCE(p.profile_revenue, 0)
            - COALESCE(o.fact_revenue, 0)
        ) > 0.01 AS revenue_mismatch

    FROM profile_metrics p
    FULL OUTER JOIN order_metrics o
        ON p.customer_id = o.customer_id
)

SELECT *
FROM comparison
WHERE
    customer_status != 'PRESENT_IN_BOTH'
    OR order_count_mismatch
    OR revenue_mismatch
ORDER BY customer_id;