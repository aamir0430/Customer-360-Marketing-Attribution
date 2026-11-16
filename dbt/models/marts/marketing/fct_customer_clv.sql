{{ config(
    materialized = 'table'
) }}

-- MODEL: fct_customer_clv
-- PURPOSE: Calculate historical customer lifetime value
-- GRAIN: One row per CRM customer


-- 1. Retrieve all CRM customers

WITH crm_customers AS (

    SELECT
        customer_id

    FROM {{ ref('dim_customer_profile') }}

),


-- 2. Retrieve identified purchase transactions

valid_orders AS (

    SELECT
        customer_id,
        transaction_id,
        CAST(order_date AS DATE) AS order_date,
        order_revenue_usd

    FROM {{ ref('fct_orders') }}

    WHERE customer_id IS NOT NULL
      AND transaction_id IS NOT NULL
      AND order_date IS NOT NULL

),


-- 3. Aggregate customer purchase metrics

customer_metrics AS (

    SELECT

        customer_id,

        COUNT(DISTINCT transaction_id)
            AS total_orders,

        SUM(order_revenue_usd)
            AS historical_clv,

        AVG(order_revenue_usd)
            AS average_order_value,

        MIN(order_date)
            AS first_purchase_date,

        MAX(order_date)
            AS last_purchase_date

    FROM valid_orders

    GROUP BY customer_id

),


-- 4. Determine historical analysis period

analysis_period AS (

    SELECT
        MIN(order_date) AS dataset_start_date,
        MAX(order_date) AS dataset_end_date

    FROM valid_orders

),


-- 5. Combine all customers with their purchase metrics

customer_clv AS (

    SELECT

        c.customer_id,

        a.dataset_start_date,
        a.dataset_end_date,

        m.first_purchase_date,
        m.last_purchase_date,

        COALESCE(m.total_orders, 0)
            AS total_orders,

        COALESCE(m.historical_clv, 0)
            AS historical_clv,

        COALESCE(m.average_order_value, 0)
            AS average_order_value,

        CASE
            WHEN m.customer_id IS NOT NULL
            THEN DATE_DIFF(
                m.last_purchase_date,
                m.first_purchase_date,
                DAY
            )
            ELSE NULL
        END AS customer_lifespan_days,

        CASE
            WHEN m.customer_id IS NOT NULL
                THEN 'PURCHASER'
            ELSE 'NO_PURCHASE'
        END AS clv_eligibility_status

    FROM crm_customers c

    CROSS JOIN analysis_period a

    LEFT JOIN customer_metrics m

        ON c.customer_id = m.customer_id

),


-- 6. Calculate historical customer activity metrics

customer_value_metrics AS (

    SELECT

        *,

        CASE
            WHEN customer_lifespan_days > 0
            THEN SAFE_DIVIDE(
                historical_clv,
                customer_lifespan_days
            )
            ELSE NULL
        END AS revenue_per_active_day,

        CASE
            WHEN customer_lifespan_days > 0
            THEN SAFE_DIVIDE(
                total_orders,
                customer_lifespan_days
            )
            ELSE NULL
        END AS orders_per_active_day

    FROM customer_clv

),


-- 7. Calculate customer value percentiles
-- Only identified purchasers participate

customer_percentiles AS (

    SELECT

        *,

        CUME_DIST() OVER (
            ORDER BY historical_clv ASC
        ) AS customer_value_percentile

    FROM customer_value_metrics

    WHERE clv_eligibility_status = 'PURCHASER'

),


-- 8. Assign historical customer value categories

customer_value_segments AS (

    SELECT

        c.*,

        p.customer_value_percentile,

        CASE

            WHEN c.clv_eligibility_status = 'NO_PURCHASE'
                THEN 'No Purchase'

            WHEN p.customer_value_percentile <= 0.20
                THEN 'Very Low Value'

            WHEN p.customer_value_percentile <= 0.60
                THEN 'Low Value'

            WHEN p.customer_value_percentile <= 0.80
                THEN 'Medium Value'

            ELSE 'High Value'

        END AS historical_value_segment

    FROM customer_value_metrics c

    LEFT JOIN customer_percentiles p

        ON c.customer_id = p.customer_id

)


-- 9. Final output

SELECT

    customer_id,

    dataset_start_date,
    dataset_end_date,

    first_purchase_date,
    last_purchase_date,

    total_orders,

    historical_clv,

    average_order_value,

    customer_lifespan_days,

    revenue_per_active_day,

    orders_per_active_day,

    customer_value_percentile,

    historical_value_segment,

    clv_eligibility_status

FROM customer_value_segments