SELECT
    'customer_360_raw' AS dataset_name,
    table_name,
    column_name,
    data_type,
    ordinal_position
FROM
    `customer-360-mta.customer_360_raw.INFORMATION_SCHEMA.COLUMNS`

UNION ALL

SELECT
    'customer_360_curated' AS dataset_name,
    table_name,
    column_name,
    data_type,
    ordinal_position
FROM
    `customer-360-mta.customer_360_curated.INFORMATION_SCHEMA.COLUMNS`

UNION ALL

SELECT
    'customer_360_dbt_dev' AS dataset_name,
    table_name,
    column_name,
    data_type,
    ordinal_position
FROM
    `customer-360-mta.customer_360_dbt_dev.INFORMATION_SCHEMA.COLUMNS`

ORDER BY
    dataset_name,
    table_name,
    ordinal_position;