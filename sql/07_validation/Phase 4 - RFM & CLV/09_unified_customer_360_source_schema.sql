SELECT
    table_name,
    column_name,
    data_type,
    ordinal_position
FROM
    `customer-360-mta.customer_360_dbt_dev.INFORMATION_SCHEMA.COLUMNS`
WHERE
    table_name IN (
        'fct_customer_rfm',
        'fct_customer_rfm_scores',
        'dim_customer_segments',
        'fct_customer_clv'
    )
ORDER BY
    table_name,
    ordinal_position;