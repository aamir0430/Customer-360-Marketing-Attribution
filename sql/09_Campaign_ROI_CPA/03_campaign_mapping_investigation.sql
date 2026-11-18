-- PHASE 6: CAMPAIGN-TO-GA4 MAPPING INVESTIGATION
-- Purpose: Identify reliable campaign revenue mappings

WITH ad_campaigns AS (

    SELECT DISTINCT
        campaign_id,
        campaign_name,
        source,
        medium,
        channel,
        currency,
        total_ad_spend

    FROM
        `customer-360-mta.customer_360_dbt_dev.fct_campaign_performance_summary`

),

ga4_attribution AS (

    SELECT

        touchpoint_source,
        touchpoint_medium,
        touchpoint_campaign,
        attribution_model,

        COUNT(DISTINCT transaction_id)
            AS attributed_transactions,

        ROUND(SUM(attributed_revenue), 2)
            AS attributed_revenue,

        ROUND(SUM(attribution_credit), 4)
            AS total_attribution_credit

    FROM
        `customer-360-mta.customer_360_dbt_dev.fct_attribution_comparison`

    GROUP BY
        touchpoint_source,
        touchpoint_medium,
        touchpoint_campaign,
        attribution_model

)

SELECT

    a.campaign_id,
    a.campaign_name,

    a.source AS ad_source,
    a.medium AS ad_medium,
    a.channel AS ad_channel,

    a.currency,
    a.total_ad_spend,

    g.touchpoint_source AS ga4_source,
    g.touchpoint_medium AS ga4_medium,
    g.touchpoint_campaign AS ga4_campaign,

    g.attribution_model,

    g.attributed_transactions,
    g.attributed_revenue,
    g.total_attribution_credit,

    CASE

        WHEN LOWER(TRIM(a.campaign_id))
             = LOWER(TRIM(g.touchpoint_campaign))
        THEN 'EXACT_CAMPAIGN_ID_MATCH'

        WHEN LOWER(TRIM(a.campaign_name))
             = LOWER(TRIM(g.touchpoint_campaign))
        THEN 'EXACT_CAMPAIGN_NAME_MATCH'

        WHEN g.touchpoint_campaign IS NOT NULL
        THEN 'SOURCE_MEDIUM_MATCH_ONLY'

        ELSE 'NO_VERIFIED_MAPPING'

    END AS mapping_status

FROM ad_campaigns a

LEFT JOIN ga4_attribution g

    ON LOWER(TRIM(a.source))
       = LOWER(TRIM(g.touchpoint_source))

    AND LOWER(TRIM(a.medium))
       = LOWER(TRIM(g.touchpoint_medium))

ORDER BY

    a.campaign_id,
    g.attribution_model,
    g.touchpoint_campaign;