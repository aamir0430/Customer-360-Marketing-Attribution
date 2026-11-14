WITH source AS (

    SELECT *
    FROM {{ source('customer_360_raw', 'ga4_sessions') }}

),

renamed AS (

    SELECT

        -- Identifiers
        NULLIF(TRIM(user_pseudo_id), '') AS user_pseudo_id,
        NULLIF(TRIM(ga_session_id), '') AS ga_session_id,

        -- Session information
        session_event_date,
        session_first_event_timestamp_utc,

        -- Engagement metrics
        events_in_session,
        purchase_events,

        -- Session acquisition information
        NULLIF(TRIM(observed_event_source), '') AS observed_event_source,
        NULLIF(TRIM(observed_event_medium), '') AS observed_event_medium,
        NULLIF(TRIM(observed_event_campaign), '') AS observed_event_campaign,

        -- First user acquisition information
        NULLIF(TRIM(first_user_source), '') AS first_user_source,
        NULLIF(TRIM(first_user_medium), '') AS first_user_medium,
        NULLIF(TRIM(first_user_campaign), '') AS first_user_campaign

    FROM source

)

SELECT *
FROM renamed