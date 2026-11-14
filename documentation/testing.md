# Testing and Validation
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document records completed validation activities and the testing strategy for future project phases.

## 2. Testing Objectives

- Verify generated datasets and BigQuery ingestion.
- Identify missing and duplicate records.
- Validate customer identity matching and referential consistency.
- Verify dbt transformations and analytical model outputs.
- Validate RFM, CLV, and attribution calculations when implemented.
- Verify Tableau dashboard metrics when implemented.

## 3. Source Dataset Validation

| Dataset | Validation focus |
|---|---|
| GA4 session data | Schema, session identifiers, and session coverage |
| Synthetic CRM customers | Required fields, identifiers, and record consistency |
| Synthetic advertising spend | Campaign attributes, spend values, and date consistency |
| Synthetic identity mapping | Identifier completeness, mapping consistency, and duplicate mappings |

Phase 2 BigQuery source tables:

- `customer_360_raw.ga4_sessions`
- `customer_360_raw.crm_customers`
- `customer_360_raw.identity_mapping`

## 4. Python Testing

Python data-generation scripts should be checked for successful execution, expected output files, data structures, data types, duplicate handling, and identity-mapping behaviour. Automated pytest coverage should be recorded when implemented and executed.

## 5. SQL Testing

SQL validation includes schema checks, null and duplicate detection, referential integrity, join validation, aggregation checks, and calculation verification.

## 6. Phase 2 – Identity Resolution Validation

**Status: Completed.**

Final output: `customer_360_curated.identity_resolved_sessions`.

### 6.1 Session Population and Uniqueness

| Check | Result |
|---|---:|
| Total output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |

**Outcome:** Every source session was retained, and the total reconciles with the identified and unidentified counts.

### 6.2 CRM and Mapping Consistency

| Check | Result |
|---|---:|
| CRM customers represented among identified sessions | 3,500 |
| Identified records with missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

**Outcome:** The recorded final validation checks reported no missing CRM customer records among identified output records and no mismatched synthetic identifiers.

**Limitation:** The mapping dataset is synthetic. These checks validate implementation consistency against generated mapping data; they do not establish real-world identity accuracy.

## 7. Phase 3 – dbt Project and Model Validation

**Status: Completed.**

### 7.1 dbt Environment and Project Checks

| Check | Result |
|---|---|
| `dbt debug` | Passed – all checks passed |
| `dbt parse` | Completed successfully |
| `dbt docs generate` | Completed; catalog generated |
| Generated catalog | `dbt/target/catalog.json` |

A local Python package compatibility issue was resolved before the successful diagnostics. Non-blocking project warnings appeared during parsing. Non-fatal `agate` `table_owner` warnings appeared during documentation generation.

### 7.2 Core dbt Models

| Model | Role | Validation status |
|---|---|---|
| `fct_sessions` | Session fact | Confirmed validated |
| `fct_orders` | Order fact | Confirmed validated |
| `dim_customer_profile` | Customer profile dimension | Confirmed validated |

The three model outputs were created in the BigQuery development target dataset `customer_360_dbt_dev`. The project owner confirmed that all three mart validations were successful.

### 7.3 Evidence Boundary

The available completion record confirms successful dbt diagnostics, parsing, documentation generation, and validation of the three core marts. It does not include exact final `dbt build` or `dbt test` pass/fail totals, nor individual model row counts. Do not infer or fabricate these values.

When command logs or saved query results are available, add the exact test names, pass/fail/skip totals, and mart row counts.

### 7.4 Recommended dbt Test Coverage

Use tests appropriate to each model's declared grain and business rules:

- `not_null` for required keys and mandatory fields.
- `unique` for identifiers that should be unique at the model grain.
- `accepted_values` for controlled status fields.
- `relationships` for expected foreign-key relationships.
- Custom tests for session/order business rules and reconciliation.

Only tests actually configured and executed should be reported as passed.

## 8. Further Analytical Testing

Future validation will cover:

- RFM recency, frequency, and monetary calculations.
- Customer Lifetime Value calculations.
- Attribution credit allocation and reconciliation.
- Advertising spend, attributed revenue, ROAS, and acquisition-cost calculations.
- Tableau KPI accuracy, filters, and aggregations.

## 9. Test Execution Status

| Component | Status |
|---|---|
| Synthetic CRM dataset generation | Completed |
| Synthetic advertising dataset generation | Completed |
| Synthetic identity mapping dataset generation | Completed |
| BigQuery raw source loading and verification | Completed |
| Identity mapping inspection and validation | Completed |
| Identity-resolution join preview and output validation | Completed |
| Curated identity-resolved table creation | Completed |
| Final identity-resolution validation | Completed |
| dbt project diagnostics and parsing | Completed |
| dbt core mart output validation | Completed – three core marts confirmed |
| Exact automated dbt test/build totals | Not recorded in this document |
| RFM and CLV validation | Pending |
| Marketing attribution validation | Pending |
| Tableau dashboard testing | Pending |

## 10. Test Evidence

Retain executable SQL, dbt model files, YAML tests, command logs, and validation query outputs in the repository. This document records reported results; it does not replace the underlying executable evidence.