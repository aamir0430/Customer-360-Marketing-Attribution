WITH source AS (

    SELECT *
    FROM {{ source('customer_360_curated', 'identity_resolved_sessions') }}

),

renamed AS (

    SELECT

        -- GA4 identifiers
        NULLIF(TRIM(user_pseudo_id), '') AS user_pseudo_id,
        NULLIF(TRIM(ga_session_id), '') AS ga_session_id,

        -- Session information
        session_event_date,
        session_first_event_timestamp_utc,
        events_in_session,
        purchase_events,

        -- Traffic acquisition
        observed_event_source,
        observed_event_medium,
        observed_event_campaign,

        first_user_source,
        first_user_medium,
        first_user_campaign,

        -- Identity information
        NULLIF(TRIM(synthetic_user_id), '') AS synthetic_user_id,
        NULLIF(TRIM(customer_id), '') AS customer_id,
        match_method,
        mapping_is_synthetic,
        ga4_purchase_events_at_export,
        ga4_first_seen_date,

        -- CRM customer information
        first_name,
        last_name,
        LOWER(TRIM(email)) AS email,
        gender,
        city,
        country,
        registration_date,
        customer_status,
        loyalty_tier,
        crm_data_origin,

        -- Identity resolution status
        identity_resolution_status

    FROM source

)

SELECT *
FROM renamed