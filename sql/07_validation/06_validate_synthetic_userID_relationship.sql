SELECT
    COUNT(*) AS total_mapping_records,

    COUNTIF(
        im.synthetic_user_id = crm.synthetic_user_id
    ) AS matching_synthetic_user_ids,

    COUNTIF(
        im.synthetic_user_id != crm.synthetic_user_id
        OR crm.synthetic_user_id IS NULL
    ) AS mismatched_synthetic_user_ids

FROM `customer-360-mta.customer_360_raw.identity_mapping` im

LEFT JOIN `customer-360-mta.customer_360_raw.crm_customers` crm

ON im.customer_id = crm.customer_id;