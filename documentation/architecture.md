# System Architecture
## Customer 360 & Marketing Attribution Programme

## 1. Overview

The platform integrates GA4 website behaviour, synthetic CRM customer records, synthetic advertising data, and synthetic identity mappings. Google BigQuery is the central warehouse. Python supports synthetic data generation, SQL implements data preparation and identity resolution, dbt Core provides the transformation and modelling layer, and Tableau is planned for visualization.

## 2. Data Sources

| Source | Location | Description |
|---|---|---|
| GA4 ecommerce events | `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` | Public ecommerce event data |
| Prepared GA4 sessions | `customer_360_raw.ga4_sessions` | Session-level behavioural records |
| CRM customers | `customer_360_raw.crm_customers` | Synthetic customer records |
| Identity mapping | `customer_360_raw.identity_mapping` | Synthetic bridge between website and CRM identifiers |
| Advertising spend | `synthetic_ad_spend.csv` | Synthetic campaign spending data |
| Curated identity-resolved sessions | `customer_360_curated.identity_resolved_sessions` | Session records enriched with CRM details where mapped |

## 3. Technology Architecture

| Layer | Technology | Responsibility |
|---|---|---|
| Data sources | GA4, CSV | Behavioural, CRM, advertising, and identity data |
| Data generation | Python, Pandas | Synthetic data generation |
| Data warehouse | Google BigQuery | Centralized data storage |
| Identity resolution | SQL | Link available session identities to CRM records |
| Transformation | dbt Core, SQL | Staging and analytical model development |
| Analytics | SQL / dbt | Session, order, and customer-profile outputs; later RFM and CLV |
| Visualization | Tableau | Planned dashboards |
| Version control | Git, GitHub | Source control and documentation |

## 4. Implemented Data Flow

1. Select the public GA4 ecommerce sample.
2. Generate synthetic CRM, advertising spend, and identity-mapping datasets.
3. Load the required GA4 session, CRM, and identity mapping data into BigQuery.
4. Validate source tables.
5. Resolve available session-to-CRM identity links using the synthetic mapping.
6. Create the curated identity-resolved session table while retaining unmatched sessions.
7. Configure dbt and declare the upstream BigQuery sources.
8. Build source-aligned staging models.
9. Build the session, order, and customer-profile marts.
10. Validate the three core mart outputs and generate dbt documentation.

## 5. BigQuery Organization

Google Cloud project: `customer360-mta`.

| Dataset | Role | Status |
|---|---|---|
| `customer_360_raw` | Raw/prepared source tables | Created and used |
| `customer_360_curated` | Curated identity-resolution output | Created and used |
| `customer_360_dbt_dev` | dbt development target | Created and used in Phase 3 |

### Raw layer

The Phase 2 source tables are:

- `customer_360_raw.ga4_sessions`
- `customer_360_raw.crm_customers`
- `customer_360_raw.identity_mapping`

The dbt source configuration also includes the GA4 event source and the curated identity-resolved session table.

### Curated layer

Output:

`customer_360_curated.identity_resolved_sessions`

The table combines GA4 session information with synthetic identity mapping and CRM profile attributes when a mapping exists. LEFT JOIN logic retains all source sessions. The `identity_resolution_status` field distinguishes `IDENTIFIED` from `UNIDENTIFIED`.

## 6. dbt Transformation Architecture – Phase 3

The dbt project is named `customer_360` and uses BigQuery. Its development outputs are built in `customer_360_dbt_dev`.

### Configured source inventory

- `ga4_sessions`
- `ga4_events`
- `crm_customers`
- `identity_mapping`
- `identity_resolved_sessions`

### Staging layer

| Model | Role |
|---|---|
| `stg_ga4_sessions` | Standardizes prepared GA4 session data |
| `stg_ga4_events` | Standardizes event data and retains ecommerce structures needed downstream |
| `stg_crm_customers` | Standardizes synthetic CRM records |
| `stg_identity_mapping` | Standardizes synthetic identity mapping data |
| `stg_identity_resolved_sessions` | Standardizes the curated identity-resolved session source |

Staging models are configured as views.

### Intermediate transformations

Ephemeral models are used for intermediate reusable transformations where configured. They are compiled into downstream models rather than materialized as standalone BigQuery tables or views.

### Core marts

| Model | Role | Purpose |
|---|---|---|
| `fct_sessions` | Fact | Session-grain analytical output |
| `fct_orders` | Fact | Order-grain analytical output |
| `dim_customer_profile` | Dimension | Consolidated customer-profile output |

The three core marts were created and their BigQuery outputs were validated. Exact column-level definitions and model grain details should be taken from the current dbt SQL/YAML and BigQuery schemas.

## 7. Architecture Status

- **Phase 1 – Data source setup and synthetic dataset generation:** Completed.
- **Phase 2 – BigQuery ingestion and identity resolution:** Completed.
- **Phase 3 – dbt staging and core marts:** Completed.
- **Phase 4 – RFM and CLV customer analytics:** Next.
- **Phase 5 – Marketing attribution:** Planned.
- **Phase 6 – Tableau dashboards:** Planned.
- **Phase 7 – Final testing and documentation:** Planned.

The identity mapping is synthetic, so the identity-resolution results validate implementation consistency against generated data rather than real-world identity accuracy.