SELECT
    COUNT(DISTINCT im.user_pseudo_id) AS mapped_ga4_users,

    COUNT(DISTINCT gs.user_pseudo_id) AS users_found_in_sessions,

    COUNT(DISTINCT IF(
        gs.user_pseudo_id IS NULL,
        im.user_pseudo_id,
        NULL
    )) AS users_not_found_in_sessions

FROM `customer-360-mta.customer_360_raw.identity_mapping` im

LEFT JOIN (
    SELECT DISTINCT user_pseudo_id
    FROM `customer-360-mta.customer_360_raw.ga4_sessions`
) gs

ON im.user_pseudo_id = gs.user_pseudo_id;