SELECT
    COUNT(*) AS total_sessions,

    COUNTIF(
        observed_event_source IS NOT NULL
        AND first_user_source IS NOT NULL
        AND LOWER(TRIM(observed_event_source))
            != LOWER(TRIM(first_user_source))
    ) AS source_mismatches,

    COUNTIF(
        observed_event_medium IS NOT NULL
        AND first_user_medium IS NOT NULL
        AND LOWER(TRIM(observed_event_medium))
            != LOWER(TRIM(first_user_medium))
    ) AS medium_mismatches,

    COUNTIF(
        observed_event_campaign IS NOT NULL
        AND first_user_campaign IS NOT NULL
        AND LOWER(TRIM(observed_event_campaign))
            != LOWER(TRIM(first_user_campaign))
    ) AS campaign_mismatches,

    COUNTIF(
        observed_event_source IS NULL
        AND first_user_source IS NOT NULL
    ) AS missing_observed_source,

    COUNTIF(
        first_user_source IS NULL
        AND observed_event_source IS NOT NULL
    ) AS missing_first_user_source

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_sessions`;