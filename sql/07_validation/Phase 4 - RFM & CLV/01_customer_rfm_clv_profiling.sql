-- Customer Overview

SELECT

    COUNT(*) AS total_customers,

    COUNTIF(total_orders > 0) AS purchasing_customers,

    COUNTIF(total_orders = 0) AS non_purchasing_customers,

    COUNTIF(total_sessions > 0) AS customers_with_sessions,

    SUM(total_orders) AS total_orders,

    SUM(total_revenue_usd) AS total_revenue_usd

FROM
    `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`;

-- Purchase history overview

SELECT

    MIN(order_date) AS first_order_date,

    MAX(order_date) AS latest_order_date,

    COUNT(*) AS total_orders,

    COUNT(DISTINCT customer_id) AS purchasing_customers,

    SUM(order_revenue_usd) AS total_revenue_usd,

    AVG(order_revenue_usd) AS average_order_value_usd,

    MIN(order_revenue_usd) AS minimum_order_value,

    MAX(order_revenue_usd) AS maximum_order_value

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_orders`;

-- Customer purchase frequency distribution

SELECT

    total_orders,

    COUNT(*) AS customer_count,

    SUM(total_revenue_usd) AS total_revenue_usd

FROM
    `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`

GROUP BY
    total_orders

ORDER BY
    total_orders;

-- Revenue distribution by customer

SELECT

    customer_id,

    total_orders,

    total_revenue_usd,

    first_purchase_date,

    last_purchase_date

FROM
    `customer-360-mta.customer_360_dbt_dev.dim_customer_profile`

WHERE
    total_orders > 0

ORDER BY
    total_revenue_usd DESC

LIMIT 20;