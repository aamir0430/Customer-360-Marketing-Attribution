-- Customer population and score availability

SELECT
    COUNT(*) AS total_customers,

    COUNTIF(
        rfm_eligibility_status = 'PURCHASER'
    ) AS purchasing_customers,

    COUNTIF(
        rfm_eligibility_status = 'NO_PURCHASE'
    ) AS non_purchasing_customers,

    COUNTIF(rfm_score IS NOT NULL) AS scored_customers,

    COUNTIF(rfm_score IS NULL) AS unscored_customers

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm_scores`;

-- Score distribution

SELECT

    recency_score,
    frequency_score,
    monetary_score,

    COUNT(*) AS customer_count

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm_scores`

WHERE rfm_eligibility_status = 'PURCHASER'

GROUP BY
    recency_score,
    frequency_score,
    monetary_score

ORDER BY
    recency_score,
    frequency_score,
    monetary_score;

-- Combined RFM score distribution

SELECT

    rfm_score,
    rfm_score_total,

    COUNT(*) AS customer_count

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm_scores`

WHERE rfm_score IS NOT NULL

GROUP BY
    rfm_score,
    rfm_score_total

ORDER BY
    rfm_score_total DESC,
    rfm_score DESC;

-- Top 20 customers by combined RFM score

SELECT

    customer_id,

    recency_days,
    frequency,
    monetary_value,

    recency_score,
    frequency_score,
    monetary_score,

    rfm_score,
    rfm_score_total

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm_scores`

WHERE rfm_eligibility_status = 'PURCHASER'

ORDER BY
    rfm_score_total DESC,
    rfm_score DESC,
    monetary_value DESC

LIMIT 20;

-- Validate scoring rules

SELECT

    COUNTIF(
        rfm_eligibility_status = 'PURCHASER'
        AND (
            recency_score NOT BETWEEN 1 AND 5
            OR frequency_score NOT BETWEEN 1 AND 5
            OR monetary_score NOT BETWEEN 1 AND 5
        )
    ) AS invalid_purchaser_scores,

    COUNTIF(
        rfm_eligibility_status = 'NO_PURCHASE'
        AND (
            recency_score IS NOT NULL
            OR frequency_score IS NOT NULL
            OR monetary_score IS NOT NULL
            OR rfm_score IS NOT NULL
            OR rfm_score_total IS NOT NULL
        )
    ) AS invalid_non_purchaser_scores,

    COUNTIF(
        rfm_score_total < 3 OR rfm_score_total > 15
    ) AS invalid_total_scores,

    COUNTIF(
        LENGTH(rfm_score) != 3
    ) AS invalid_rfm_score_format

FROM `customer-360-mta.customer_360_dbt_dev.fct_customer_rfm_scores`;