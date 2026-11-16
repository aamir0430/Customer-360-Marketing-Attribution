-- Customer population

SELECT

    COUNT(*) AS total_customers,

    COUNT(DISTINCT customer_id) AS distinct_customers,

    COUNTIF(clv_eligibility_status = 'PURCHASER')
        AS purchasing_customers,

    COUNTIF(clv_eligibility_status = 'NO_PURCHASE')
        AS non_purchasing_customers

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_clv`;

-- Historical CLV Overview

SELECT

    SUM(historical_clv) AS total_historical_clv,

    AVG(
        CASE
            WHEN clv_eligibility_status = 'PURCHASER'
            THEN historical_clv
        END
    ) AS average_purchaser_clv,

    APPROX_QUANTILES(
        historical_clv, 100
    )[OFFSET(50)] AS median_customer_clv,

    MAX(historical_clv) AS maximum_customer_clv,

    SUM(total_orders) AS total_identified_orders,

    AVG(
        CASE
            WHEN total_orders > 0
            THEN average_order_value
        END
    ) AS average_order_value

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_clv`;

-- Historical value segment distribution

SELECT

    historical_value_segment,

    COUNT(*) AS customer_count,

    SUM(historical_clv) AS total_historical_clv,

    AVG(historical_clv) AS average_customer_clv

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_clv`

GROUP BY historical_value_segment

ORDER BY total_historical_clv DESC;

-- Top 20 customers by historical CLV

SELECT

    customer_id,

    total_orders,

    historical_clv,

    average_order_value,

    customer_lifespan_days,

    revenue_per_active_day,

    historical_value_segment

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_clv`

WHERE clv_eligibility_status = 'PURCHASER'

ORDER BY historical_clv DESC

LIMIT 20;

-- Customer Lifespan Validation

SELECT

    COUNTIF(customer_lifespan_days = 0)
        AS single_day_customers,

    COUNTIF(customer_lifespan_days > 0)
        AS multi_day_customers,

    COUNTIF(customer_lifespan_days < 0)
        AS invalid_lifespan_customers,

    COUNTIF(
        customer_lifespan_days = 0
        AND (
            revenue_per_active_day IS NOT NULL
            OR orders_per_active_day IS NOT NULL
        )
    ) AS invalid_single_day_rates

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_clv`

WHERE clv_eligibility_status = 'PURCHASER';

-- CLV data quality checks

SELECT

    COUNTIF(historical_clv < 0)
        AS negative_historical_clv,

    COUNTIF(total_orders < 0)
        AS negative_order_counts,

    COUNTIF(average_order_value < 0)
        AS negative_average_order_value,

    COUNTIF(
        clv_eligibility_status = 'NO_PURCHASE'
        AND (
            total_orders != 0
            OR historical_clv != 0
            OR historical_value_segment != 'No Purchase'
        )
    ) AS invalid_non_purchaser_records,

    COUNTIF(
        clv_eligibility_status = 'PURCHASER'
        AND (
            first_purchase_date IS NULL
            OR last_purchase_date IS NULL
        )
    ) AS invalid_purchaser_dates

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_clv`;

