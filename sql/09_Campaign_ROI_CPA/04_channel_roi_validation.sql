WITH channel_roi AS (

    SELECT *
    FROM `customer-360-mta.customer_360_dbt_dev.fct_channel_roi`

),

campaign_summary AS (

    SELECT
        LOWER(TRIM(source)) AS source,
        LOWER(TRIM(medium)) AS medium,

        COUNT(DISTINCT campaign_id) AS source_campaign_count,

        SUM(total_ad_spend) AS source_ad_spend

    FROM
        `customer-360-mta.customer_360_dbt_dev.fct_campaign_performance_summary`

    GROUP BY 1, 2

)

SELECT

    r.source,
    r.medium,
    r.channel,
    r.attribution_model,

    r.campaigns_included,
    r.total_ad_spend,

    r.attributed_transactions,
    r.attribution_credit,
    r.attributed_revenue,

    ROUND(r.attributed_cpa, 2) AS attributed_cpa,
    ROUND(r.roas, 4) AS roas,
    ROUND(r.roi_percentage, 2) AS roi_percentage,

    r.mapping_status,

    c.source_campaign_count,

    ROUND(
        r.total_ad_spend - c.source_ad_spend,
        2
    ) AS spend_reconciliation_difference,

    CASE

        WHEN r.mapping_status = 'SOURCE_MEDIUM_MATCH'
             AND r.attributed_revenue IS NOT NULL
             AND r.attributed_cpa IS NOT NULL
             AND r.roas IS NOT NULL
             AND r.roi_percentage IS NOT NULL
        THEN 'PASS'

        WHEN r.mapping_status = 'NO_VERIFIED_MAPPING'
             AND r.attributed_revenue IS NULL
        THEN 'PASS - UNMAPPED'

        ELSE 'REVIEW'

    END AS validation_status

FROM channel_roi r

LEFT JOIN campaign_summary c

    ON r.source = c.source
    AND r.medium = c.medium

ORDER BY
    r.source,
    r.medium,
    r.attribution_model;