# System Architecture
## Customer 360 & Marketing Attribution Programme

## 1. Overview

The Customer 360 & Marketing Attribution Programme integrates website behavioural data, CRM customer records, advertising campaign information, and identity mapping data into an analytical platform.

Google BigQuery is the central data warehouse. Python is used for synthetic data generation and supporting processing; SQL is used for data preparation, identity resolution and analytics; dbt is planned for transformation modelling; Tableau is planned for visualization.

## 2. Data Sources

| Data Source | Technology | Description |
|---|---|---|
| Website Behavioural Data | GA4 / BigQuery | Ecommerce events and prepared session-level data |
| CRM Customer Data | Python / CSV / BigQuery | Synthetic customer records |
| Advertising Data | Python / CSV | Synthetic advertising campaign and spending information |
| Identity Mapping | Python / CSV / BigQuery | Synthetic mapping between website and CRM identifiers |

GA4 source: `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`.

The generated synthetic files are `synthetic_crm_customers.csv`, `synthetic_ad_spend.csv`, and `identity_mapping.csv`.

## 3. Technology Architecture

| Layer | Technology | Responsibility |
|---|---|---|
| Data Sources | GA4, CSV | Source data |
| Data Generation | Python, Pandas, Faker | Generate synthetic datasets |
| Data Warehouse | Google BigQuery | Centralized data storage |
| Data Preparation and Identity Resolution | SQL | Prepare sessions and connect source identities |
| Data Transformation | SQL, dbt | Cleaning, modelling and transformation |
| Customer Analytics | SQL, Python | Customer profiles, RFM and CLV |
| Marketing Attribution | SQL, Python | Attribution modelling and marketing performance |
| Visualization | Tableau | Interactive dashboards |
| Version Control | Git, GitHub | Source code and documentation management |

## 4. Implemented Data Flow

1. Select the public GA4 ecommerce sample data.
2. Generate synthetic CRM customer, advertising spend and identity mapping datasets.
3. Prepare and load the required source tables into BigQuery.
4. Validate the source tables and their row counts.
5. Inspect and validate the synthetic identity mapping data.
6. Preview and validate joins between GA4 sessions, identity mapping and CRM customers.
7. Create the final identity-resolved session table.
8. Validate session preservation, identity status, CRM coverage and synthetic identifier consistency.

## 5. BigQuery Organization and Implemented Tables

Google Cloud project: `customer360-mta`.

### Raw Layer

Dataset: `customer_360_raw`

Source tables used for identity resolution:

- `ga4_sessions`
- `identity_mapping`
- `crm_customers`

### Curated Layer

Dataset: `customer_360_curated`

Final output table:

`customer_360_curated.identity_resolved_sessions`

This table combines GA4 session-level information with mapping information and CRM profile attributes where a synthetic identity mapping is available.

The implementation uses LEFT JOIN logic so that all GA4 sessions remain in the output, including sessions without a matching identity mapping. The `identity_resolution_status` field distinguishes `IDENTIFIED` and `UNIDENTIFIED` sessions.

### Staging and Analytics Layers

The planned `customer_360_staging` and `customer_360_analytics` datasets remain part of the broader architecture for subsequent transformations and analytical models. They are not represented as completed by Phase 2.

## 6. Identity Resolution Output

The curated table contains:
- GA4 session-level fields.
- Synthetic identity mapping fields, including the synthetic user and CRM customer identifiers and mapping metadata.
- CRM customer profile attributes where a match is available.
- An identity resolution status indicating whether the session was identified.

The exact table schema in BigQuery is the source of truth for column-level definitions.

## 7. Architecture Status

**Phase 1 – Data source setup and synthetic dataset generation: Completed.**

**Phase 2 – Identity resolution: Completed.**

The final curated table was created and its final validation query executed successfully. Phase 2 established a session-to-CRM identity link using the project's synthetic mapping data.

The next phase is to build dbt models for sessions, orders and customer profiles. Customer analytics, marketing attribution and Tableau dashboards remain subsequent work.