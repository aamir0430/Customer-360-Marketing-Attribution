# Customer 360 & Marketing Attribution Programme

An end-to-end data analytics and marketing attribution project integrating website behavioural data, CRM customer information, and advertising data into a unified Customer 360 platform.

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

**Important:** Identity mapping is synthetic. Validation demonstrates consistency against generated mappings, not real-world identity-resolution accuracy.

## Technology Stack

| Technology | Purpose |
|---|---|
| Python and Pandas | Synthetic data generation and data preparation |
| Google BigQuery | Cloud data warehouse |
| SQL | Data preparation, identity resolution, and validation |
| dbt Core | Source staging and analytical data modelling |
| Tableau | Planned dashboards and visualization |
| Git and GitHub | Version control and project documentation |

## BigQuery Environment

- Google Cloud project: `customer-360-mta`
- Raw dataset: `customer_360_raw`
- Curated dataset: `customer_360_curated`
- dbt development dataset: `customer_360_dbt_dev`

## Implementation Progress

| Phase | Description | Status |
|---|---|---|
| Phase 1 | GA4 source selection and synthetic dataset generation | Completed |
| Phase 2 | BigQuery ingestion and customer identity resolution | Completed |
| Phase 3 | dbt modelling: sessions, orders, and customer profiles | Completed |
| Phase 4 | Customer analytics: RFM, segmentation, historical CLV and unified Customer 360 | Completed |
| Phase 5 | Marketing attribution modelling | Next |
| Phase 6 | Tableau dashboard development | Planned |
| Phase 7 | Final testing, validation, and documentation | Planned |

## Phase 4 – Customer Analytics

**Status: Completed**

dbt models delivered:

- `fct_customer_rfm`
- `fct_customer_rfm_scores`
- `dim_customer_segments`
- `fct_customer_clv`
- `dim_customer_360_analytics`

The unified model combines RFM metrics and scores, customer segments, recommended marketing actions, historical identified customer revenue, average order value, observed purchase span, and historical value segments. It retains all 5,000 CRM customers.

### Final unified-model validation

| Measure | Result |
|---|---:|
| Customers / distinct customer IDs | 5,000 / 5,000 |
| Purchasers | 2,091 |
| Non-purchasers | 2,909 |
| Identified customer orders | 2,504 |
| Identified customer revenue / historical CLV | $169,649 / $169,649 |
| Frequency mismatches | 0 |
| Revenue mismatches | 0 |
| Missing customer IDs, segments, eligibility or CLV records | 0 |

The model's RFM and CLV population, order totals, revenue totals and eligibility statuses reconcile.

**Identity-resolution limitation:** 1,948 orders worth $138,219 have no resolved CRM customer ID. They remain in the order-level model and are excluded from customer-level RFM and CLV rather than assigned to customers without evidence.

Historical CLV is descriptive, not predictive. The observed purchase span is the date difference between first and last observed purchases; it is not the full customer relationship duration. RFM labels are rule-based categories over the available historical period, not verified churn outcomes.

Detailed records:
- [Phase 4 technical documentation](documentation/phase_4_customer_analytics.md)
- [Phase 4 validation summary](documentation/phase_4_validation_summary.md)

## Documentation

Project documentation is maintained in `documentation/`, including architecture, data dictionary, methodology, project journal, decisions, testing, setup instructions, results, and the Phase 4 records above.

## Getting Started

### Prerequisites

- Python version compatible with installed dbt adapter and project dependencies.
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
.\\.venv\\Scripts\\Activate.ps1
```

### Install dependencies

```bash
pip install -r requirements.txt
```

Follow `documentation/setup_guide.md` and the dbt project configuration for Google Cloud authentication, BigQuery profile, and project-specific commands. Do not commit credentials, service-account keys, or local secrets.

## Current Project Status

**Phases 1–4 are completed. Phase 5 – Marketing Attribution – is next.**

The project now has a prepared BigQuery data foundation, a validated identity-resolved session table, core dbt marts, and a validated unified Customer 360 Analytics model. The next phase is marketing attribution modelling, followed by Tableau dashboards and final project validation.

## License

To be determined.