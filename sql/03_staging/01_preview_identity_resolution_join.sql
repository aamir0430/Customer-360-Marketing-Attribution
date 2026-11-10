SELECT
    -- GA4 Session Information
    gs.user_pseudo_id,
    gs.ga_session_id,
    gs.session_event_date,
    gs.events_in_session,
    gs.purchase_events,
    gs.observed_event_source,
    gs.observed_event_medium,
    gs.observed_event_campaign,

    -- Identity Mapping Information
    im.synthetic_user_id,
    im.customer_id,
    im.match_method,
    im.mapping_is_synthetic,

    -- CRM Customer Information
    crm.first_name,
    crm.last_name,
    crm.email,
    crm.city,
    crm.country,
    crm.customer_status,
    crm.loyalty_tier

FROM
    `customer-360-mta.customer_360_raw.ga4_sessions` gs

LEFT JOIN
    `customer-360-mta.customer_360_raw.identity_mapping` im

ON
    gs.user_pseudo_id = im.user_pseudo_id

LEFT JOIN
    `customer-360-mta.customer_360_raw.crm_customers` crm

ON
    im.customer_id = crm.customer_id

LIMIT 50;