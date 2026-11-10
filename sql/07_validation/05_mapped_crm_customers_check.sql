SELECT
    COUNT(DISTINCT im.customer_id) AS mapped_crm_customers,

    COUNT(DISTINCT crm.customer_id) AS customers_found_in_crm,

    COUNT(DISTINCT IF(
        crm.customer_id IS NULL,
        im.customer_id,
        NULL
    )) AS customers_not_found_in_crm

FROM `customer-360-mta.customer_360_raw.identity_mapping` im

LEFT JOIN `customer-360-mta.customer_360_raw.crm_customers` crm

ON im.customer_id = crm.customer_id;