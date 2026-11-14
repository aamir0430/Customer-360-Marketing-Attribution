SELECT
    table_schema,
    table_name,
    column_name,
    data_type,
    ordinal_position
FROM
    `customer-360-mta.customer_360_raw.INFORMATION_SCHEMA.COLUMNS`

UNION ALL

SELECT
    table_schema,
    table_name,
    column_name,
    data_type,
    ordinal_position
FROM
    `customer-360-mta.customer_360_curated.INFORMATION_SCHEMA.COLUMNS`

ORDER BY
    table_schema,
    table_name,
    ordinal_position;