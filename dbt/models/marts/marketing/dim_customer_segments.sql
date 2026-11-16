{{ config(materialized='table') }}

-- MODEL: dim_customer_segments
-- PURPOSE: RFM-based customer segmentation
-- GRAIN: One row per CRM customer
-- SOURCE: fct_customer_rfm_scores

WITH customer_rfm AS (

    SELECT
        customer_id,
        analysis_date,
        first_purchase_date,
        last_purchase_date,
        recency_days,
        frequency,
        monetary_value,
        recency_score,
        frequency_score,
        monetary_score,
        rfm_score,
        rfm_score_total,
        rfm_eligibility_status

    FROM {{ ref('fct_customer_rfm_scores') }}

),

-- CUSTOMER SEGMENT ASSIGNMENT

customer_segments AS (

    SELECT
        *,

        CASE

            WHEN rfm_eligibility_status = 'NO_PURCHASE'
                THEN 'No Purchase'

            WHEN recency_score >= 4
                AND frequency_score >= 4
                AND monetary_score >= 4
                THEN 'Champions'

            WHEN recency_score >= 3
                AND frequency_score >= 4
                THEN 'Loyal Customers'

            WHEN recency_score >= 4
                AND frequency_score BETWEEN 2 AND 3
                THEN 'Potential Loyalists'

            WHEN recency_score = 5
                AND frequency_score = 1
                THEN 'Recent Customers'

            WHEN recency_score = 4
                AND frequency_score = 1
                THEN 'Promising Customers'

            WHEN recency_score = 3
                AND frequency_score <= 3
                THEN 'Customers Needing Attention'

            WHEN recency_score <= 2
                AND frequency_score >= 4
                AND monetary_score >= 4
                THEN 'Cannot Lose Them'

            WHEN recency_score <= 2
                AND frequency_score >= 3
                THEN 'At Risk'

            WHEN recency_score = 1
                AND frequency_score = 1
                THEN 'Lost'

            WHEN recency_score <= 2
                AND frequency_score <= 2
                THEN 'Hibernating'

            ELSE 'Unclassified'

        END AS customer_segment

    FROM customer_rfm

),

-- SEGMENT DESCRIPTIONS

segment_descriptions AS (

    SELECT
        *,

        CASE customer_segment

            WHEN 'Champions'
                THEN 'Customers with excellent recency, frequency and monetary scores.'

            WHEN 'Loyal Customers'
                THEN 'Customers demonstrating strong repeat purchasing behaviour.'

            WHEN 'Potential Loyalists'
                THEN 'Recently active customers with repeat purchase potential.'

            WHEN 'Recent Customers'
                THEN 'Customers who have made a recent first identified purchase.'

            WHEN 'Promising Customers'
                THEN 'Recent one-time purchasers with potential for growth.'

            WHEN 'Customers Needing Attention'
                THEN 'Customers who may benefit from targeted engagement campaigns.'

            WHEN 'Cannot Lose Them'
                THEN 'Previously frequent and high-value customers who have become inactive.'

            WHEN 'At Risk'
                THEN 'Previously frequent customers showing signs of inactivity.'

            WHEN 'Hibernating'
                THEN 'Inactive customers with limited purchase frequency.'

            WHEN 'Lost'
                THEN 'Long-inactive customers with only one identified purchase.'

            WHEN 'No Purchase'
                THEN 'CRM customers without identified purchase transactions.'

            ELSE 'Customer requires further classification.'

        END AS segment_description

    FROM customer_segments

)

-- FINAL CUSTOMER SEGMENT OUTPUT

SELECT

    customer_id,
    analysis_date,
    first_purchase_date,
    last_purchase_date,

    recency_days,
    frequency,
    monetary_value,

    recency_score,
    frequency_score,
    monetary_score,

    rfm_score,
    rfm_score_total,

    rfm_eligibility_status,

    customer_segment,
    segment_description,

    CASE customer_segment

        WHEN 'Champions'
            THEN 'Reward loyalty, provide VIP benefits and encourage referrals.'

        WHEN 'Loyal Customers'
            THEN 'Introduce loyalty rewards, membership benefits and upselling.'

        WHEN 'Potential Loyalists'
            THEN 'Encourage repeat purchases through personalized recommendations.'

        WHEN 'Recent Customers'
            THEN 'Run welcome campaigns and encourage a second purchase.'

        WHEN 'Promising Customers'
            THEN 'Use product recommendations and targeted promotional offers.'

        WHEN 'Customers Needing Attention'
            THEN 'Use personalized engagement campaigns and relevant incentives.'

        WHEN 'Cannot Lose Them'
            THEN 'Prioritize retention through personalized win-back campaigns.'

        WHEN 'At Risk'
            THEN 'Launch reactivation campaigns and investigate inactivity.'

        WHEN 'Hibernating'
            THEN 'Use targeted re-engagement campaigns with relevant offers.'

        WHEN 'Lost'
            THEN 'Test low-cost win-back campaigns before further investment.'

        WHEN 'No Purchase'
            THEN 'Use acquisition and conversion campaigns to encourage a first purchase.'

        ELSE 'Review customer data and classification rules.'

    END AS recommended_marketing_action

FROM segment_descriptions