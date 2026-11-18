SELECT
    campaign_id,
    COUNT(*) AS record_count

FROM {{ ref('fct_campaign_performance_summary') }}

GROUP BY campaign_id

HAVING COUNT(*) > 1