WITH source_orders AS (

    SELECT
        COUNT(DISTINCT transaction_id) AS source_transactions,
        SUM(order_revenue_usd) AS source_revenue

    FROM
        `customer-360-mta.customer_360_dbt_dev.fct_orders`

),

matched_orders AS (

    SELECT
        COUNT(DISTINCT transaction_id) AS matched_transactions,

        SUM(order_revenue_usd) AS matched_revenue

    FROM (

        SELECT
            transaction_id,
            order_revenue_usd

        FROM
            `customer-360-mta.customer_360_dbt_dev.fct_conversion_journeys`

        QUALIFY
            ROW_NUMBER() OVER (
                PARTITION BY transaction_id
                ORDER BY first_touch_rank
            ) = 1

    )

)

SELECT

    source_transactions,
    matched_transactions,

    source_revenue,
    matched_revenue,

    source_transactions - matched_transactions
        AS unmatched_transactions,

    source_revenue - matched_revenue
        AS unmatched_revenue

FROM source_orders
CROSS JOIN matched_orders;