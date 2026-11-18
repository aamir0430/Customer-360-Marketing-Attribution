SELECT

    attribution_model,

    COUNT(*) AS attribution_rows,

    COUNT(DISTINCT transaction_id) AS conversions,

    SUM(attribution_credit) AS total_attribution_credit,

    SUM(attributed_revenue) AS attributed_revenue,

    AVG(attribution_credit) AS average_touchpoint_credit

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_attribution_comparison`

GROUP BY
    attribution_model

ORDER BY
    attributed_revenue DESC;