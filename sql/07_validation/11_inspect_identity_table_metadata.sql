SELECT
    table_catalog,
    table_schema,
    table_name,
    creation_time,
    ddl
FROM
    `customer-360-mta.customer_360_curated.INFORMATION_SCHEMA.TABLES`
WHERE
    table_name = 'identity_resolved_sessions';