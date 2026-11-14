# Data Dictionary
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document inventories the source datasets, curated outputs, and dbt models used in the project. Exact column names and data types must be verified against the live BigQuery schemas and current dbt model SQL/YAML. This document does not infer undocumented columns.

## 2. Source Data Inventory

| Source | Location | Purpose |
|---|---|---|
| GA4 ecommerce events | `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` | Website interaction and ecommerce event data |
| GA4 sessions | `customer_360_raw.ga4_sessions` | Prepared session-level data |
| CRM customers | `customer_360_raw.crm_customers` | Synthetic CRM customer records |
| Identity mapping | `customer_360_raw.identity_mapping` | Synthetic mapping between website and CRM identifiers |
| Advertising spend | `synthetic_ad_spend.csv` | Synthetic campaign and advertising expenditure data |
| Identity-resolved sessions | `customer_360_curated.identity_resolved_sessions` | Session records enriched with CRM identity/profile data where a mapping exists |

## 3. BigQuery Datasets

| Dataset | Purpose | Status |
|---|---|---|
| `customer_360_raw` | Raw/prepared source tables | Created and used |
| `customer_360_curated` | Curated identity-resolution output | Created and used |
| `customer_360_dbt_dev` | dbt development model outputs | Created and used in Phase 3 |

Google Cloud project: `customer360-mta`.

## 4. Curated Identity-Resolution Table

**Table:** `customer_360_curated.identity_resolved_sessions`

**Purpose:** Retain the GA4 session population and attach synthetic mapping and CRM customer information wherever an identity mapping is available.

**Important field:** `identity_resolution_status`

- `IDENTIFIED`: the session was connected to a CRM record through the synthetic identity mapping.
- `UNIDENTIFIED`: no corresponding mapping was available. The session remains in the output.

Recorded Phase 2 validation:

| Measure | Result |
|---|---:|
| Total output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Identified records missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

These figures describe the synthetic identity-mapping exercise, not real-world identity match accuracy.

## 5. dbt Source Inventory – Phase 3

The dbt project is named `customer_360`. Its configured source inventory includes:

| dbt source name | Upstream role |
|---|---|
| `ga4_sessions` | Prepared GA4 session-level source |
| `ga4_events` | GA4 event-level source with ecommerce event data |
| `crm_customers` | Synthetic CRM customer source |
| `identity_mapping` | Synthetic cross-platform identity bridge |
| `identity_resolved_sessions` | Curated session-to-CRM enrichment output |

## 6. dbt Staging Models

| Model | Purpose | Materialization |
|---|---|---|
| `stg_ga4_sessions` | Standardizes GA4 session source fields | View |
| `stg_ga4_events` | Standardizes GA4 event data for downstream transformations | View |
| `stg_crm_customers` | Standardizes CRM customer records | View |
| `stg_identity_mapping` | Standardizes identity mapping records | View |
| `stg_identity_resolved_sessions` | Standardizes curated identity-resolved sessions | View |

The GA4 event staging model retains nested ecommerce/item structures required by downstream purchase-related modelling.

## 7. Core dbt Marts

| Model | Model role | Purpose | Validation |
|---|---|---|---|
| `fct_sessions` | Fact | Session-level analytical output | Confirmed validated |
| `fct_orders` | Fact | Order-level analytical output | Confirmed validated |
| `dim_customer_profile` | Dimension | Consolidated customer-profile output | Confirmed validated |

The three marts were created in `customer_360_dbt_dev`. Refer to the model SQL/YAML and live BigQuery schema for exact grain, columns, data types, and tests.

## 8. Synthetic Dataset Notes

### CRM customers

File: `synthetic_crm_customers.csv`  
BigQuery table: `customer_360_raw.crm_customers`

Contains generated CRM customer records for identity enrichment and profile modelling.

### Advertising spend

File: `synthetic_ad_spend.csv`

Contains generated advertising campaign and spend information. Its downstream warehouse model should be added to this dictionary when implemented.

### Identity mapping

File: `identity_mapping.csv`  
BigQuery table: `customer_360_raw.identity_mapping`

Contains synthetic relationships between website-side identifiers and CRM customer identifiers.

## 9. Maintenance

Update this dictionary whenever sources, models, schemas, column definitions, materializations, or business rules change. Use dbt model YAML and live BigQuery schemas as the authoritative references for exact field definitions.