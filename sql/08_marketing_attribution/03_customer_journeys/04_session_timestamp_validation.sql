SELECT
    COUNT(*) AS total_sessions,

    COUNTIF(
        session_first_event_timestamp_utc IS NOT NULL
    ) AS non_null_timestamps,

    COUNTIF(
        SAFE_CAST(
            session_first_event_timestamp_utc AS TIMESTAMP
        ) IS NOT NULL
    ) AS successfully_converted_timestamps,

    COUNTIF(
        session_first_event_timestamp_utc IS NOT NULL
        AND SAFE_CAST(
            session_first_event_timestamp_utc AS TIMESTAMP
        ) IS NULL
    ) AS failed_timestamp_conversions,

    MIN(
        SAFE_CAST(
            session_first_event_timestamp_utc AS TIMESTAMP
        )
    ) AS earliest_session_timestamp,

    MAX(
        SAFE_CAST(
            session_first_event_timestamp_utc AS TIMESTAMP
        )
    ) AS latest_session_timestamp

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_sessions`;