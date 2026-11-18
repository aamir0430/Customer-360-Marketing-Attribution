SELECT
    attribution_model,
    touchpoint_source AS source,
    touchpoint_medium AS medium,
    touchpoint_campaign AS campaign,

    COUNT(DISTINCT transaction_id) AS attributed_transactions,

    SUM(attribution_credit) AS total_attribution_credit,

    SUM(attributed_revenue) AS total_attributed_revenue

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_attribution_comparison`

GROUP BY
    attribution_model,
    touchpoint_source,
    touchpoint_medium,
    touchpoint_campaign

ORDER BY
    attribution_model,
    total_attributed_revenue DESC;