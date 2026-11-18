SELECT DISTINCT

    touchpoint_source AS source,

    touchpoint_medium AS medium,

    touchpoint_campaign AS campaign

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_attribution_comparison`

ORDER BY
    source,
    medium,
    campaign;