SELECT

    (SELECT COUNT(*)
     FROM `customer-360-mta.customer_360_dbt_dev.fct_sessions`
    ) AS source_session_count,

    (SELECT COUNT(*)
     FROM `customer-360-mta.customer_360_dbt_dev.fct_marketing_touchpoints`
    ) AS touchpoint_count,

    (SELECT COUNT(DISTINCT session_key)
     FROM `customer-360-mta.customer_360_dbt_dev.fct_marketing_touchpoints`
    ) AS distinct_touchpoints;