SELECT

    COALESCE(touchpoint_source, '(unknown)') AS source,

    COALESCE(touchpoint_medium, '(unknown)') AS medium,

    COUNT(DISTINCT transaction_id) AS influenced_conversions,

    SUM(attribution_credit) AS total_attribution_credit,

    SUM(attributed_revenue) AS attributed_revenue,

    AVG(attribution_credit) AS average_touchpoint_credit

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_linear_attribution`

GROUP BY
    source,
    medium

ORDER BY
    attributed_revenue DESC;