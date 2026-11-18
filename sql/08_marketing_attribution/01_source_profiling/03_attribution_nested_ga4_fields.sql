SELECT
    table_name,
    column_name,
    field_path,
    data_type
FROM
    `customer-360-mta.customer_360_raw.INFORMATION_SCHEMA.COLUMN_FIELD_PATHS`
WHERE
    table_name = 'ga4_events'
ORDER BY
    field_path;