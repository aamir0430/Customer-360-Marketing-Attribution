SELECT
    COUNT(*) AS total_users,

    COUNTIF(session_count > 1) AS users_with_multiple_sessions,

    COUNTIF(session_count = 1) AS users_with_one_session,

    MAX(session_count) AS maximum_sessions_per_user,

    AVG(session_count) AS average_sessions_per_user

FROM (
    SELECT
        user_pseudo_id,
        COUNT(DISTINCT session_key) AS session_count

    FROM
        `customer-360-mta.customer_360_dbt_dev.fct_sessions`

    WHERE
        user_pseudo_id IS NOT NULL

    GROUP BY
        user_pseudo_id
);