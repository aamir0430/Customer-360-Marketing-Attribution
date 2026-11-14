# Customer 360 & Marketing Attribution Programme

An end-to-end data analytics and marketing attribution project that integrates website behavioural data, CRM customer information, and advertising data into a unified Customer 360 platform.

The project uses Google's public GA4 ecommerce sample alongside synthetic CRM, advertising, and identity-mapping datasets. BigQuery is the warehouse, dbt is the transformation layer, and Tableau is planned for analytical dashboards.

## Project Objectives

- Integrate website behavioural data with CRM and advertising data.
- Resolve available links between anonymous website activity and CRM customer identities.
- Build reusable session, order, and customer-profile models.
- Perform RFM customer segmentation and historical Customer Lifetime Value (CLV) analysis.
- Implement marketing attribution models.
- Measure campaign performance using metrics such as ROAS and CPA.
- Develop interactive Tableau dashboards.
- Validate and document the data pipeline.

## Data Sources

| Source | Dataset / file | Description |
|---|---|---|
| GA4 | `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` | Public ecommerce event data |
| CRM | `synthetic_crm_customers.csv` / `customer_360_raw.crm_customers` | Synthetic customer records |
| Advertising | `synthetic_ad_spend.csv` | Synthetic campaign spending data |
| Identity mapping | `identity_mapping.csv` / `customer_360_raw.identity_mapping` | Synthetic website-to-CRM identity mapping |
| Prepared sessions | `customer_360_raw.ga4_sessions` | Session-level GA4 data |
| Curated sessions | `customer_360_curated.identity_resolved_sessions` | GA4 sessions enriched with CRM identity data where a mapping exists |

**Important:** The identity mapping is synthetic. The identity-resolution validation demonstrates the consistency of the implemented logic against generated mappings; it does not measure real-world identity-resolution accuracy.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python and Pandas | Synthetic data generation and data preparation |
| Google BigQuery | Cloud data warehouse |
| SQL | Data preparation, identity resolution, and validation |
| dbt Core | Source staging and analytical data modelling |
| Tableau | Planned dashboards and visualization |
| Git and GitHub | Version control and project documentation |

## Architecture

```text
GA4 + Synthetic CRM + Synthetic Advertising + Identity Mapping
                              |
                              v
                         BigQuery
                              |
                  Raw source datasets
                              |
                              v
                   Identity resolution
                              |
                              v
               Curated identity-resolved sessions
                              |
                              v
                         dbt Core
                              |
                Source-aligned staging models
                              |
                  Intermediate transformations
                              |
                              v
               +--------------+---------------+
               |              |               |
           fct_sessions   fct_orders   dim_customer_profile
               |              |               |
               +--------------+---------------+
                              |
                              v
                 Customer and marketing analytics
                              |
                              v
                       Tableau dashboards
```

### BigQuery datasets

| Dataset | Purpose | Status |
|---|---|---|
| `customer_360_raw` | Raw/prepared source tables | Created and used |
| `customer_360_curated` | Curated identity-resolution output | Created and used |
| `customer_360_dbt_dev` | dbt development target for model outputs | Created and used in Phase 3 |

Google Cloud project: `customer360-mta`.

## Repository Structure

```text
Customer-360-Marketing-Attribution/
├── data/
│   ├── raw/
│   ├── processed/
│   └── external/
├── python/
│   ├── generate_crm.py
│   ├── generate_ad_spend.py
│   └── identity_resolution.py
├── sql/
│   ├── 01_database_setup/
│   ├── 02_raw_data/
│   ├── 03_staging/
│   ├── 04_transformations/
│   ├── 05_customer_360/
│   ├── 06_analytics/
│   └── 07_validation/
├── dbt/
│   ├── models/
│   ├── tests/
│   ├── macros/
│   ├── seeds/
│   └── snapshots/
├── tableau/
│   ├── dashboards/
│   ├── data_sources/
│   └── screenshots/
├── documentation/
│   ├── architecture.md
│   ├── data_dictionary.md
│   ├── methodology.md
│   ├── project_journal.md
│   ├── decisions.md
│   ├── testing.md
│   ├── setup_guide.md
│   └── results.md
├── tests/
├── README.md
├── requirements.txt
└── .gitignore
```

The structure above describes the intended repository organization. Keep this tree synchronized with the actual checked-in files as the project evolves.

## Implementation Progress

| Phase | Description | Status |
|---|---|---|
| Phase 1 | GA4 source selection and synthetic dataset generation | Completed |
| Phase 2 | BigQuery ingestion and customer identity resolution | Completed |
| Phase 3 | dbt modelling: sessions, orders, and customer profiles | Completed |
| Phase 4 | Customer analytics: RFM and CLV | Next |
| Phase 5 | Marketing attribution modelling | Planned |
| Phase 6 | Tableau dashboard development | Planned |
| Phase 7 | Final testing, validation, and documentation | Planned |

### Phase 1 – Data Foundation

- Selected the GA4 public ecommerce sample dataset.
- Generated synthetic CRM customer data.
- Generated synthetic advertising spend data.
- Generated synthetic identity mapping data.

### Phase 2 – Identity Resolution

Raw BigQuery tables:

| Table | Recorded row count |
|---|---:|
| `customer_360_raw.ga4_sessions` | 360,129 |
| `customer_360_raw.crm_customers` | 5,000 |
| `customer_360_raw.identity_mapping` | 3,500 |

Created `customer_360_curated.identity_resolved_sessions` using LEFT JOIN-based enrichment to preserve every source session.

| Validation metric | Result |
|---|---:|
| Output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Identified records missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

Identified and unidentified sessions reconcile to the complete session population. These are results from synthetic identity mappings, not real-world match-accuracy measurements.

### Phase 3 – dbt Data Modelling

**Status: Completed**

The dbt project (`customer_360`) was configured to use BigQuery. Its configured source inventory includes GA4 sessions, GA4 events, CRM customers, identity mapping, and the curated identity-resolved sessions table.

Staging models created:

- `stg_ga4_sessions`
- `stg_ga4_events`
- `stg_crm_customers`
- `stg_identity_mapping`
- `stg_identity_resolved_sessions`

Core analytical marts created and validated:

- `fct_sessions`
- `fct_orders`
- `dim_customer_profile`

Staging models are configured as views. Intermediate transformations use ephemeral materialization where configured. The dbt development target dataset is `customer_360_dbt_dev`.

Project checks and documentation:
- `dbt debug` completed with all checks passing after resolving the local environment compatibility issue.
- `dbt parse` completed successfully.
- `dbt docs generate` completed and generated the catalog at `dbt/target/catalog.json`.
- Documentation generation emitted non-fatal `agate` `table_owner` warnings.

The completion record confirms that the three core mart outputs were validated. Exact final dbt test/build totals and individual model row counts are not stated here because those numerical outputs were not captured in the available project notes.

## Documentation

Project documentation is maintained in `documentation/`:

| File | Purpose |
|---|---|
| `architecture.md` | System architecture, data flow, and dbt layers |
| `data_dictionary.md` | Source and model inventory and data definitions |
| `methodology.md` | Data preparation, identity resolution, and dbt modelling methods |
| `project_journal.md` | Chronological implementation record |
| `decisions.md` | Technical and architectural decisions |
| `testing.md` | Testing approach and recorded validation |
| `setup_guide.md` | Environment setup instructions |
| `results.md` | Phase results and validation findings |

## Getting Started

### Prerequisites

- Python version compatible with the installed dbt adapter and project dependencies.
- Google Cloud account with BigQuery access.
- Google Cloud authentication and permissions for the project/datasets.
- Git.
- VS Code or another development environment.

### Clone the repository

```bash
git clone https://github.com/aamir0430/Customer-360-Marketing-Attribution.git
cd Customer-360-Marketing-Attribution
```

### Create and activate a virtual environment (Windows PowerShell)

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

### Install Python dependencies

```bash
pip install -r requirements.txt
```

Follow `documentation/setup_guide.md` and the dbt project configuration for the required Google Cloud authentication, BigQuery profile, and project-specific commands. Do not commit credentials, service-account keys, or local secrets.

## Current Project Status

**Phases 1, 2, and 3 are completed. Phase 4 – Customer Analytics – is next.**

The project has a prepared BigQuery data foundation, a validated identity-resolved session table, and a dbt modelling layer containing session, order, and customer-profile marts. The next phase is to implement RFM segmentation and historical CLV, followed by marketing attribution and Tableau dashboards.

## License

To be determined.