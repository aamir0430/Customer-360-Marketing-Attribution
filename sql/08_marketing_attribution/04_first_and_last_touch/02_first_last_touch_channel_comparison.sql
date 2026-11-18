SELECT
    attribution_model,

    COALESCE(touchpoint_source, '(unknown)') AS source,

    COALESCE(touchpoint_medium, '(unknown)') AS medium,

    COUNT(DISTINCT transaction_id) AS conversions,

    SUM(attribution_credit) AS total_credit,

    SUM(attributed_revenue) AS attributed_revenue

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_first_last_touch_attribution`

GROUP BY
    attribution_model,
    source,
    medium

ORDER BY
    attribution_model,
    attributed_revenue DESC;