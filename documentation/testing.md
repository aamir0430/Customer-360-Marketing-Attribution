# Testing and Validation
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document describes the testing and validation strategy and records completed validation activities for the Customer 360 & Marketing Attribution platform.

## 2. Testing Objectives

- Verify generated datasets and BigQuery ingestion.
- Identify missing and duplicate records.
- Validate customer identity matching and referential consistency.
- Verify SQL transformations and analytical calculations.
- Reconcile attribution outputs.
- Verify Tableau dashboard metrics.

## 3. Source Dataset Validation

| Dataset | Validation |
|---|---|
| GA4 session data | Schema, session identifiers and session coverage |
| Synthetic CRM customers | Required fields, identifiers and record consistency |
| Synthetic advertising spend | Campaign attributes, spending values and date consistency |
| Synthetic identity mapping | Identifier completeness, mapping consistency and duplicate mappings |

The source tables used in Phase 2 are `customer_360_raw.ga4_sessions`, `customer_360_raw.crm_customers` and `customer_360_raw.identity_mapping`.

## 4. Python Testing

Python scripts are intended to be tested for successful generation, expected output files, data structures, data types, duplicate handling and identity matching behaviour. Pytest is planned for automated Python tests.

## 5. SQL Testing

SQL validation includes schema checks, null and duplicate detection, referential integrity, join validation, aggregation checks and calculation verification.

## 6. Phase 2 – Identity Resolution Validation

**Status: Completed.**

Final output table: `customer_360_curated.identity_resolved_sessions`.

The workflow included inspection and validation of the identity mapping source, previewing the joins, validating the proposed output, creating the final table and executing final validation checks.

### 6.1 Session Population and Uniqueness

| Check | Result |
|---|---:|
| Total output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |

**Outcome:** Every source session was retained in the output, and the total session count reconciles with the identified and unidentified counts.

### 6.2 CRM and Mapping Consistency

| Check | Result |
|---|---:|
| CRM customers represented among identified sessions | 3,500 |
| Identified records with missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

**Outcome:** The final validation checks reported no missing CRM customer records among identified output records and no mismatched synthetic identifiers.

### 6.3 Interpretation and Limitation

The mapping dataset is synthetic. These checks validate implementation consistency against the generated mapping data; they do not establish real-world identity accuracy. The large unidentified session population is retained rather than dropped.

## 7. dbt Testing

Planned dbt tests include unique, not-null, accepted-values, referential-integrity, source-freshness (where applicable) and custom business-rule tests. These will be recorded after dbt models are implemented.

## 8. Further Analytical Testing

Future validation will cover:
- RFM recency, frequency and monetary calculations.
- Customer Lifetime Value calculations.
- Attribution credit allocation and reconciliation.
- Advertising spend, attributed revenue, ROAS and acquisition-cost calculations.
- Tableau KPI accuracy, filters and aggregations.

## 9. Test Execution Status

| Component | Status |
|---|---|
| Synthetic CRM dataset generation | Completed |
| Synthetic advertising dataset generation | Completed |
| Synthetic identity mapping dataset generation | Completed |
| BigQuery raw source table loading and verification | Completed |
| Identity mapping inspection and validation | Completed |
| Identity-resolution join preview and output validation | Completed |
| Curated identity-resolved table creation | Completed |
| Final identity-resolution validation | Completed |
| dbt model tests | Pending |
| RFM and CLV validation | Pending |
| Marketing attribution validation | Pending |
| Tableau dashboard testing | Pending |

## 10. Test Evidence

The SQL scripts and validation result exports created during Phase 2 should be retained in the repository's SQL and validation-evidence folders. This document records the final reported results; it does not replace the executable SQL or underlying query-result evidence.