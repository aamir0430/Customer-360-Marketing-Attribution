{{ config(
    materialized = 'table'
) }}

WITH rfm_segmentation AS (

    SELECT
        customer_id,

        -- RFM dates
        analysis_date,
        first_purchase_date,
        last_purchase_date,

        -- RFM metrics
        recency_days,
        frequency,
        monetary_value,

        -- RFM scores
        recency_score,
        frequency_score,
        monetary_score,
        rfm_score,
        rfm_score_total,

        -- RFM eligibility and segmentation
        rfm_eligibility_status,
        customer_segment,
        segment_description,
        recommended_marketing_action

    FROM {{ ref('dim_customer_segments') }}

),

customer_clv AS (

    SELECT
        customer_id,

        -- Dataset period
        dataset_start_date,
        dataset_end_date,

        -- CLV metrics
        total_orders,
        historical_clv,
        average_order_value,

        -- Rename to reflect the actual metric
        customer_lifespan_days AS observed_purchase_span_days,

        -- Historical customer value segmentation
        customer_value_percentile,
        historical_value_segment,

        -- CLV eligibility
        clv_eligibility_status

    FROM {{ ref('fct_customer_clv') }}

),

customer_360 AS (

    SELECT
        r.customer_id,

        -- RFM dates
        r.analysis_date,
        r.first_purchase_date,
        r.last_purchase_date,

        -- RFM metrics
        r.recency_days,
        r.frequency,
        r.monetary_value,

        -- RFM scores
        r.recency_score,
        r.frequency_score,
        r.monetary_score,
        r.rfm_score,
        r.rfm_score_total,

        -- RFM segmentation
        r.rfm_eligibility_status,
        r.customer_segment,
        r.segment_description,
        r.recommended_marketing_action,

        -- CLV dataset period
        c.dataset_start_date,
        c.dataset_end_date,

        -- Historical CLV metrics
        c.total_orders,
        c.historical_clv,
        c.average_order_value,
        c.observed_purchase_span_days,

        -- Historical value segmentation
        c.customer_value_percentile,
        c.historical_value_segment,

        -- CLV eligibility
        c.clv_eligibility_status

    FROM rfm_segmentation r

    LEFT JOIN customer_clv c
        ON r.customer_id = c.customer_id

)

SELECT *
FROM customer_360