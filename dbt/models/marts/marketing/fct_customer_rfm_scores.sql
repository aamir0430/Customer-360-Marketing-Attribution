{{ config(
    materialized = 'table'
) }}

-- MODEL: fct_customer_rfm_scores
-- PURPOSE: Calculate customer-level RFM scores
-- GRAIN: One row per CRM customer
-- INPUT: fct_customer_rfm


-- 1. Retrieve customer RFM metrics

WITH customer_rfm AS (

    SELECT
        customer_id,
        analysis_date,
        first_purchase_date,
        last_purchase_date,
        recency_days,
        frequency,
        monetary_value,
        rfm_eligibility_status

    FROM {{ ref('fct_customer_rfm') }}

),


-- 2. Calculate percentile distributions
-- Only purchasing customers participate in scoring

rfm_percentiles AS (

    SELECT

        *,

        CUME_DIST() OVER (
            ORDER BY recency_days DESC
        ) AS recency_percentile,

        CUME_DIST() OVER (
            ORDER BY monetary_value ASC
        ) AS monetary_percentile

    FROM customer_rfm

    WHERE rfm_eligibility_status = 'PURCHASER'

),


-- 3. Assign RFM scores

scored_customers AS (

    SELECT

        c.customer_id,

        c.analysis_date,

        c.first_purchase_date,

        c.last_purchase_date,

        c.recency_days,

        c.frequency,

        c.monetary_value,

        c.rfm_eligibility_status,

        -- RECENCY SCORE
        CASE
            WHEN c.rfm_eligibility_status = 'NO_PURCHASE'
                THEN NULL

            WHEN p.recency_percentile <= 0.20 THEN 1
            WHEN p.recency_percentile <= 0.40 THEN 2
            WHEN p.recency_percentile <= 0.60 THEN 3
            WHEN p.recency_percentile <= 0.80 THEN 4
            ELSE 5
        END AS recency_score,


        -- FREQUENCY SCORE
        CASE
            WHEN c.rfm_eligibility_status = 'NO_PURCHASE'
                THEN NULL

            WHEN c.frequency = 1 THEN 1
            WHEN c.frequency = 2 THEN 2
            WHEN c.frequency = 3 THEN 3
            WHEN c.frequency BETWEEN 4 AND 5 THEN 4
            WHEN c.frequency >= 6 THEN 5
            ELSE NULL
        END AS frequency_score,


        -- MONETARY SCORE
        CASE
            WHEN c.rfm_eligibility_status = 'NO_PURCHASE'
                THEN NULL

            WHEN p.monetary_percentile <= 0.20 THEN 1
            WHEN p.monetary_percentile <= 0.40 THEN 2
            WHEN p.monetary_percentile <= 0.60 THEN 3
            WHEN p.monetary_percentile <= 0.80 THEN 4
            ELSE 5
        END AS monetary_score

    FROM customer_rfm c

    LEFT JOIN rfm_percentiles p

        ON c.customer_id = p.customer_id

),


-- 4. Generate combined RFM scores

final_scores AS (

    SELECT

        *,

        CASE
            WHEN rfm_eligibility_status = 'PURCHASER'
            THEN CONCAT(
                CAST(recency_score AS STRING),
                CAST(frequency_score AS STRING),
                CAST(monetary_score AS STRING)
            )
            ELSE NULL
        END AS rfm_score,

        CASE
            WHEN rfm_eligibility_status = 'PURCHASER'
            THEN
                recency_score
                + frequency_score
                + monetary_score
            ELSE NULL
        END AS rfm_score_total

    FROM scored_customers

)


-- 5. Final output

SELECT *

FROM final_scores