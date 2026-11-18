# Data Dictionary
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document describes the source datasets, BigQuery tables, and analytical dbt models used in the project.

Exact column names and data types should be verified against the live BigQuery schemas and dbt model SQL/YAML files. This dictionary documents known model purposes and business meaning without inventing undocumented column definitions.

## 2. BigQuery Environment

| Configuration | Value |
|---|---|
| Project ID | `customer-360-mta` |
| Location | `US` |
| Raw dataset | `customer_360_raw` |
| Curated dataset | `customer_360_curated` |
| dbt development dataset | `customer_360_dbt_dev` |

## 3. Source Data Inventory

| Source | BigQuery table / source | Purpose |
|---|---|---|
| GA4 events | `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` | Website and ecommerce event data |
| GA4 sessions | `customer_360_raw.ga4_sessions` | Prepared session-level data |
| CRM customers | `customer_360_raw.crm_customers` | Synthetic customer records |
| Identity mapping | `customer_360_raw.identity_mapping` | Synthetic identity relationships |
| Advertising spend | `customer_360_raw.ad_spend_unpartitioned` | Synthetic campaign-date spend data |

## 4. Curated Identity-Resolution Table

**Table:** `customer_360_curated.identity_resolved_sessions`

**Purpose:** Preserve GA4 session records and enrich them with CRM customer information wherever a synthetic identity mapping is available.

Important status field:

| Value | Meaning |
|---|---|
| `IDENTIFIED` | Session linked to a CRM customer through the synthetic identity mapping |
| `UNIDENTIFIED` | No matching identity mapping was available |

Recorded validation:

| Measure | Result |
|---|---:|
| Total output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Missing CRM customer records among identified output | 0 |
| Mismatched synthetic IDs | 0 |

These results validate consistency against generated identity mappings, not real-world identity accuracy.

## 5. dbt Staging Models

| Model | Purpose |
|---|---|
| `stg_ga4_sessions` | Standardizes GA4 session records |
| `stg_ga4_events` | Standardizes GA4 event records and required ecommerce structures |
| `stg_crm_customers` | Standardizes synthetic CRM records |
| `stg_identity_mapping` | Standardizes synthetic identity mapping records |
| `stg_identity_resolved_sessions` | Standardizes curated identity-resolved sessions |

## 6. Core Analytical Models

| Model | Type | Purpose |
|---|---|---|
| `fct_sessions` | Fact | Session-level analytical records |
| `fct_orders` | Fact | Order-level ecommerce records |
| `dim_customer_profile` | Dimension | Consolidated customer profile information |

## 7. Customer Analytics Models

| Model | Type | Purpose |
|---|---|---|
| `fct_customer_rfm` | Fact | Customer recency, frequency, and monetary metrics |
| `fct_customer_rfm_scores` | Fact | RFM scoring results |
| `dim_customer_segments` | Dimension | Customer segment classifications |
| `fct_customer_clv` | Fact | Historical customer lifetime value metrics |
| `dim_customer_360_analytics` | Dimension / analytical mart | Unified customer-level analytical output |

The unified Customer 360 model retains 5,000 CRM customers.

## 8. Marketing Attribution Models

| Model | Purpose |
|---|---|
| `fct_conversion_journeys` | Connects purchase transactions with eligible preceding touchpoints |
| `fct_first_last_touch_attribution` | Stores first-touch and last-touch credit allocation |
| `fct_linear_attribution` | Allocates equal credit across eligible touchpoints |
| `fct_time_decay_attribution` | Allocates normalized credit using a time-decay weighting approach |
| `fct_attribution_comparison` | Consolidates attribution results for model comparison |

### Conversion journey concepts

| Field / Concept | Meaning |
|---|---|
| Transaction ID | Identifier for the ecommerce purchase transaction |
| Customer ID | Resolved CRM customer identifier where available |
| User pseudo ID | GA4 pseudonymous user identifier |
| Order date | Date associated with the purchase |
| Conversion timestamp | Timestamp of the purchase event |
| Order revenue | Revenue associated with the purchase |
| Touchpoint session key | Identifier for the session associated with a journey touchpoint |
| Touchpoint timestamp | Time of the touchpoint |
| Touchpoint source | Traffic source associated with the touchpoint |
| Touchpoint medium | Traffic medium associated with the touchpoint |
| Touchpoint campaign | Campaign value available in the source data |
| Eligible touchpoint count | Number of touchpoints considered for attribution |
| Seconds before conversion | Time difference between touchpoint and conversion |

Exact physical column names must be checked against the actual model SQL.

## 9. Advertising Performance Models

| Model | Purpose |
|---|---|
| `fct_ad_spend_performance` | Daily campaign advertising performance |
| `fct_campaign_performance_summary` | Aggregated campaign-level advertising metrics |
| `fct_channel_performance_summary` | Aggregated advertising channel metrics |
| `fct_marketing_performance_reporting` | Consolidated reporting records from separate advertising and GA4 attribution sources |

### Advertising data summary

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Campaign-date records | 736 |
| Dates | 92 |
| Impressions | 9,246,272 |
| Clicks | 186,706 |
| Simulated conversions | 6,231 |
| Advertising spend | $126,552.23 |

### Important distinction

The advertising dataset contains synthetic simulated conversions. These are not the same as GA4 ecommerce purchase transactions.

The advertising performance models must not be interpreted as verified campaign-level purchase revenue or actual GA4-based CPA.

## 10. Consolidated Reporting Model

**Model:** `fct_marketing_performance_reporting`

Recorded model structure:

| Reporting source | Record count |
|---|---:|
| `SYNTHETIC_AD_SPEND` / `ADVERTISING_PERFORMANCE` | 8 |
| `GA4_SAMPLE_ECOMMERCE` / `GA4_ATTRIBUTION_PERFORMANCE` | 140 |
| Total | 148 |

The model uses separate source records rather than forcing an unsupported campaign-level join.

## 11. Important Grain and Reconciliation Notes

- `fct_orders` is order-level.
- `fct_sessions` is session-level.
- `dim_customer_360_analytics` is customer-level, with one row per CRM customer.
- `fct_conversion_journeys` contains transaction-touchpoint relationships.
- First-touch and last-touch attribution each produce one attributed record per transaction per model.
- Linear and time-decay attribution produce touchpoint-level records.
- The four attribution models are alternative allocations of the same purchase revenue, not four independent revenue streams.

## 12. Maintenance

Update this document when source tables, models, column definitions, materializations, or business rules change.

Use the live BigQuery schema, dbt SQL, dbt YAML, and dbt documentation as authoritative references for exact physical column definitions.