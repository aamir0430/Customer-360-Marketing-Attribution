-- Historical Customer value distribution

SELECT

    COUNT(*) AS purchasing_customers,

    MIN(monetary_value) AS minimum_customer_value,

    MAX(monetary_value) AS maximum_customer_value,

    AVG(monetary_value) AS average_customer_value,

    APPROX_QUANTILES(monetary_value, 100)[OFFSET(25)]
        AS p25_customer_value,

    APPROX_QUANTILES(monetary_value, 100)[OFFSET(50)]
        AS median_customer_value,

    APPROX_QUANTILES(monetary_value, 100)[OFFSET(75)]
        AS p75_customer_value,

    APPROX_QUANTILES(monetary_value, 100)[OFFSET(90)]
        AS p90_customer_value

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm`

WHERE frequency > 0;

-- Customer purchase frequency and value

SELECT

    frequency,

    COUNT(*) AS customer_count,

    AVG(monetary_value) AS average_customer_value,

    MIN(monetary_value) AS minimum_customer_value,

    MAX(monetary_value) AS maximum_customer_value,

    SUM(monetary_value) AS total_revenue

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm`

WHERE frequency > 0

GROUP BY frequency

ORDER BY frequency;

-- Customer purchase lifespan

SELECT

    COUNT(*) AS purchasing_customers,

    COUNTIF(
        first_purchase_date = last_purchase_date
    ) AS single_day_purchasers,

    COUNTIF(
        first_purchase_date < last_purchase_date
    ) AS repeat_day_purchasers,

    AVG(
        DATE_DIFF(
            last_purchase_date,
            first_purchase_date,
            DAY
        )
    ) AS average_customer_lifespan_days,

    MAX(
        DATE_DIFF(
            last_purchase_date,
            first_purchase_date,
            DAY
        )
    ) AS maximum_customer_lifespan_days

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm`

WHERE frequency > 0;
