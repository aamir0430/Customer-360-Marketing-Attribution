-- Customer Population Validation

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT customer_id) AS distinct_customers,

    COUNTIF(
        rfm_eligibility_status = 'PURCHASER'
    ) AS rfm_purchasers,

    COUNTIF(
        rfm_eligibility_status = 'NO_PURCHASE'
    ) AS rfm_non_purchasers,

    COUNTIF(
        clv_eligibility_status = 'PURCHASER'
    ) AS clv_purchasers,

    COUNTIF(
        clv_eligibility_status = 'NO_PURCHASE'
    ) AS clv_non_purchasers

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_360_analytics`;

-- RFM and CLV Eligibility Status Reconciliation

SELECT
    COUNT(*) AS total_customers,

    SUM(frequency) AS total_rfm_orders,
    SUM(total_orders) AS total_clv_orders,

    ROUND(SUM(monetary_value), 2) AS total_rfm_revenue,
    ROUND(SUM(historical_clv), 2) AS total_historical_clv,

    COUNTIF(frequency != total_orders)
        AS frequency_mismatch_count,

    COUNTIF(
        ABS(monetary_value - historical_clv) > 0.01
    ) AS revenue_mismatch_count

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_360_analytics`;

-- RFM segment distribution

SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(historical_clv), 2) AS total_historical_clv,
    ROUND(
        SAFE_DIVIDE(
            COUNT(*),
            SUM(COUNT(*)) OVER ()
        ) * 100,
        2
    ) AS customer_percentage

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_360_analytics`

GROUP BY customer_segment
ORDER BY customer_count DESC;

-- Historical value segment distribution

SELECT
    historical_value_segment,
    COUNT(*) AS customer_count,
    ROUND(SUM(historical_clv), 2) AS total_historical_clv,
    ROUND(
        SAFE_DIVIDE(
            SUM(historical_clv),
            SUM(SUM(historical_clv)) OVER ()
        ) * 100,
        2
    ) AS revenue_contribution_percentage

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_360_analytics`

GROUP BY historical_value_segment
ORDER BY total_historical_clv DESC;

-- Missing data and eligibility validation

SELECT
    COUNTIF(customer_id IS NULL) AS null_customer_ids,

    COUNTIF(customer_segment IS NULL)
        AS missing_customer_segments,

    COUNTIF(historical_value_segment IS NULL)
        AS missing_value_segments,

    COUNTIF(rfm_eligibility_status IS NULL)
        AS missing_rfm_eligibility,

    COUNTIF(clv_eligibility_status IS NULL)
        AS missing_clv_eligibility,

    COUNTIF(
        rfm_eligibility_status != clv_eligibility_status
    ) AS eligibility_mismatches,

    COUNTIF(
        historical_clv IS NULL
    ) AS missing_clv_records

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_360_analytics`;

-- Customer-level RFM and CLV inspection

SELECT
    customer_id,

    recency_days,
    frequency,
    monetary_value,

    rfm_score,
    rfm_score_total,
    customer_segment,

    total_orders,
    historical_clv,
    average_order_value,

    observed_purchase_span_days,
    historical_value_segment,

    rfm_eligibility_status,
    clv_eligibility_status

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_360_analytics`

ORDER BY historical_clv DESC
LIMIT 50;