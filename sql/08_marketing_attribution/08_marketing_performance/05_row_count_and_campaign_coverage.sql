SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT campaign_id) AS distinct_campaigns,
    COUNT(DISTINCT campaign_date) AS distinct_campaign_dates,
    MIN(campaign_date) AS first_date,
    MAX(campaign_date) AS last_date
FROM
    `customer-360-mta.customer_360_dbt_dev.fct_ad_spend_performance`;