WITH channel_revenue AS (

    SELECT

        attribution_model,

        COALESCE(touchpoint_source, '(unknown)') AS source,

        COALESCE(touchpoint_medium, '(unknown)') AS medium,

        SUM(attributed_revenue) AS attributed_revenue

    FROM
        `customer-360-mta.customer_360_dbt_dev.fct_attribution_comparison`

    GROUP BY
        attribution_model,
        source,
        medium

)

SELECT

    attribution_model,

    source,
    medium,

    attributed_revenue,

    RANK() OVER (

        PARTITION BY attribution_model

        ORDER BY attributed_revenue DESC

    ) AS channel_rank

FROM channel_revenue

ORDER BY
    attribution_model,
    channel_rank;