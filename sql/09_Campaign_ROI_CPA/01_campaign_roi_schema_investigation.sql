-- Campaign ROI and CPA: Schema Investigation

SELECT
    table_schema,
    table_name,
    column_name,
    data_type,
    ordinal_position

FROM
    `customer-360-mta.region-us.INFORMATION_SCHEMA.COLUMNS`

WHERE
    (
        table_schema = 'customer_360_raw'
        AND table_name IN (
            'ad_spend_unpartitioned',
            'ga4_sessions'
        )
    )

    OR

    (
        table_schema = 'customer_360_curated'
        AND table_name IN (
            'identity_resolved_sessions'
        )
    )

    OR

    (
        table_schema = 'customer_360_dbt_dev'
        AND table_name IN (
            'fct_ad_spend_performance',
            'fct_campaign_performance_summary',
            'fct_channel_performance_summary',
            'fct_conversion_journeys',
            'fct_attribution_comparison',
            'fct_marketing_performance_reporting'
        )
    )

ORDER BY
    table_schema,
    table_name,
    ordinal_position;