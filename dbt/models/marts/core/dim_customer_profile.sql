WITH customers AS (

    SELECT *
    FROM {{ ref('stg_crm_customers') }}

),

session_metrics AS (

    SELECT

        customer_id,

        COUNT(*) AS total_sessions,

        SUM(events_in_session) AS total_events,

        SUM(purchase_events) AS total_purchase_events,

        MIN(session_date) AS first_session_date,

        MAX(session_date) AS last_session_date,

        COUNT(DISTINCT user_pseudo_id) AS total_ga4_users,

        COUNTIF(mapping_is_synthetic = TRUE)
            AS synthetic_mapped_sessions

    FROM
        {{ ref('fct_sessions') }}

    WHERE
        customer_id IS NOT NULL

    GROUP BY
        customer_id

),

order_metrics AS (

    SELECT

        customer_id,

        COUNT(*) AS total_orders,

        SUM(order_revenue_usd) AS total_revenue_usd,

        AVG(order_revenue_usd) AS average_order_value_usd,

        MIN(order_date) AS first_purchase_date,

        MAX(order_date) AS last_purchase_date,

        SUM(total_item_quantity) AS total_items_purchased,

        COUNTIF(has_duplicate_purchase_events = TRUE)
            AS orders_with_duplicate_events

    FROM
        {{ ref('fct_orders') }}

    WHERE
        customer_id IS NOT NULL

    GROUP BY
        customer_id

),

final AS (

    SELECT

        -- Customer identifiers
        c.customer_id,
        c.synthetic_user_id,

        -- Customer details
        c.first_name,
        c.last_name,
        c.email,
        c.gender,
        c.city,
        c.country,

        -- Registration information
        c.registration_date,

        -- Customer classification
        c.customer_status,
        c.loyalty_tier,

        -- Data lineage
        c.data_origin,

        -- Session metrics
        COALESCE(s.total_sessions, 0) AS total_sessions,

        COALESCE(s.total_events, 0) AS total_events,

        COALESCE(s.total_purchase_events, 0)
            AS total_purchase_events,

        COALESCE(s.total_ga4_users, 0)
            AS total_ga4_users,

        s.first_session_date,
        s.last_session_date,

        COALESCE(s.synthetic_mapped_sessions, 0)
            AS synthetic_mapped_sessions,

        -- Order metrics
        COALESCE(o.total_orders, 0) AS total_orders,

        COALESCE(o.total_revenue_usd, 0)
            AS total_revenue_usd,

        COALESCE(o.average_order_value_usd, 0)
            AS average_order_value_usd,

        o.first_purchase_date,
        o.last_purchase_date,

        COALESCE(o.total_items_purchased, 0)
            AS total_items_purchased,

        COALESCE(o.orders_with_duplicate_events, 0)
            AS orders_with_duplicate_events,

        -- Customer engagement classification
        CASE

            WHEN COALESCE(s.total_sessions, 0) = 0
                THEN 'NO SESSIONS'

            WHEN COALESCE(o.total_orders, 0) = 0
                THEN 'BROWSING CUSTOMER'

            ELSE 'PURCHASING CUSTOMER'

        END AS customer_segment,

        -- Customer purchase status
        CASE

            WHEN COALESCE(o.total_orders, 0) = 0
                THEN 'NON-PURCHASER'

            ELSE 'PURCHASER'

        END AS purchase_status

    FROM customers c

    LEFT JOIN session_metrics s
        ON c.customer_id = s.customer_id

    LEFT JOIN order_metrics o
        ON c.customer_id = o.customer_id

)

SELECT *
FROM final