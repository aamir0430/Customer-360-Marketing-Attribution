WITH source AS (

    SELECT *
    FROM {{ source('customer_360_raw', 'ga4_events') }}

),

renamed AS (

    SELECT

        -- Event information
        SAFE.PARSE_DATE('%Y%m%d', event_date) AS event_date,
        event_date AS event_date_raw,
        event_timestamp,
        TIMESTAMP_MICROS(event_timestamp) AS event_timestamp_utc,
        event_name,

        -- Event parameters
        event_params,

        -- Additional event information
        event_previous_timestamp,
        event_value_in_usd,
        event_bundle_sequence_id,
        event_server_timestamp_offset,

        -- User identifiers
        NULLIF(TRIM(user_id), '') AS user_id,
        NULLIF(TRIM(user_pseudo_id), '') AS user_pseudo_id,

        -- Privacy information
        privacy_info,

        -- User properties
        user_properties,

        -- First touch information
        user_first_touch_timestamp,
        user_ltv,

        -- Device information
        device,

        -- Geographic information
        geo,

        -- Application information
        app_info,

        -- Traffic source information
        traffic_source,

        -- Platform information
        stream_id,
        platform,
        event_dimensions,

        -- Ecommerce information
        ecommerce,

        -- Product/item information
        items

    FROM source

)

SELECT *
FROM renamed