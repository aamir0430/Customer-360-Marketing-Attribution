SELECT
    COUNT(*) AS total_sessions,
    COUNT(DISTINCT session_key) AS unique_session_keys,
    COUNT(DISTINCT user_pseudo_id) AS unique_users,
    COUNTIF(customer_id IS NOT NULL) AS identified_sessions,
    COUNTIF(customer_id IS NULL) AS unidentified_sessions,
    COUNTIF(mapping_is_synthetic = TRUE) AS synthetic_mapped_sessions
FROM
    `customer-360-mta.customer_360_dbt_dev.fct_sessions`;