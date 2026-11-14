WITH purchase_events AS (

    SELECT

        -- Transaction identifier
        COALESCE(
            NULLIF(TRIM(ecommerce.transaction_id), ''),
            NULLIF(
                TRIM((
                    SELECT ep.value.string_value
                    FROM UNNEST(event_params) ep
                    WHERE ep.key = 'transaction_id'
                    LIMIT 1
                )),
                ''
            )
        ) AS transaction_id,

        -- GA4 identifiers
        user_pseudo_id,

        CAST((
            SELECT ep.value.int_value
            FROM UNNEST(event_params) ep
            WHERE ep.key = 'ga_session_id'
            LIMIT 1
        ) AS STRING) AS ga_session_id,

        -- Purchase information
        event_date,
        event_timestamp,
        event_timestamp_utc,

        -- Revenue
        ecommerce.purchase_revenue_in_usd AS order_revenue_usd,

        ecommerce.purchase_revenue AS order_revenue,

        (
            SELECT ep.value.string_value
            FROM UNNEST(event_params) ep
            WHERE ep.key = 'currency'
            LIMIT 1
        ) AS currency,

        -- Product information
        ecommerce.total_item_quantity AS total_item_quantity,

        ecommerce.unique_items AS unique_items

    FROM
        {{ ref('stg_ga4_events') }}

    WHERE
        event_name = 'purchase'

),

valid_purchase_events AS (

    SELECT *
    FROM purchase_events

    WHERE
        transaction_id IS NOT NULL

),

deduplicated_orders AS (

    SELECT

        *,

        COUNT(*) OVER (
            PARTITION BY transaction_id
        ) AS purchase_event_count,

        ROW_NUMBER() OVER (
            PARTITION BY transaction_id
            ORDER BY
                event_timestamp DESC,
                user_pseudo_id DESC
        ) AS transaction_row_number

    FROM valid_purchase_events

),

orders AS (

    SELECT *
    FROM deduplicated_orders

    WHERE transaction_row_number = 1

),

identity AS (

    SELECT

        user_pseudo_id,
        customer_id,
        synthetic_user_id,
        mapping_is_synthetic

    FROM
        {{ ref('stg_identity_mapping') }}

),

final AS (

    SELECT

        -- Primary identifier
        o.transaction_id,

        -- GA4 identifiers
        o.user_pseudo_id,
        o.ga_session_id,

        -- Session key
        CASE
            WHEN o.ga_session_id IS NOT NULL THEN

                TO_HEX(
                    MD5(
                        CONCAT(
                            COALESCE(o.user_pseudo_id, ''),
                            '|',
                            o.ga_session_id
                        )
                    )
                )

            ELSE NULL
        END AS session_key,

        -- CRM identity
        i.customer_id,
        i.synthetic_user_id,
        i.mapping_is_synthetic,

        -- Order information
        o.event_date AS order_date,
        o.event_timestamp,
        o.event_timestamp_utc,

        -- Revenue
        o.order_revenue_usd,
        o.order_revenue,
        o.currency,

        -- Product metrics
        o.total_item_quantity,
        o.unique_items,

        -- Data quality information
        o.purchase_event_count,
        o.purchase_event_count > 1 AS has_duplicate_purchase_events

    FROM orders o

    LEFT JOIN identity i
        ON o.user_pseudo_id = i.user_pseudo_id

)

SELECT *
FROM final