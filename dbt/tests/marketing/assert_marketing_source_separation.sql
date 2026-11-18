SELECT *

FROM {{ ref('fct_marketing_performance_reporting') }}

WHERE

    (
        reporting_category = 'ADVERTISING_PERFORMANCE'
        AND (
            total_attributed_revenue IS NOT NULL
            OR attribution_model IS NOT NULL
        )
    )

    OR

    (
        reporting_category = 'GA4_ATTRIBUTION_PERFORMANCE'
        AND (
            total_ad_spend IS NOT NULL
            OR total_impressions IS NOT NULL
            OR total_clicks IS NOT NULL
        )
    )