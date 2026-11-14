# Project Results
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document records implementation results and validation evidence. Business insights will be added after the customer analytics and marketing attribution phases are completed.

## 2. Phase 1 – Data Source Setup and Dataset Generation

**Status: Completed.**

Three synthetic datasets were generated:

- `synthetic_crm_customers.csv`
- `synthetic_ad_spend.csv`
- `identity_mapping.csv`

The GA4 public ecommerce sample was selected as the website behavioural data source.

## 3. Phase 2 – Identity Resolution

**Status: Completed.**

Created:

`customer360-mta.customer_360_curated.identity_resolved_sessions`

LEFT JOIN-based enrichment retains sessions without a matching synthetic identity mapping.

### 3.1 Final Validation Results

| Measure | Result |
|---|---:|
| Total sessions in output | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Missing CRM customer records in identified output | 0 |
| Mismatched synthetic IDs in validation | 0 |

The identified and unidentified counts reconcile:

`10,246 + 349,883 = 360,129`

### 3.2 Interpretation and Limitation

The output preserves the complete GA4 session population. Identified sessions are linked to CRM customer records through the generated mapping dataset; all remaining sessions are retained as unidentified.

The mappings are synthetic. The results demonstrate internal consistency against generated test data, not real-world identity-resolution accuracy.

## 4. Phase 3 – dbt Data Modelling

**Status: Completed.**

Phase 3 established the dbt modelling layer on top of the BigQuery raw and curated sources.

### 4.1 Project Configuration

| Item | Result |
|---|---|
| dbt project | `customer_360` |
| Warehouse | Google BigQuery |
| Development target dataset | `customer_360_dbt_dev` |
| Configured upstream sources | GA4 sessions, GA4 events, CRM customers, identity mapping, identity-resolved sessions |
| Staging materialization | Views |
| Intermediate materialization | Ephemeral models where configured |

### 4.2 Models Created

**Staging models**

- `stg_ga4_sessions`
- `stg_ga4_events`
- `stg_crm_customers`
- `stg_identity_mapping`
- `stg_identity_resolved_sessions`

**Core marts**

| Model | Purpose | Validation status |
|---|---|---|
| `fct_sessions` | Session-level analytical output | Validated |
| `fct_orders` | Order-level analytical output | Validated |
| `dim_customer_profile` | Consolidated customer-profile output | Validated |

The user confirmed successful validation of all three core marts in BigQuery.

### 4.3 dbt Tooling Results

- `dbt debug`: all checks passed after resolving the local environment compatibility issue.
- `dbt parse`: completed successfully.
- `dbt docs generate`: completed successfully and generated `dbt/target/catalog.json`.
- Documentation generation displayed non-fatal `agate` `table_owner` warnings; catalog generation completed.

### 4.4 Evidence Boundary

The available completion record confirms successful diagnostics, parsing, documentation generation, and validation of the three core marts. It does not contain exact final `dbt build`/`dbt test` totals or per-model row counts. Those figures should only be added from saved command output or BigQuery validation evidence.

## 5. Next Analytical Work

Phase 4 will implement RFM segmentation and historical CLV using the completed dbt models. Later work will cover marketing attribution, campaign performance metrics, and Tableau dashboards.

## 6. Business Insights

Business insights and recommendations will be documented after the customer analytics and marketing attribution phases have been implemented and validated.

## 7. Final Project Summary

To be completed after implementation and validation of all project phases.