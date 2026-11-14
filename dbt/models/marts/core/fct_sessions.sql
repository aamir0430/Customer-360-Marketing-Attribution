WITH sessions AS (

    SELECT *
    FROM {{ ref('stg_identity_resolved_sessions') }}

),

final AS (

    SELECT

        -- Session key
        TO_HEX(
            MD5(
                CONCAT(
                    COALESCE(user_pseudo_id, ''),
                    '|',
                    COALESCE(ga_session_id, '')
                )
            )
        ) AS session_key,

        -- GA4 identifiers
        user_pseudo_id,
        ga_session_id,

        -- Customer identification
        customer_id,
        synthetic_user_id,
        match_method,
        mapping_is_synthetic,
        identity_resolution_status,

        -- Session information
        session_event_date AS session_date,
        session_first_event_timestamp_utc,
        events_in_session,
        purchase_events,

        -- Observed traffic acquisition
        observed_event_source,
        observed_event_medium,
        observed_event_campaign,

        -- First user acquisition
        first_user_source,
        first_user_medium,
        first_user_campaign

    FROM sessions

)

SELECT *
FROM final