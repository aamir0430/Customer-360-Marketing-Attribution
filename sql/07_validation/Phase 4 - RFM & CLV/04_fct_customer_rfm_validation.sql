-- Customer Population Validation

SELECT
    COUNT(*) AS total_customers,
    COUNT(DISTINCT customer_id) AS distinct_customers,

    COUNTIF(
        rfm_eligibility_status = 'PURCHASER'
    ) AS purchasing_customers,

    COUNTIF(
        rfm_eligibility_status = 'NO_PURCHASE'
    ) AS non_purchasing_customers

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm`;

-- RFM Metrics Overview

SELECT

    MIN(analysis_date) AS analysis_date,

    MIN(recency_days) AS minimum_recency,

    MAX(recency_days) AS maximum_recency,

    MIN(frequency) AS minimum_frequency,

    MAX(frequency) AS maximum_frequency,

    SUM(frequency) AS total_identified_orders,

    SUM(monetary_value) AS total_identified_revenue,

    AVG(
        CASE
            WHEN frequency > 0
            THEN monetary_value
        END
    ) AS average_customer_revenue

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm`;

-- Inspect non-purchasing customers

SELECT
    customer_id,
    recency_days,
    frequency,
    monetary_value,
    rfm_eligibility_status

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm`

WHERE rfm_eligibility_status = 'NO_PURCHASE'

LIMIT 20;

-- Inspect Top 20 customers by monetary value

SELECT
    customer_id,
    recency_days,
    frequency,
    monetary_value,
    first_purchase_date,
    last_purchase_date

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm`

WHERE rfm_eligibility_status = 'PURCHASER'

ORDER BY monetary_value DESC

LIMIT 20;

-- Check for invalid RFM metrics

SELECT
    COUNTIF(frequency < 0) AS negative_frequency,

    COUNTIF(monetary_value < 0) AS negative_monetary_value,

    COUNTIF(recency_days < 0) AS negative_recency,

    COUNTIF(
        rfm_eligibility_status = 'PURCHASER'
        AND (
            recency_days IS NULL
            OR first_purchase_date IS NULL
            OR last_purchase_date IS NULL
        )
    ) AS invalid_purchaser_records,

    COUNTIF(
        rfm_eligibility_status = 'NO_PURCHASE'
        AND (
            recency_days IS NOT NULL
            OR frequency != 0
            OR monetary_value != 0
        )
    ) AS invalid_non_purchaser_records

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm`;

