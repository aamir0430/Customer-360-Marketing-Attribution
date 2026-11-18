SELECT
    attribution_model,
    SUM(total_attribution_credit) AS total_credit

FROM {{ ref('fct_marketing_performance_reporting') }}

WHERE reporting_category = 'GA4_ATTRIBUTION_PERFORMANCE'

GROUP BY attribution_model

HAVING ABS(SUM(total_attribution_credit) - 4452) > 0.000001