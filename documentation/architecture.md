# System Architecture
## Customer 360 & Marketing Attribution Programme

## 1. Overview

The Customer 360 & Marketing Attribution Programme is designed to integrate customer information from multiple sources into a unified analytical platform.

The architecture combines website behavioural data, CRM customer records, advertising campaign information, and identity mapping data to develop a consolidated customer view.

The solution uses Google BigQuery as its central data warehouse, Python for data generation and processing, SQL and dbt for transformations, and Tableau for visualization.

## 2. Data Sources

The project uses four primary data sources.

| Data Source | Technology | Description |
|---|---|---|
| Website Behavioural Data | GA4 / BigQuery | Ecommerce events, sessions, traffic sources and purchases |
| CRM Customer Data | Python / CSV | Synthetic customer records |
| Advertising Data | Python / CSV | Synthetic advertising campaign and spending information |
| Identity Mapping | Python / CSV | Mapping between customer identifiers across platforms |

### GA4 Dataset

Source:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

This dataset provides website interaction and ecommerce behavioural information.

### Synthetic Datasets

The following CSV files have been generated:

- `synthetic_crm_customers.csv`
- `synthetic_ad_spend.csv`
- `identity_mapping.csv`

These datasets supplement the GA4 behavioural information.

## 3. Technology Architecture

| Layer | Technology | Responsibility |
|---|---|---|
| Data Sources | GA4, CSV | Source data |
| Data Generation | Python, Pandas, Faker | Generate synthetic datasets |
| Data Warehouse | Google BigQuery | Centralized data storage |
| Data Transformation | SQL, dbt | Cleaning, modelling and transformation |
| Customer Analytics | SQL, Python | Identity resolution, RFM and CLV |
| Marketing Attribution | SQL, Python | Attribution modelling and marketing ROI |
| Visualization | Tableau | Interactive dashboards |
| Version Control | Git, GitHub | Source code and documentation management |

## 4. Planned Data Flow

The overall data flow is:

1. Extract website behavioural information from the GA4 public ecommerce dataset.
2. Generate synthetic CRM customer records.
3. Generate synthetic advertising spend information.
4. Generate synthetic identity mapping records.
5. Load the required source datasets into BigQuery.
6. Clean and standardize source data.
7. Implement identity resolution to connect website sessions with CRM customers.
8. Develop unified Customer 360 profiles.
9. Perform customer segmentation and lifetime value analysis.
10. Implement marketing attribution models.
11. Develop Tableau dashboards to communicate analytical findings.

## 5. Planned BigQuery Organization

The warehouse will use three primary datasets.

### Raw Layer

`customer_360_raw`

Stores source datasets in their original or minimally processed form.

### Staging Layer

`customer_360_staging`

Contains cleaned, standardized and validated source data.

### Analytics Layer

`customer_360_analytics`

Contains integrated customer profiles, analytical models, attribution results and reporting tables.

## 6. Planned Analytical Components

### Customer Identity Resolution

Connects customer identifiers across GA4 and CRM data sources.

### Customer 360

Creates consolidated customer profiles using available behavioural and CRM information.

### Customer Segmentation

Uses RFM analysis to classify customers according to recency, frequency and monetary value.

### Customer Lifetime Value

Calculates historical customer value using available purchase information.

### Marketing Attribution

Evaluates the contribution of different marketing channels using multiple attribution approaches.

### Tableau Dashboards

Communicates customer behaviour, marketing performance, revenue contribution and campaign effectiveness.

## 7. Architecture Status

**Current Status:** Initial architecture defined.

Phase 1 established the initial data sources and generated three synthetic datasets.

BigQuery ingestion, identity resolution, data modelling, analytical development and dashboard implementation are planned for subsequent phases.

The architecture will be updated as implementation progresses.