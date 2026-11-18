{{ config(
    materialized = 'table'
) }}

WITH sessions AS (

    SELECT
        session_key,
        user_pseudo_id,
        ga_session_id,
        customer_id,
        session_date,

        events_in_session,
        purchase_events,

        observed_event_source,
        observed_event_medium,
        observed_event_campaign,

        first_user_source,
        first_user_medium,
        first_user_campaign

    FROM {{ ref('fct_sessions') }}

),

touchpoints AS (

    SELECT

        -- Session identification
        session_key,
        user_pseudo_id,
        ga_session_id,
        session_date,

        -- Customer identification
        customer_id,

        CASE
            WHEN customer_id IS NOT NULL
                THEN CONCAT('CRM:', CAST(customer_id AS STRING))

            WHEN user_pseudo_id IS NOT NULL
                THEN CONCAT('GA4:', user_pseudo_id)

            ELSE NULL
        END AS journey_id,

        CASE
            WHEN customer_id IS NOT NULL
                THEN 'CRM_IDENTIFIED'

            WHEN user_pseudo_id IS NOT NULL
                THEN 'GA4_UNRESOLVED'

            ELSE 'MISSING_IDENTITY'
        END AS identity_type,

        -- Session-level traffic source
        NULLIF(
            LOWER(TRIM(observed_event_source)),
            ''
        ) AS touchpoint_source,

        NULLIF(
            LOWER(TRIM(observed_event_medium)),
            ''
        ) AS touchpoint_medium,

        NULLIF(
            LOWER(TRIM(observed_event_campaign)),
            ''
        ) AS touchpoint_campaign,

        -- First-user acquisition information
        first_user_source,
        first_user_medium,
        first_user_campaign,

        -- Source availability
        CASE
            WHEN observed_event_source IS NULL
                OR TRIM(observed_event_source) = ''
                OR LOWER(TRIM(observed_event_source)) = '(not set)'
                THEN 'UNKNOWN'

            ELSE 'AVAILABLE'
        END AS touchpoint_source_status,

        -- Session activity
        events_in_session,
        purchase_events,

        CASE
            WHEN purchase_events > 0 THEN TRUE
            ELSE FALSE
        END AS has_purchase

    FROM sessions

)

SELECT *
FROM touchpoints

WHERE journey_id IS NOT NULL