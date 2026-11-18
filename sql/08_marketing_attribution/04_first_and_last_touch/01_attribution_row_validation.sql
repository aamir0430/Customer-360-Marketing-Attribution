SELECT
    attribution_model,

    COUNT(*) AS attributed_transactions,

    COUNT(DISTINCT transaction_id) AS distinct_transactions,

    SUM(attribution_credit) AS total_attribution_credit,

    SUM(attributed_revenue) AS total_attributed_revenue

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_first_last_touch_attribution`

GROUP BY
    attribution_model

ORDER BY
    attribution_model;