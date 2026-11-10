# Customer 360 & Marketing Attribution Programme

An end-to-end data analytics and marketing attribution project designed to integrate website behavioural data, CRM customer information, and advertising data into a unified Customer 360 platform.

The project aims to understand customer behaviour, connect anonymous website sessions with known customer identities, analyze customer value, and measure marketing campaign performance using data-driven analytics.

---

## Project Overview

Modern businesses interact with customers across multiple platforms, including websites, applications, CRM systems, and digital advertising channels.

However, customer information is often fragmented across these platforms, making it difficult to build a unified view of customers and accurately measure marketing effectiveness.

This project addresses that challenge by developing a Customer 360 analytics platform that:

- Integrates website behavioural data with CRM and advertising data.
- Implements customer identity resolution.
- Builds unified customer profiles.
- Analyzes customer journeys and purchasing behaviour.
- Performs RFM-based customer segmentation.
- Calculates Customer Lifetime Value (CLV).
- Implements multiple marketing attribution models.
- Measures marketing ROI, CPA, and campaign effectiveness.
- Develops interactive Tableau dashboards.

The project uses Google's public GA4 ecommerce sample dataset alongside synthetically generated CRM, advertising, and identity-mapping datasets.

## Project Objectives

1. Integrate website behavioural data, CRM records, and advertising data.
2. Build a data pipeline using Google BigQuery.
3. Implement identity resolution to connect website sessions with CRM customers.
4. Develop analytical data models using dbt.
5. Create unified Customer 360 customer profiles.
6. Perform customer segmentation and lifetime value analysis.
7. Implement first-touch, last-touch, linear, and time-decay attribution models.
8. Evaluate campaign performance using ROI, CPA, and conversion metrics.
9. Develop interactive Tableau dashboards.
10. Validate data quality and document the complete implementation.

---

## Data Sources

| Data Source | Dataset | Description |
|---|---|---|
| Website Behavioural Data | GA4 Ecommerce Sample | Public ecommerce event data hosted in BigQuery |
| CRM | `synthetic_crm_customers.csv` | Synthetically generated customer records |
| Advertising | `synthetic_ad_spend.csv` | Synthetically generated advertising campaign spending data |
| Identity Mapping | `identity_mapping.csv` | Synthetic mapping between website identifiers and CRM customer identifiers |

### 1. GA4 Ecommerce Sample Dataset

Source:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

This public dataset provides ecommerce website interaction data, including:

- Website events
- User identifiers
- Session information
- Traffic sources
- Campaign information
- Ecommerce events
- Purchase-related information

### 2. Synthetic Datasets

Three synthetic CSV datasets were generated using Python:

- `synthetic_crm_customers.csv`
- `synthetic_ad_spend.csv`
- `identity_mapping.csv`

These datasets provide the CRM customer records, advertising expenditure, and identity-mapping information required to build the Customer 360 platform.

**Important:** The identity mapping dataset is synthetic. Therefore, identity-resolution results demonstrate the implementation and validation of the matching logic against generated test data, rather than real-world identity-matching accuracy.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Synthetic data generation and data processing |
| Pandas | Data manipulation and processing |
| Google BigQuery | Cloud data warehouse and SQL-based analytics |
| SQL | Data extraction, transformation, identity resolution, and analytics |
| dbt | Data transformation and analytical modelling |
| Tableau | Interactive dashboards and visualization |
| Git | Version control |
| GitHub | Source code and project documentation |

---

## Project Architecture

The project follows a layered analytical architecture.

```text
                  DATA SOURCES
                       |
          +------------+------------+
          |            |            |
         GA4          CRM       Advertising
       Dataset       Data          Data
          |            |            |
          +------------+------------+
                       |
                DATA INGESTION
                       |
                       v
                 GOOGLE BIGQUERY
                       |
                       v
                RAW DATA LAYER
                customer_360_raw
                       |
                       v
              IDENTITY RESOLUTION
                       |
                       v
              CURATED DATA LAYER
              customer_360_curated
                       |
                       v
                 DBT MODELLING
                       |
          +------------+-------------+
          |            |             |
       Sessions      Orders     Customer Profiles
          |            |             |
          +------------+-------------+
                       |
                       v
              CUSTOMER 360 ANALYTICS
                       |
          +------------+-------------+
          |            |             |
       RFM / CLV   Attribution   Campaign ROI
          |            |             |
          +------------+-------------+
                       |
                       v
               TABLEAU DASHBOARDS
```

### BigQuery Dataset Organization

| Dataset | Purpose | Status |
|---|---|---|
| `customer_360_raw` | Stores the ingested GA4 sessions, CRM customers, and identity mapping data | Created |
| `customer_360_curated` | Stores the identity-resolved customer and session dataset | Created |
| `customer_360_staging` | Planned location for standardized and cleaned dbt staging models | Planned |
| `customer_360_analytics` | Planned location for final analytical models and outputs | Planned |

**Google Cloud Project ID:** `customer360-mta`

### Key Curated Table

`customer_360_curated.identity_resolved_sessions`

This table contains GA4 session records enriched with CRM customer information wherever a corresponding synthetic identity mapping exists.

It preserves all source sessions, including sessions that cannot be connected to a CRM customer.

---

## Repository Structure

```text
Customer-360-Marketing-Attribution/
│
├── data/
│   ├── raw/
│   ├── processed/
│   └── external/
│
├── python/
│   ├── generate_crm.py
│   ├── generate_ad_spend.py
│   └── identity_resolution.py
│
├── sql/
│   ├── 01_database_setup/
│   ├── 02_raw_data/
│   ├── 03_staging/
│   ├── 04_transformations/
│   ├── 05_customer_360/
│   ├── 06_analytics/
│   └── 07_validation/
│
├── dbt/
│   ├── models/
│   ├── tests/
│   ├── macros/
│   ├── seeds/
│   └── snapshots/
│
├── tableau/
│   ├── dashboards/
│   ├── data_sources/
│   └── screenshots/
│
├── documentation/
│   ├── architecture.md
│   ├── data_dictionary.md
│   ├── methodology.md
│   ├── project_journal.md
│   ├── decisions.md
│   ├── testing.md
│   ├── setup_guide.md
│   └── results.md
│
├── tests/
│
├── README.md
├── requirements.txt
└── .gitignore
```

---

## Implementation Progress

| Phase | Description | Status |
|---|---|---|
| Phase 1 | GA4 Data Source Setup and Synthetic Dataset Generation | Completed |
| Phase 2 | Customer Identity Resolution | Completed |
| Phase 3 | dbt Data Modelling – Sessions, Orders, and Customer Profiles | Planned |
| Phase 4 | Customer Analytics – RFM and CLV | Planned |
| Phase 5 | Marketing Attribution Modelling | Planned |
| Phase 6 | Tableau Dashboard Development | Planned |
| Phase 7 | Testing, Validation, and Final Documentation | Planned |

### Phase 1 – Dataset Generation and Preparation

**Status: Completed**

Deliverables:

- Selected the Google GA4 public ecommerce sample dataset in BigQuery.
- Inspected the GA4 dataset structure and relevant fields.
- Generated synthetic CRM customer records.
- Generated synthetic advertising spend data.
- Generated a synthetic identity mapping dataset.
- Established the initial data foundation for the project.

### Phase 2 – Customer Identity Resolution

**Status: Completed**

The objective of this phase was to connect GA4 website sessions with CRM customer records wherever a synthetic identity mapping was available.

Implementation completed:

- Prepared the three source datasets.
- Created the BigQuery project `customer360-mta`.
- Created the raw dataset `customer_360_raw`.
- Loaded the three source tables into BigQuery.
- Validated the ingested source tables.
- Implemented SQL-based identity resolution.
- Used a `LEFT JOIN` approach to preserve all GA4 sessions.
- Enriched identifiable sessions with CRM customer information.
- Created the curated dataset `customer_360_curated`.
- Created the final table `identity_resolved_sessions`.
- Executed final validation queries.

#### Source Tables

| Table | Row Count |
|---|---:|
| `customer_360_raw.ga4_sessions` | 360,129 |
| `customer_360_raw.crm_customers` | 5,000 |
| `customer_360_raw.identity_mapping` | 3,500 |

#### Identity Resolution Results

Final curated table:

`customer_360_curated.identity_resolved_sessions`

| Validation Metric | Result |
|---|---:|
| Total output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Identified records missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

#### Key Implementation Details

- All 360,129 source sessions were retained in the final curated table.
- Identified sessions were successfully linked to CRM customer records.
- Unidentified sessions were retained rather than discarded.
- An `identity_resolution_status` field distinguishes identified and unidentified sessions.
- Validation confirmed that the output contains no duplicate session records and no identified records with missing CRM customer matches.

**Key takeaway:** The identity-resolution process successfully connects available synthetic customer mappings while preserving the complete GA4 session population.

These results validate the implemented logic against the synthetic mapping dataset. They should not be interpreted as a measure of real-world identity-resolution performance.

### Phase 3 – dbt Data Modelling

**Status: Planned**

The next phase focuses on creating reusable and structured analytical models using dbt.

The planned models include:

- Sessions model
- Orders model
- Customer profile model

The objective is to transform the curated identity-resolved data into structured datasets that can support Customer 360 analytics and downstream marketing attribution.

### Future Phases

**Phase 4 – Customer Analytics**

- RFM analysis
- Customer segmentation
- Customer Lifetime Value (CLV)
- Customer behaviour analysis

**Phase 5 – Marketing Attribution**

- First-touch attribution
- Last-touch attribution
- Linear attribution
- Time-decay attribution
- Campaign ROI analysis
- Cost per Acquisition (CPA)

**Phase 6 – Tableau Dashboards**

- Customer 360 dashboard
- Customer segmentation dashboard
- Marketing performance dashboard
- Campaign attribution dashboard

**Phase 7 – Testing and Documentation**

- Data quality validation
- Model testing
- Analytical result validation
- Final project documentation
- Project presentation

---

## Documentation

Technical and project documentation is maintained in the `documentation/` directory.

| File | Description |
|---|---|
| `architecture.md` | System architecture, data flow, and component design |
| `data_dictionary.md` | Dataset descriptions and column definitions |
| `methodology.md` | Data preparation, identity resolution, and analytical methodology |
| `project_journal.md` | Chronological record of implementation progress |
| `decisions.md` | Important technical and architectural decisions |
| `testing.md` | Data quality checks and validation procedures |
| `setup_guide.md` | Environment setup and project configuration |
| `results.md` | Implementation results and validation findings |

---

## Getting Started

### Prerequisites

- Python 3.11 or a compatible version
- Google Cloud account with BigQuery access
- Google Cloud authentication
- Git
- VS Code or another Python development environment

### Installation

**1. Clone the repository**

```bash
git clone https://github.com/aamir0430/Customer-360-Marketing-Attribution.git
```

**2. Navigate to the project directory**

```bash
cd Customer-360-Marketing-Attribution
```

**3. Create a Python virtual environment**

```bash
python -m venv .venv
```

**4. Activate the virtual environment on Windows**

```powershell
.\.venv\Scripts\Activate.ps1
```

**5. Install dependencies**

```bash
pip install -r requirements.txt
```

**6. Configure environment variables**

Use `.env.example` as the reference for configuring the required environment variables.

**7. Follow the setup documentation**

Refer to:

`documentation/setup_guide.md`

for additional project configuration and setup instructions.

---

## Project Status

**Current Status: Phase 1 and Phase 2 Completed. Phase 3 – dbt Data Modelling – Next.**

The initial data foundation has been established using the GA4 public ecommerce sample dataset and three synthetic datasets.

The identity-resolution process has been implemented and validated successfully in BigQuery. The resulting curated dataset contains all 360,129 GA4 sessions, with identifiable sessions enriched using the available synthetic CRM mappings.

The next development milestone is to build dbt models for sessions, orders, and customer profiles, creating the foundation for subsequent Customer 360 analytics and marketing attribution.

---

## License

To be determined.