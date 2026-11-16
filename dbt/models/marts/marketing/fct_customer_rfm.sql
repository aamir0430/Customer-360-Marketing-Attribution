{{ config(
    materialized = 'table'
) }}

-- MODEL: fct_customer_rfm
-- PURPOSE: Calculate customer-level RFM metrics
-- GRAIN: One row per CRM customer

-- 1. Get the complete CRM customer population

WITH crm_customers AS (

    SELECT
        customer_id

    FROM {{ ref('dim_customer_profile') }}

),

-- 2. Prepare valid identified purchase transactions

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

-- 3. Determine the historical reference date

reference_date AS (

    SELECT
        DATE_ADD(
            MAX(order_date),
            INTERVAL 1 DAY
        ) AS analysis_date

    FROM valid_orders

),

-- 4. Aggregate purchase metrics for each customer

customer_purchase_metrics AS (

    SELECT
        customer_id,

        COUNT(DISTINCT transaction_id)
            AS frequency,

        SUM(order_revenue_usd)
            AS monetary_value,

        MIN(order_date)
            AS first_purchase_date,

        MAX(order_date)
            AS last_purchase_date

    FROM valid_orders

    GROUP BY customer_id

),

-- 5. Combine CRM customers with purchase metrics

customer_rfm AS (

    SELECT

        c.customer_id,

        r.analysis_date,

        p.first_purchase_date,

        p.last_purchase_date,

        CASE
            WHEN p.customer_id IS NOT NULL
            THEN DATE_DIFF(
                r.analysis_date,
                p.last_purchase_date,
                DAY
            )
            ELSE NULL
        END AS recency_days,

        COALESCE(p.frequency, 0)
            AS frequency,

        COALESCE(p.monetary_value, 0)
            AS monetary_value,

        CASE
            WHEN p.customer_id IS NOT NULL
                THEN 'PURCHASER'
            ELSE 'NO_PURCHASE'
        END AS rfm_eligibility_status

    FROM crm_customers c

    CROSS JOIN reference_date r

    LEFT JOIN customer_purchase_metrics p

        ON c.customer_id = p.customer_id

)

-- 6. Final output

SELECT

    customer_id,

    analysis_date,

    first_purchase_date,

    last_purchase_date,

    recency_days,

    frequency,

    monetary_value,

    rfm_eligibility_status

FROM customer_rfm