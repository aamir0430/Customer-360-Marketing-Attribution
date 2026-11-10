CREATE OR REPLACE TABLE
`customer-360-mta.customer_360_curated.identity_resolved_sessions`

OPTIONS (
    description = 'Customer 360 identity resolution table combining GA4 sessions, synthetic identity mappings, and CRM customer profiles.'
)

AS

SELECT

    -- 1. GA4 SESSION INFORMATION

    gs.user_pseudo_id,
    gs.ga_session_id,
    gs.session_event_date,
    gs.session_first_event_timestamp_utc,
    gs.events_in_session,
    gs.purchase_events,

    gs.observed_event_source,
    gs.observed_event_medium,
    gs.observed_event_campaign,

    gs.first_user_source,
    gs.first_user_medium,
    gs.first_user_campaign,

    -- 2. IDENTITY MAPPING INFORMATION

    im.synthetic_user_id,
    im.customer_id,
    im.match_method,
    im.mapping_is_synthetic,
    im.ga4_purchase_events_at_export,
    im.ga4_first_seen_date,

    -- 3. CRM CUSTOMER INFORMATION

    crm.first_name,
    crm.last_name,
    crm.email,
    crm.gender,
    crm.city,
    crm.country,
    crm.registration_date,
    crm.customer_status,
    crm.loyalty_tier,
    crm.data_origin AS crm_data_origin,

    -- 4. IDENTITY RESOLUTION STATUS

    CASE
        WHEN im.customer_id IS NOT NULL
             AND crm.customer_id IS NOT NULL
        THEN 'IDENTIFIED'

        ELSE 'UNIDENTIFIED'
    END AS identity_resolution_status

FROM

    `customer-360-mta.customer_360_raw.ga4_sessions` gs

LEFT JOIN

    `customer-360-mta.customer_360_raw.identity_mapping` im

ON

    gs.user_pseudo_id = im.user_pseudo_id

LEFT JOIN

    `customer-360-mta.customer_360_raw.crm_customers` crm

ON

    im.customer_id = crm.customer_id;