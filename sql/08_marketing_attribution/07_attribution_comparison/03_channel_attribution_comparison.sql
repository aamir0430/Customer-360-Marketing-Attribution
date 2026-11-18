SELECT

    attribution_model,

    COALESCE(touchpoint_source, '(unknown)') AS source,

    COALESCE(touchpoint_medium, '(unknown)') AS medium,

    COUNT(DISTINCT transaction_id) AS influenced_conversions,

    SUM(attribution_credit) AS total_attribution_credit,

    SUM(attributed_revenue) AS attributed_revenue,

    SAFE_DIVIDE(
        SUM(attributed_revenue),

        SUM(SUM(attributed_revenue)) OVER (
            PARTITION BY attribution_model
        )
    ) * 100 AS revenue_share_percentage

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_attribution_comparison`

GROUP BY
    attribution_model,
    source,
    medium

ORDER BY
    attribution_model,
    attributed_revenue DESC;