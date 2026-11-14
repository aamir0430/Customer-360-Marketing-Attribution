# Project Methodology
## Customer 360 & Marketing Attribution Programme

## 1. Overview

The project integrates website behavioural data, synthetic CRM data, advertising information, and identity mapping in BigQuery. The workflow then uses dbt to create reusable session, order, and customer-profile models. Customer analytics and marketing attribution are subsequent phases.

## 2. Data Integration

Inputs include:
- GA4 ecommerce event and session data.
- Synthetic CRM customer records.
- Synthetic advertising spend data.
- Synthetic identity mapping records.

Raw/prepared source data is held in `customer_360_raw`. The completed identity-resolution output is held in `customer_360_curated`.

## 3. Customer Identity Resolution – Phase 2

### Objective

Connect GA4 website sessions with CRM customer records wherever a corresponding identity mapping exists, while preserving sessions that cannot be identified.

### Implemented workflow

1. Load GA4 sessions, CRM customers, and identity mapping into BigQuery.
2. Inspect identity mapping records and relevant identifiers.
3. Preview joins between sessions, identity mappings, and CRM records.
4. Validate session coverage and CRM linkage.
5. Create `customer_360_curated.identity_resolved_sessions`.
6. Execute final validation checks.

### Join approach

Use LEFT JOIN logic from the GA4 session population to the synthetic identity mapping and then to CRM customer records. This retains all source sessions even when no mapping is available.

The output includes session data, available mapping attributes, CRM profile attributes where a match exists, and `identity_resolution_status`.

### Identity status

- `IDENTIFIED`: a session was connected to a CRM customer through the synthetic mapping.
- `UNIDENTIFIED`: no matching mapping was available; the session remains in the output.

### Recorded validation results

| Measure | Result |
|---|---:|
| Total output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Missing CRM customer records among identified output | 0 |
| Mismatched synthetic IDs | 0 |

The identified and unidentified counts reconcile to the full session population.

### Limitation

The mapping data is synthetic. The results validate the SQL workflow against generated mappings and must not be interpreted as real-world identity-resolution accuracy.

## 4. dbt Transformation Methodology – Phase 3

### Objective

Transform the raw and curated BigQuery sources into consistent, reusable session, order, and customer-profile models using dbt.

### Project configuration

- dbt project: `customer_360`.
- Warehouse: Google BigQuery.
- Development target dataset: `customer_360_dbt_dev`.
- Configured sources: GA4 sessions, GA4 events, CRM customers, identity mapping, and identity-resolved sessions.

### Staging layer

Five source-aligned staging models were created:

1. `stg_ga4_sessions`
2. `stg_ga4_events`
3. `stg_crm_customers`
4. `stg_identity_mapping`
5. `stg_identity_resolved_sessions`

Staging transformations standardize source data for downstream modelling. The GA4 event staging model retains nested ecommerce and item structures needed for purchase-related modelling. Staging models are configured as views.

### Intermediate transformations

Ephemeral models are used for reusable intermediate transformations where configured. These are compiled into downstream models rather than persisted as standalone warehouse relations.

### Core analytical marts

- `fct_sessions`: session-level analytical output.
- `fct_orders`: order-level analytical output.
- `dim_customer_profile`: consolidated customer-profile output.

The three core marts were created in the BigQuery development target and their outputs were validated.

### dbt project verification and documentation

- `dbt debug` completed with all checks passing after a local environment compatibility issue was resolved.
- `dbt parse` completed successfully.
- `dbt docs generate` completed and generated `dbt/target/catalog.json`.
- Non-fatal `agate` `table_owner` warnings appeared during documentation generation.

Exact final automated test/build totals and per-model row counts are not recorded in this methodology because the numerical command outputs are not available in the completion notes.

## 5. RFM Customer Segmentation – Planned

RFM analysis will classify customers according to:
- **Recency:** how recently a customer purchased.
- **Frequency:** how often a customer purchased.
- **Monetary:** how much a customer spent.

Scoring rules and thresholds will be defined after reviewing the validated order model and transaction data.

## 6. Customer Lifetime Value – Planned

Historical CLV will estimate customer value over the observed purchasing history. The final definition, revenue basis, time window, and calculation rules will be documented when implemented.

## 7. Marketing Attribution – Planned

The project plans to compare:
- **First-touch:** credits the first eligible touchpoint.
- **Last-touch:** credits the final eligible touchpoint before conversion.
- **Linear:** distributes credit equally across eligible touchpoints.
- **Time-decay:** gives greater credit to touchpoints closer to conversion.

Implementation requires reliable customer journey, timestamp, channel, and conversion information.

## 8. Marketing Performance Measurement – Planned

Planned metrics include advertising spend, attributed revenue, ROAS, CAC, CPA, conversion rate, and channel-level revenue contribution. Definitions and attribution windows will be documented before reporting.

## 9. Visualization – Planned

Tableau dashboards are planned for Customer 360, customer segmentation, CLV, channel performance, attribution comparison, and campaign ROI.

## 10. Implementation Status

**Completed:** Phase 1 data source setup and synthetic dataset generation; Phase 2 BigQuery identity resolution; Phase 3 dbt project setup, staging models, core marts, BigQuery validation, and documentation generation.

**Next:** Phase 4 customer analytics, including RFM segmentation and historical CLV. Marketing attribution and Tableau dashboards remain future work.