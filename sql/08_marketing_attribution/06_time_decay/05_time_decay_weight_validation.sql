SELECT

    days_before_conversion,

    COUNT(*) AS touchpoint_count,

    AVG(initial_decay_weight) AS average_initial_weight,

    AVG(attribution_credit) AS average_attribution_credit

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_time_decay_attribution`

GROUP BY
    days_before_conversion

ORDER BY
    days_before_conversion;