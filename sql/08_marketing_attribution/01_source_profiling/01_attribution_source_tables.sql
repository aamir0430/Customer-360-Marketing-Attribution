SELECT
    'customer_360_raw' AS dataset_name,
    table_name,
    table_type
FROM
    `customer-360-mta.customer_360_raw.INFORMATION_SCHEMA.TABLES`

UNION ALL

SELECT
    'customer_360_curated' AS dataset_name,
    table_name,
    table_type
FROM
    `customer-360-mta.customer_360_curated.INFORMATION_SCHEMA.TABLES`

UNION ALL

SELECT
    'customer_360_dbt_dev' AS dataset_name,
    table_name,
    table_type
FROM
    `customer-360-mta.customer_360_dbt_dev.INFORMATION_SCHEMA.TABLES`

ORDER BY
    dataset_name,
    table_name;