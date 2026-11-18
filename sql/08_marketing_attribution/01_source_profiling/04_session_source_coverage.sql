SELECT
    COUNT(*) AS total_sessions,

    COUNT(DISTINCT session_key) AS distinct_sessions,

    COUNT(DISTINCT customer_id) AS distinct_customers,

    COUNTIF(customer_id IS NULL) AS sessions_without_customer,

    COUNTIF(
        observed_event_source IS NOT NULL
        AND TRIM(observed_event_source) != ''
    ) AS sessions_with_observed_source,

    COUNTIF(
        observed_event_medium IS NOT NULL
        AND TRIM(observed_event_medium) != ''
    ) AS sessions_with_observed_medium,

    COUNTIF(
        observed_event_campaign IS NOT NULL
        AND TRIM(observed_event_campaign) != ''
    ) AS sessions_with_observed_campaign,

    COUNTIF(
        first_user_source IS NOT NULL
        AND TRIM(first_user_source) != ''
    ) AS sessions_with_first_user_source

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_sessions`;