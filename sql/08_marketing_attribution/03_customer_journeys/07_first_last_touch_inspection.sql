SELECT

    transaction_id,

    journey_id,

    order_revenue_usd,

    eligible_touchpoint_count,

    MAX(
        CASE
            WHEN first_touch_rank = 1
            THEN touchpoint_source
        END
    ) AS first_touch_source,

    MAX(
        CASE
            WHEN first_touch_rank = 1
            THEN touchpoint_medium
        END
    ) AS first_touch_medium,

    MAX(
        CASE
            WHEN last_touch_rank = 1
            THEN touchpoint_source
        END
    ) AS last_touch_source,

    MAX(
        CASE
            WHEN last_touch_rank = 1
            THEN touchpoint_medium
        END
    ) AS last_touch_medium

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_conversion_journeys`

GROUP BY
    transaction_id,
    journey_id,
    order_revenue_usd,
    eligible_touchpoint_count

ORDER BY
    transaction_id

LIMIT 100;