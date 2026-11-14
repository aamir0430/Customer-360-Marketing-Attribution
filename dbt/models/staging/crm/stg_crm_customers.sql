WITH source AS (

    SELECT *
    FROM {{ source('customer_360_raw', 'crm_customers') }}

),

renamed AS (

    SELECT

        -- Customer identifiers
        NULLIF(TRIM(customer_id), '') AS customer_id,
        NULLIF(TRIM(synthetic_user_id), '') AS synthetic_user_id,

        -- Customer details
        TRIM(first_name) AS first_name,
        TRIM(last_name) AS last_name,
        LOWER(TRIM(email)) AS email,

        -- Demographic information
        gender,
        city,
        country,

        -- Registration information
        registration_date,

        -- Customer classification
        customer_status,
        loyalty_tier,

        -- Data lineage
        data_origin

    FROM source

)

SELECT *
FROM renamed