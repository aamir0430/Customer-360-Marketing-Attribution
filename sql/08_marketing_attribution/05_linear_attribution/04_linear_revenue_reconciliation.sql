WITH source_orders AS (

    SELECT
        COUNT(DISTINCT transaction_id) AS source_transactions,
        SUM(order_revenue_usd) AS source_revenue

    FROM
        `customer-360-mta.customer_360_dbt_dev.fct_orders`

    WHERE
        transaction_id IS NOT NULL

),

linear_results AS (

    SELECT
        COUNT(DISTINCT transaction_id) AS attributed_transactions,

        SUM(attributed_revenue) AS attributed_revenue

    FROM
        `customer-360-mta.customer_360_dbt_dev.fct_linear_attribution`

)

SELECT

    source_transactions,
    attributed_transactions,

    source_revenue,
    attributed_revenue,

    source_transactions - attributed_transactions AS transaction_difference,

    source_revenue - attributed_revenue AS revenue_difference,

    ABS(source_revenue - attributed_revenue) <= 0.01 AS revenue_reconciles

FROM source_orders
CROSS JOIN linear_results;