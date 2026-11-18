# Customer 360 & Marketing Attribution Programme

An end-to-end data analytics project integrating website behavioural data, CRM customer information, and advertising data to build a unified Customer 360 analytical platform.

The project uses Google's public GA4 ecommerce sample dataset alongside synthetic CRM, identity-mapping, and advertising datasets. Google BigQuery serves as the data warehouse, dbt Core manages data transformation and modelling, SQL implements analytical logic, and Tableau is planned for business intelligence and visualization.

---

## Project Objectives

- Integrate website behavioural data with CRM customer information.
- Resolve available links between anonymous website activity and CRM customer identities.
- Build reusable session, order, and customer-profile models.
- Perform RFM analysis and customer segmentation.
- Calculate historical Customer Lifetime Value (CLV).
- Implement and compare first-touch, last-touch, linear, and time-decay attribution models.
- Analyze advertising spend and campaign performance.
- Calculate campaign ROI and CPA where reliable campaign-to-conversion mapping is available.
- Develop interactive Tableau dashboards and data-driven marketing recommendations.
- Maintain data quality, testing, documentation, and reproducibility.

---

## Data Sources

| Source | Dataset / File | Description |
|---|---|---|
| GA4 | `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` | Public ecommerce event data |
| CRM | `synthetic_crm_customers.csv` | Synthetic customer records |
| Identity Mapping | `identity_mapping.csv` | Synthetic website-to-CRM identity mapping |
| Advertising | `Synthetic Advertising Spend.csv` | Synthetic campaign and advertising spend data |
| Prepared GA4 Sessions | `customer_360_raw.ga4_sessions` | Session-level behavioural data |
| Curated Sessions | `customer_360_curated.identity_resolved_sessions` | GA4 sessions enriched with CRM identity information where a mapping exists |

**Data limitation:** CRM, identity mapping, and advertising data are synthetic. The GA4 dataset is a public sample. Results should be interpreted as an analytical project demonstration, not as verified production business performance.

---

## Technology Stack

| Technology | Purpose |
|---|---|
| Python 3.11.4 | Synthetic data generation and preparation |
| Pandas | Data manipulation |
| Google BigQuery | Cloud data warehouse |
| SQL | Data preparation, transformation, analytics, and validation |
| dbt Core 1.12.7 | Data modelling and transformation |
| dbt-bigquery 1.12.3 | BigQuery adapter |
| Tableau | Planned business intelligence dashboards |
| Git and GitHub | Version control and project documentation |

---

## BigQuery Environment

| Configuration | Value |
|---|---|
| Google Cloud Project | `customer-360-mta` |
| BigQuery Location | `US` |
| Raw Dataset | `customer_360_raw` |
| Curated Dataset | `customer_360_curated` |
| dbt Development Dataset | `customer_360_dbt_dev` |
| dbt Project | `customer_360` |

---

## Project Implementation Progress

| Phase | Description | Status |
|---|---|---|
| Phase 1 | GA4 source selection and synthetic dataset generation | Completed |
| Phase 2 | BigQuery ingestion and customer identity resolution | Completed |
| Phase 3 | dbt modelling: sessions, orders, and customer profiles | Completed |
| Phase 4 | RFM analysis, customer segmentation, historical CLV, and unified Customer 360 | Completed |
| Phase 5 | Marketing attribution modelling and advertising performance foundations | Completed |
| Phase 6 | Campaign ROI, CPA, and marketing efficiency analysis | Next |
| Phase 7 | Tableau dashboards and marketing recommendations | Planned |
| Phase 8 | Final testing, validation, and project completion | Planned |

---

## Phase 1 – Data Source Setup

The project uses Google's public GA4 ecommerce sample dataset and three synthetic datasets:

- Synthetic CRM customer records.
- Synthetic identity mapping records.
- Synthetic advertising spend records.

The GA4 sample covers November 2020 through January 2021.

The synthetic advertising dataset contains:

- 8 campaigns.
- 736 campaign-date records.
- 92 dates.
- 9,246,272 impressions.
- 186,706 clicks.
- 6,231 simulated conversions.
- USD 126,552.23 advertising spend.

---

## Phase 2 – Customer Identity Resolution

Created the curated BigQuery table:

`customer_360_curated.identity_resolved_sessions`

The identity-resolution process links GA4 session identifiers to CRM customer identifiers through a synthetic mapping dataset.

A LEFT JOIN approach preserves unmatched sessions instead of discarding them.

The identity-resolution output distinguishes:

- `IDENTIFIED`
- `UNIDENTIFIED`

The mapping is synthetic and therefore does not establish real-world identity-resolution accuracy.

---

## Phase 3 – dbt Data Modelling

Created the dbt staging layer and core analytical models.

### Core models

- `fct_sessions`
- `fct_orders`
- `dim_customer_profile`

The dbt project uses BigQuery as its warehouse and `customer_360_dbt_dev` as its development dataset.

---

## Phase 4 – Customer Analytics

**Status: Completed**

Created the following analytical models:

- `fct_customer_rfm`
- `fct_customer_rfm_scores`
- `dim_customer_segments`
- `fct_customer_clv`
- `dim_customer_360_analytics`

### Final Customer 360 validation

| Measure | Result |
|---|---:|
| Total CRM customers | 5,000 |
| Distinct customer IDs | 5,000 |
| Purchasers | 2,091 |
| Non-purchasers | 2,909 |
| Identified customer orders | 2,504 |
| Identified customer revenue | $169,649 |
| Historical CLV revenue | $169,649 |
| Frequency mismatches | 0 |
| Revenue mismatches | 0 |
| Missing customer segments | 0 |
| Missing CLV records | 0 |

The unified Customer 360 model retains all 5,000 CRM customers.

**Identity-resolution limitation:** 1,948 orders worth $138,219 do not have a resolved CRM customer ID. These orders remain in the order-level model and are excluded from customer-level RFM and CLV calculations.

Historical CLV is descriptive rather than predictive.

Detailed documentation:
- `documentation/phase_4_customer_analytics.md`
- `documentation/phase_4_validation_summary.md`

---

## Phase 5 – Marketing Attribution

**Status: Completed**

Implemented four attribution models:

1. First-Touch Attribution
2. Last-Touch Attribution
3. Linear Attribution
4. Time-Decay Attribution

### dbt models

- `fct_conversion_journeys`
- `fct_first_last_touch_attribution`
- `fct_linear_attribution`
- `fct_time_decay_attribution`
- `fct_attribution_comparison`
- `fct_ad_spend_performance`
- `fct_campaign_performance_summary`
- `fct_channel_performance_summary`
- `fct_marketing_performance_reporting`

### Attribution validation results

| Measure | Result |
|---|---:|
| Total transactions | 4,452 |
| Total purchase revenue | $307,868 |
| First-touch attribution credit | 4,452 |
| Last-touch attribution credit | 4,452 |
| Linear attribution credit | 4,452 |
| Time-decay attribution credit | 4,452 |
| Linear attribution rows | 11,496 |
| Time-decay attribution rows | 11,496 |

All four attribution models reconcile to the same underlying transaction population and purchase revenue.

The time-decay model uses a seven-day half-life as a modelling assumption.

### Advertising performance foundations

The synthetic advertising data was modelled separately from GA4 purchase attribution.

Advertising metrics include:

- Impressions.
- Clicks.
- Simulated conversions.
- Advertising spend.
- Click-through rate.
- Cost per click.
- Simulated conversion rate.
- Cost per simulated conversion.

### Important campaign measurement limitation

The synthetic advertising campaigns could not be reliably mapped to GA4 purchase revenue at the campaign-ID level.

Only one exact source/medium combination matched, and this did not establish a verified campaign mapping.

Therefore:

- Synthetic cost per simulated conversion is available.
- Actual campaign CPA based on GA4 purchases is not yet established.
- Campaign-level ROAS and ROI are not yet defensible.
- Advertising spend and GA4 attributed revenue must not be joined without a verified mapping.

The consolidated reporting model intentionally keeps synthetic advertising performance and GA4 attribution performance separate.

---

## Current Project Status

**Phases 1–5 are completed. Phase 6 – Campaign ROI, CPA, and Marketing Efficiency Analysis – is next.**

The next phase will investigate campaign-level mapping, calculate defensible campaign performance metrics where the available data supports them, and document any remaining limitations.

Phase 7 will focus on Tableau dashboards and marketing recommendations.

---

## Repository Documentation

Technical documentation is maintained in the `documentation/` directory.

| File | Description |
|---|---|
| `architecture.md` | Overall project architecture and data flow |
| `data_dictionary.md` | Source tables and analytical models |
| `definitions.md` | Business metrics and analytical definitions |
| `methodology.md` | Data processing and analytical methodology |
| `project_journal.md` | Phase-wise implementation history |
| `results.md` | Project results and analytical findings |
| `setup_guide.md` | Environment and project setup instructions |
| `testing.md` | Testing and validation records |
| `decisions.md` | Technical decision log |
| `phase_4_customer_analytics.md` | Phase 4 technical documentation |
| `phase_4_validation_summary.md` | Phase 4 validation results |

---

## Getting Started

Clone the repository:

```bash
git clone https://github.com/aamir0430/Customer-360-Marketing-Attribution.git
cd Customer-360-Marketing-Attribution
```

Create and activate the Python environment:

```powershell
python -m venv .venv
.\.venv\Scripts\Activate.ps1
```

Install project dependencies:

```bash
pip install -r requirements.txt
```

Activate the dbt environment and run:

```bash
dbt debug
dbt parse
```

For further configuration, refer to:

`documentation/setup_guide.md`

Never commit credentials, service-account keys, passwords, or local environment secrets.

---

## License

To be determined.