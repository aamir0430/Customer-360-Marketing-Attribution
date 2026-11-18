SELECT
    attribution_model,
    SUM(attributed_transactions) AS channel_transaction_count,
    SUM(total_attribution_credit) AS total_attribution_credit,
    SUM(total_attributed_revenue) AS total_attributed_revenue
FROM
    `customer-360-mta.customer_360_dbt_dev.fct_marketing_performance_reporting`
WHERE
    reporting_category = 'GA4_ATTRIBUTION_PERFORMANCE'
GROUP BY
    attribution_model
ORDER BY
    attribution_model;