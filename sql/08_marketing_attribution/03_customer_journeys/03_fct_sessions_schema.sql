SELECT
    column_name,
    data_type,
    ordinal_position

FROM
    `customer-360-mta.customer_360_dbt_dev.INFORMATION_SCHEMA.COLUMNS`

WHERE
    table_name = 'fct_sessions'

ORDER BY
    ordinal_position;