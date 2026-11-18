SELECT
    campaign_id,
    campaign_date,
    COUNT(*) AS record_count

FROM {{ ref('fct_ad_spend_performance') }}

GROUP BY
    campaign_id,
    campaign_date

HAVING COUNT(*) > 1