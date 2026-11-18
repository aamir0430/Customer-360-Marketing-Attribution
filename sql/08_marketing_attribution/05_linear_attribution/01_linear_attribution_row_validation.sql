SELECT

    COUNT(*) AS attribution_rows,

    COUNT(DISTINCT transaction_id) AS distinct_transactions,

    COUNT(DISTINCT touchpoint_session_key) AS distinct_touchpoint_sessions,

    SUM(attribution_credit) AS total_attribution_credit,

    SUM(attributed_revenue) AS total_attributed_revenue,

    COUNTIF(attribution_credit IS NULL) AS null_credits,

    COUNTIF(attributed_revenue IS NULL) AS null_attributed_revenue

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_linear_attribution`;