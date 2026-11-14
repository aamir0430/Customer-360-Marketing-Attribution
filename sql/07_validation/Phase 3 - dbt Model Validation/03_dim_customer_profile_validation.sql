-- Overall customer metrics

SELECT

    COUNT(*) AS total_customers,

    COUNT(DISTINCT customer_id) AS unique_customers,

    COUNTIF(total_sessions > 0) AS customers_with_sessions,

    COUNTIF(total_orders > 0) AS customers_with_orders,

    COUNTIF(total_orders = 0) AS customers_without_orders,

    SUM(total_sessions) AS total_sessions,

    SUM(total_orders) AS total_orders,

    SUM(total_revenue_usd) AS total_customer_revenue_usd,

    AVG(total_revenue_usd) AS average_customer_revenue_usd

FROM
    `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`;

-- Customer Uniqueness

SELECT

    customer_id,

    COUNT(*) AS record_count

FROM
    `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`

GROUP BY
    customer_id

HAVING
    COUNT(*) > 1;

-- Customers with 0 activity

SELECT

    COUNTIF(total_sessions = 0)
        AS customers_without_sessions,

    COUNTIF(total_orders = 0)
        AS customers_without_orders,

    COUNTIF(
        total_sessions = 0
        AND total_orders = 0
    ) AS customers_without_sessions_or_orders

FROM
    `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`;

-- Customer segment distribution

SELECT

    customer_segment,

    COUNT(*) AS customer_count,

    SUM(total_orders) AS total_orders,

    SUM(total_revenue_usd) AS total_revenue_usd

FROM
    `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`

GROUP BY
    customer_segment

ORDER BY
    customer_count DESC;

-- Customer revenue consistency

SELECT

    customer_segment,

    COUNT(*) AS customer_count,

    SUM(total_orders) AS total_orders,

    SUM(total_revenue_usd) AS total_revenue_usd

FROM
    `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`

GROUP BY
    customer_segment

ORDER BY
    customer_count DESC;