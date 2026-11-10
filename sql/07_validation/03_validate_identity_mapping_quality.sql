/*
Project: Customer 360 and Marketing Attribution
Phase: 2 - Identity Resolution
Step: 2.2 - Examine Identity Mapping

Purpose:
Validate identity mapping quality by checking:
1. Total mapping records
2. Unique identifiers
3. Null identifiers
4. Synthetic and non-synthetic mappings

Source:
customer_360_raw.identity_mapping
*/

SELECT
    COUNT(*) AS total_mappings,

    COUNT(DISTINCT user_pseudo_id)
        AS unique_ga4_users,

    COUNT(DISTINCT synthetic_user_id)
        AS unique_synthetic_user_ids,

    COUNT(DISTINCT customer_id)
        AS unique_crm_customers,

    COUNTIF(user_pseudo_id IS NULL)
        AS null_ga4_user_ids,

    COUNTIF(synthetic_user_id IS NULL)
        AS null_synthetic_user_ids,

    COUNTIF(customer_id IS NULL)
        AS null_customer_ids,

    COUNTIF(mapping_is_synthetic = TRUE)
        AS synthetic_mappings,

    COUNTIF(mapping_is_synthetic = FALSE)
        AS non_synthetic_mappings

FROM `customer-360-mta.customer_360_raw.identity_mapping`;