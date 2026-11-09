SELECT
    COUNT(DISTINCT user_pseudo_id) AS total_pseudo_users,

    COUNT(DISTINCT user_id) AS total_user_ids,

    COUNT(DISTINCT CASE
        WHEN user_id IS NOT NULL
        THEN user_pseudo_id
    END) AS pseudo_users_with_user_id,

    COUNT(DISTINCT CASE
        WHEN user_id IS NULL
        THEN user_pseudo_id
    END) AS pseudo_users_without_user_id,

    COUNTIF(user_pseudo_id IS NULL) AS events_without_pseudo_id

FROM
    `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`;