SELECT
    'GA4 Sessions' AS table_name,
    COUNT(*) AS total_records
FROM
    `customer-360-mta.customer_360_raw.ga4_sessions`

UNION ALL

SELECT
    'CRM Customers',
    COUNT(*)
FROM
    `customer-360-mta.customer_360_raw.crm_customers`

UNION ALL

SELECT
    'Identity Mapping',
    COUNT(*)
FROM
    `customer-360-mta.customer_360_raw.identity_mapping`;