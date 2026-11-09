# Customer 360 & Marketing Attribution Programme

An end-to-end data analytics and business intelligence project designed to integrate website, CRM, and advertising data into a unified customer view to understand customer behaviour, customer value, and marketing performance.

## Project Overview

Modern businesses interact with customers across multiple platforms, including websites, applications, CRM systems, and digital advertising channels.

However, customer information is often fragmented across these platforms.

This project aims to address this challenge by developing a Customer 360 analytics platform that connects customer identities, consolidates behavioural and transactional information, and evaluates marketing performance through data-driven attribution models.

The solution will use real-world sample ecommerce behavioural data alongside synthetic CRM and advertising datasets.

## Project Objectives

- Integrate website behavioural data with CRM and advertising data.
- Develop a customer identity resolution process.
- Build unified Customer 360 profiles.
- Analyze customer journeys and purchasing behaviour.
- Perform RFM-based customer segmentation.
- Calculate historical Customer Lifetime Value (CLV).
- Implement multiple marketing attribution models.
- Measure marketing ROI, CPA, and campaign effectiveness.
- Develop interactive Tableau dashboards.

## Data Sources

| Data Source | Dataset | Description |
|---|---|---|
| Website Behavioural Data | GA4 Ecommerce Sample | Public ecommerce event data hosted in BigQuery |
| CRM | `synthetic_crm_customers.csv` | Synthetic customer records |
| Advertising | `synthetic_ad_spend.csv` | Synthetic campaign spending data |
| Identity Mapping | `identity_mapping.csv` | Synthetic mapping between customer identifiers |

### GA4 Data Source

Google Analytics 4 public ecommerce sample dataset:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

The GA4 dataset provides website interaction, session, traffic source, and ecommerce event information.

### Synthetic Datasets

Three synthetic CSV datasets have been generated using Python:

1. `synthetic_crm_customers.csv`
2. `synthetic_ad_spend.csv`
3. `identity_mapping.csv`

These datasets provide the additional CRM, advertising, and identity information required for the project.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python | Synthetic data generation and identity resolution |
| Pandas | Data processing and manipulation |
| Google BigQuery | Cloud data warehouse |
| SQL | Data extraction, transformation, and analytics |
| dbt | Data transformation and modelling |
| Tableau | Interactive dashboards and visualization |
| Git | Version control |
| GitHub | Source code and project documentation |

## Project Architecture

The planned analytical workflow:

**Data Sources → Data Ingestion → BigQuery → SQL/dbt Transformations → Customer 360 & Marketing Attribution Analytics → Tableau Dashboards**

### Planned BigQuery Dataset Organization

- `customer_360_raw` – Source datasets.
- `customer_360_staging` – Cleaned and standardized data.
- `customer_360_analytics` – Final analytical models and outputs.

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

## Implementation Progress

| Phase | Description | Status |
|---|---|---|
| Phase 1 | GA4 Data Source Setup and Synthetic Dataset Generation | Completed |
| Phase 2 | Customer Identity Resolution | In Progress |
| Phase 3 | Customer 360 Data Integration and Modelling | Planned |
| Phase 4 | Customer Analytics – RFM and CLV | Planned |
| Phase 5 | Marketing Attribution Modelling | Planned |
| Phase 6 | Tableau Dashboard Development | Planned |
| Phase 7 | Testing, Validation and Documentation | Planned |

### Phase 1 – Completed Deliverables

- Selected the GA4 public ecommerce sample dataset in BigQuery.
- Inspected the GA4 dataset structure and relevant fields.
- Generated synthetic CRM customer data.
- Generated synthetic advertising spend data.
- Generated a synthetic identity mapping dataset.
- Established the initial data foundation for the project.

### Phase 2 – Current Work

The next phase focuses on connecting website sessions with CRM customer records.

Initial activities:

- Prepare the three generated CSV files.
- Load the required datasets into BigQuery.
- Validate the source tables.
- Develop identity resolution logic using SQL.
- Connect anonymous website activity with known customer identities.

## Documentation

Project documentation is maintained in the `documentation/` directory.

- Project Journal – Chronological implementation progress.
- Technical Decision Log – Important architectural and technical decisions.
- Architecture – System architecture and data flow.
- Data Dictionary – Dataset and column descriptions.
- Methodology – Analytical approaches and methodologies.
- Testing – Data quality checks and validation results.

## Getting Started

### Prerequisites

- Python 3.11 or compatible version.
- Google Cloud account with BigQuery access.
- Google Cloud authentication.
- Git.
- VS Code or another Python development environment.

### Installation

Clone the repository:

```bash
git clone https://github.com/YOUR_USERNAME/Customer-360-Marketing-Attribution.git
```

Navigate into the project:

```bash
cd Customer-360-Marketing-Attribution
```

Create a virtual environment:

```bash
python -m venv .venv
```

Activate it on Windows:

```powershell
.\.venv\Scripts\Activate.ps1
```

Install dependencies:

```bash
pip install -r requirements.txt
```

Configure environment variables using `.env.example`.

Refer to `documentation/setup_guide.md` for additional setup instructions.

## Project Status

**Current Status: Phase 1 Completed – Phase 2 In Progress.**

The initial data foundation has been established, with three synthetic datasets generated and the GA4 public ecommerce sample selected as the behavioural data source.

Development is currently progressing towards BigQuery ingestion and customer identity resolution.

## License

To be determined.