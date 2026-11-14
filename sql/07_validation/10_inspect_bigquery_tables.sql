SELECT
    table_schema,
    table_name,
    table_type
FROM
    `customer-360-mta.customer_360_raw.INFORMATION_SCHEMA.TABLES`

UNION ALL

SELECT
    table_schema,
    table_name,
    table_type
FROM
    `customer-360-mta.customer_360_curated.INFORMATION_SCHEMA.TABLES`

ORDER BY
    table_schema,
    table_name;