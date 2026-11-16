-- Overall Customer Segment Distribution

SELECT

    customer_segment,

    COUNT(*) AS customer_count,

    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS customer_percentage,

    SUM(monetary_value) AS total_revenue,

    AVG(monetary_value) AS average_customer_revenue

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_segments`

GROUP BY customer_segment

ORDER BY customer_count DESC;

-- Customer population reconciliation

SELECT

    COUNT(*) AS total_customers,

    COUNT(DISTINCT customer_id) AS distinct_customers,

    COUNTIF(customer_segment = 'No Purchase')
        AS non_purchasing_customers,

    COUNTIF(customer_segment != 'No Purchase')
        AS purchasing_customers,

    COUNTIF(customer_segment = 'Unclassified')
        AS unclassified_customers

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_segments`;

-- Segment revenue contribution

-- Query 3: Segment revenue contribution

WITH segment_metrics AS (

    SELECT

        customer_segment,

        COUNT(*) AS customer_count,

        SUM(monetary_value) AS total_segment_revenue

    FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_segments`

    GROUP BY customer_segment

)

SELECT

    customer_segment,

    customer_count,

    total_segment_revenue,

    ROUND(
        SAFE_DIVIDE(
            total_segment_revenue,
            SUM(total_segment_revenue) OVER ()
        ) * 100,
        2
    ) AS revenue_contribution_percentage

FROM segment_metrics

ORDER BY total_segment_revenue DESC;

-- Inspect Champions and Loyal Customers

SELECT

    customer_id,

    customer_segment,

    recency_days,

    frequency,

    monetary_value,

    rfm_score,

    rfm_score_total,

    recommended_marketing_action

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_segments`

WHERE customer_segment IN (
    'Champions',
    'Loyal Customers'
)

ORDER BY
    rfm_score_total DESC,
    monetary_value DESC

LIMIT 50;

-- Inspect At Risk, Hibernating, and Lost Customers

SELECT

    customer_id,

    customer_segment,

    recency_days,

    frequency,

    monetary_value,

    rfm_score,

    recommended_marketing_action

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_segments`

WHERE customer_segment IN (
    'Cannot Lose Them',
    'At Risk',
    'Hibernating',
    'Lost'
)

ORDER BY
    recency_days DESC,
    monetary_value DESC

LIMIT 100;

-- Validate segment assignment rules

SELECT

    COUNTIF(customer_segment IS NULL)
        AS null_segments,

    COUNTIF(customer_segment = 'Unclassified')
        AS unclassified_customers,

    COUNTIF(
        customer_segment = 'No Purchase'
        AND (
            rfm_eligibility_status != 'NO_PURCHASE'
            OR frequency != 0
            OR monetary_value != 0
            OR recency_days IS NOT NULL
        )
    ) AS invalid_non_purchaser_segments,

    COUNTIF(
        customer_segment != 'No Purchase'
        AND rfm_eligibility_status != 'PURCHASER'
    ) AS invalid_purchaser_segments,

    COUNTIF(
        recommended_marketing_action IS NULL
    ) AS missing_marketing_actions

FROM `customer-360-mta.customer_360_dbt_dev.dim_customer_segments`;