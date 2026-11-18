SELECT
    reporting_category,
    data_source,
    COUNT(*) AS total_rows,
    SUM(total_ad_spend) AS total_ad_spend,
    SUM(total_attributed_revenue) AS total_attributed_revenue
FROM
    `customer-360-mta.customer_360_dbt_dev.fct_marketing_performance_reporting`
GROUP BY
    reporting_category,
    data_source
ORDER BY
    reporting_category;