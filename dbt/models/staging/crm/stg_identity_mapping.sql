WITH source AS (

    SELECT *
    FROM {{ source('customer_360_raw', 'identity_mapping') }}

),

renamed AS (

    SELECT

        -- Identifiers
        NULLIF(TRIM(user_pseudo_id), '') AS user_pseudo_id,
        NULLIF(TRIM(synthetic_user_id), '') AS synthetic_user_id,
        NULLIF(TRIM(customer_id), '') AS customer_id,

        -- Mapping information
        match_method,
        mapping_is_synthetic,

        -- GA4 historical information
        ga4_purchase_events_at_export,
        ga4_first_seen_date

    FROM source

)

SELECT *
FROM renamed