WITH advertising_sources AS (

    SELECT DISTINCT

        LOWER(TRIM(source)) AS source,

        LOWER(TRIM(medium)) AS medium

    FROM
        `customer-360-mta.customer_360_raw.ad_spend_unpartitioned`

),

attribution_sources AS (

    SELECT DISTINCT

        LOWER(TRIM(touchpoint_source)) AS source,

        LOWER(TRIM(touchpoint_medium)) AS medium

    FROM
        `customer-360-mta.customer_360_dbt_dev.fct_attribution_comparison`

)

SELECT

    a.source AS advertising_source,

    a.medium AS advertising_medium,

    t.source AS attribution_source,

    t.medium AS attribution_medium,

    CASE

        WHEN t.source IS NOT NULL
            THEN 'MATCH'

        ELSE 'NO MATCH'

    END AS mapping_status

FROM advertising_sources a

LEFT JOIN attribution_sources t

    ON a.source = t.source
    AND a.medium = t.medium

ORDER BY
    mapping_status,
    advertising_source,
    advertising_medium;