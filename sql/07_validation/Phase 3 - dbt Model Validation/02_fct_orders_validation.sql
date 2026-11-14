SELECT

    COUNT(*) AS total_orders,

    COUNT(DISTINCT transaction_id) AS unique_transactions,

    COUNTIF(customer_id IS NOT NULL) AS identified_orders,

    COUNTIF(customer_id IS NULL) AS unidentified_orders,

    COUNTIF(mapping_is_synthetic = TRUE)
        AS synthetic_mapped_orders,

    SUM(order_revenue_usd) AS total_revenue_usd,

    SUM(total_item_quantity) AS total_items_sold,

    AVG(order_revenue_usd) AS average_order_value_usd

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_orders`;

-- Check transaction uniqueness

SELECT

    transaction_id,

    COUNT(*) AS record_count

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_orders`

GROUP BY
    transaction_id

HAVING
    COUNT(*) > 1;

-- Check missing values

SELECT

    COUNTIF(transaction_id IS NULL)
        AS null_transaction_ids,

    COUNTIF(order_date IS NULL)
        AS null_order_dates,

    COUNTIF(order_revenue_usd IS NULL)
        AS null_revenue_values,

    COUNTIF(order_revenue_usd < 0)
        AS negative_revenue_records,

    COUNTIF(customer_id IS NULL)
        AS unidentified_orders,

    COUNTIF(has_duplicate_purchase_events = TRUE)
        AS transactions_with_duplicate_events

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_orders`;

-- Check duplicate handling

SELECT

    purchase_event_count,

    COUNT(*) AS transaction_count

FROM
    `customer-360-mta.customer_360_dbt_dev.fct_orders`

GROUP BY
    purchase_event_count

ORDER BY
    purchase_event_count;