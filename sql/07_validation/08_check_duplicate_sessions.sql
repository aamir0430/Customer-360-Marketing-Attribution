SELECT
    user_pseudo_id,
    ga_session_id,
    COUNT(*) AS record_count

FROM (
    SELECT
        gs.user_pseudo_id,
        gs.ga_session_id

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
)

GROUP BY
    user_pseudo_id,
    ga_session_id

HAVING
    COUNT(*) > 1

LIMIT 100;