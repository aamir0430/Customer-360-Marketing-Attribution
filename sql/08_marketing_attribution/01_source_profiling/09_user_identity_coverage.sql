SELECT
    COUNT(*) AS total_sessions,

    COUNTIF(user_pseudo_id IS NOT NULL) AS sessions_with_user_pseudo_id,

    COUNTIF(user_pseudo_id IS NULL) AS sessions_without_user_pseudo_id,

    COUNT(DISTINCT user_pseudo_id) AS distinct_ga4_users,

    COUNT(DISTINCT customer_id) AS distinct_crm_customers,

    COUNT(DISTINCT CASE
        WHEN customer_id IS NOT NULL
        THEN user_pseudo_id
    END) AS identified_ga4_users,

    COUNT(DISTINCT CASE
        WHEN customer_id IS NULL
        THEN user_pseudo_id
    END) AS unresolved_ga4_users

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_sessions`;