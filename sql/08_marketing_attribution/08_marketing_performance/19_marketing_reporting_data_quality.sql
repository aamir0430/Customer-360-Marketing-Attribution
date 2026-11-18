SELECT *
FROM
    `customer-360-mta.customer_360_dbt_dev.fct_marketing_performance_reporting`
WHERE
    reporting_category IS NULL
    OR data_source IS NULL

    OR (
        reporting_category = 'ADVERTISING_PERFORMANCE'
        AND (
            campaign_id IS NULL
            OR total_ad_spend IS NULL
            OR total_impressions IS NULL
            OR total_clicks IS NULL
        )
    )

    OR (
        reporting_category = 'GA4_ATTRIBUTION_PERFORMANCE'
        AND (
            attribution_model IS NULL
            OR total_attributed_revenue IS NULL
            OR total_attribution_credit IS NULL
        )
    );