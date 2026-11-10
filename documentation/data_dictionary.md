# Data Dictionary
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document describes the source and curated datasets used in the Customer 360 & Marketing Attribution Programme. It records their purposes, locations and roles in the analytical architecture.

The BigQuery table schema remains the authoritative source for exact column names and data types. Column-level definitions should be expanded from the live schema when documenting downstream models.

## 2. Data Source Inventory

| Data Source | File / BigQuery table | Data Type | Purpose |
|---|---|---|---|
| GA4 Ecommerce | `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` | Public sample data | Website behavioural and ecommerce events |
| GA4 Sessions | `customer_360_raw.ga4_sessions` | Prepared GA4 data | Session-level behavioural records |
| CRM Customers | `customer_360_raw.crm_customers` | Synthetic | Customer profile and CRM identifiers |
| Advertising Spend | `synthetic_ad_spend.csv` | Synthetic | Advertising campaign and spending information |
| Identity Mapping | `customer_360_raw.identity_mapping` | Synthetic | Mapping between website-side and CRM identifiers |
| Identity-Resolved Sessions | `customer_360_curated.identity_resolved_sessions` | Curated integration output | GA4 sessions enriched with mapped CRM identities and profile attributes |

## 3. Raw BigQuery Tables

Project: `customer360-mta`  
Dataset: `customer_360_raw`

| Table | Purpose |
|---|---|
| `ga4_sessions` | Prepared GA4 session-level data |
| `crm_customers` | Synthetic CRM customer records |
| `identity_mapping` | Synthetic cross-platform identity mappings |

## 4. Curated Identity Resolution Table

**Fully qualified table:** `customer360-mta.customer_360_curated.identity_resolved_sessions`

**Purpose:** Provides a session-level dataset that retains GA4 sessions and attaches CRM identity and profile information where a corresponding synthetic mapping exists.

### Content groups

| Content group | Description |
|---|---|
| GA4 session fields | Session identifiers and available session-level behavioural/traffic attributes |
| Identity mapping fields | Synthetic user identifier, CRM customer identifier, match method, synthetic-mapping indicator and available mapping metadata |
| CRM profile fields | Customer attributes from the matching CRM record |
| Identity status | `identity_resolution_status`, with `IDENTIFIED` or `UNIDENTIFIED` values |

Refer to the actual BigQuery schema for the complete field list and data types.

### Identity status interpretation

- `IDENTIFIED`: the GA4 session was connected to a CRM customer through the project's synthetic mapping data.
- `UNIDENTIFIED`: no corresponding identity mapping was available for that session.

An unidentified session is retained in the output; it is not discarded.

## 5. Phase 2 Validation Counts

Recorded final validation results for `identity_resolved_sessions`:

| Measure | Result |
|---|---:|
| Total output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Identified records with missing CRM customer records | 0 |
| Mismatched synthetic IDs in the validation checks | 0 |

Identified and unidentified sessions sum to the full output session count. These results describe the synthetic mapping exercise and should not be interpreted as real-world identity match performance.

## 6. Other Synthetic Datasets

### CRM Customers

File: `synthetic_crm_customers.csv`  
BigQuery table: `customer_360_raw.crm_customers`

Represents synthetic customer records and CRM attributes used for customer profile enrichment.

### Advertising Spend

File: `synthetic_ad_spend.csv`

Represents synthetic advertising campaign and spending information. Its downstream warehouse table and schema should be documented when that dataset is ingested for attribution modelling.

### Identity Mapping

File: `identity_mapping.csv`  
BigQuery table: `customer_360_raw.identity_mapping`

Contains synthetic relationships between website-side identifiers and CRM customer identifiers. It is a simulated bridge used to develop and test identity resolution.

## 7. Data Layer Organization

| BigQuery Dataset | Purpose | Status |
|---|---|---|
| `customer_360_raw` | Source tables | Loaded and used in Phase 2 |
| `customer_360_curated` | Integrated curated outputs | Identity-resolved session table created |
| `customer_360_staging` | Cleaned and standardized transformation layer | Planned for subsequent modelling |
| `customer_360_analytics` | Analytical outputs | Planned |

## 8. Data Dictionary Maintenance

Update this document when new sources or tables are added, schemas change, columns are transformed, or business definitions are introduced. Use the live BigQuery schema to verify exact field names and data types.