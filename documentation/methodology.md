# Project Methodology
## Customer 360 & Marketing Attribution Programme

## 1. Overview

The project follows a structured analytics workflow:

1. Source data preparation.
2. BigQuery ingestion.
3. Customer identity resolution.
4. dbt data modelling.
5. Customer analytics.
6. Marketing attribution.
7. Advertising performance analysis.
8. Campaign ROI and CPA analysis.
9. Tableau visualization.
10. Final validation.

The project combines Google's public GA4 ecommerce sample with synthetic CRM, identity mapping, and advertising data.

## 2. Data Source Methodology

### GA4

Source:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

The GA4 public ecommerce dataset provides event-level website and purchase information.

The project uses the available event and session information to construct analytical session, order, and conversion journey models.

The source period used is November 2020 through January 2021.

### Synthetic CRM

Python was used to generate synthetic CRM customer records.

These records support customer identity enrichment, customer profile modelling, RFM analysis, and historical CLV.

### Synthetic Identity Mapping

A separate synthetic mapping dataset connects website-side identifiers with CRM customer identifiers.

This allows identity-resolution logic to be developed and validated without using real customer identity data.

### Synthetic Advertising Data

A synthetic advertising spend dataset contains campaign-date performance information, including impressions, clicks, simulated conversions, and spend.

It is treated as a separate source from GA4 purchase revenue unless a verified mapping can be established.

## 3. BigQuery Data Organization

The project uses:

- `customer_360_raw`
- `customer_360_curated`
- `customer_360_dbt_dev`

Raw and prepared source tables are stored in the raw dataset.

Identity-resolution output is stored in the curated dataset.

dbt development models are materialized in the development dataset.

## 4. Customer Identity Resolution – Phase 2

### Objective

Link GA4 sessions to CRM customer records wherever a corresponding synthetic identity mapping exists.

### Workflow

1. Load GA4 sessions, CRM customers, and identity mapping into BigQuery.
2. Inspect source identifiers and mapping records.
3. Preview joins between session, mapping, and CRM data.
4. Validate mapping consistency.
5. Create `customer_360_curated.identity_resolved_sessions`.
6. Preserve unmatched sessions.
7. Execute population, uniqueness, and referential-integrity checks.

### Join approach

LEFT JOIN logic is used so that unmatched sessions remain in the output.

The output distinguishes `IDENTIFIED` and `UNIDENTIFIED` records.

### Recorded validation

| Measure | Result |
|---|---:|
| Total output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

The identity mapping is synthetic and does not demonstrate real-world identity accuracy.

## 5. dbt Data Modelling – Phase 3

### Objective

Build reusable analytical models using dbt Core and BigQuery.

### Configuration

- dbt project: `customer_360`
- dbt Core: 1.12.7
- dbt-bigquery: 1.12.3
- Target dataset: `customer_360_dbt_dev`

### Staging models

- `stg_ga4_sessions`
- `stg_ga4_events`
- `stg_crm_customers`
- `stg_identity_mapping`
- `stg_identity_resolved_sessions`

### Core marts

- `fct_sessions`
- `fct_orders`
- `dim_customer_profile`

The staging layer standardizes source information. Intermediate transformations are configured as ephemeral models where appropriate.

The core marts were created and their outputs validated.

## 6. Customer Analytics – Phase 4

### Objective

Build customer-level analytical metrics and a unified Customer 360 model.

### RFM workflow

1. Calculate customer recency.
2. Calculate purchase frequency.
3. Calculate monetary value.
4. Assign RFM scores.
5. Classify customers into segments.
6. Validate segment assignments and revenue totals.

### CLV workflow

Historical customer revenue is calculated using resolved customer purchase records.

The resulting historical value metrics are combined with RFM information in the unified Customer 360 model.

### Models

- `fct_customer_rfm`
- `fct_customer_rfm_scores`
- `dim_customer_segments`
- `fct_customer_clv`
- `dim_customer_360_analytics`

### Final validation

| Measure | Result |
|---|---:|
| CRM customers | 5,000 |
| Purchasers | 2,091 |
| Non-purchasers | 2,909 |
| Identified customer orders | 2,504 |
| Identified customer revenue | $169,649 |
| Historical CLV revenue | $169,649 |
| Frequency mismatches | 0 |
| Revenue mismatches | 0 |
| Missing customer segments | 0 |
| Missing CLV records | 0 |

A total of 1,948 orders worth $138,219 have no resolved CRM customer ID. They remain outside customer-level RFM and CLV calculations.

Historical CLV is descriptive, not predictive.

## 7. Marketing Attribution – Phase 5

### Objective

Evaluate how different attribution approaches allocate GA4 purchase revenue across observed eligible touchpoints.

### Conversion journey model

The model `fct_conversion_journeys` connects purchase transactions with eligible preceding touchpoints.

The model operates at transaction-touchpoint grain.

Recorded model validation:

- 4,452 transactions.
- 11,496 transaction-touchpoint records.
- 9,144 distinct touchpoint sessions.

### First-touch and last-touch

The earliest eligible touchpoint receives full credit under first-touch attribution.

The latest eligible touchpoint receives full credit under last-touch attribution.

### Linear attribution

Credit is equally distributed across all eligible touchpoints for a transaction.

### Time-decay attribution

The model calculates a time-based weight:

`Weight = 0.5 ^ (Seconds Before Conversion / (7 * 24 * 60 * 60))`

The weights are normalized within each transaction.

The seven-day half-life is a modelling assumption.

### Attribution comparison

Model:

`fct_attribution_comparison`

The consolidated model supports channel-level and model-level comparisons.

### Reconciliation results

| Model | Transactions | Total Credit | Attributed Revenue |
|---|---:|---:|---:|
| First Touch | 4,452 | 4,452 | $307,868 |
| Last Touch | 4,452 | 4,452 | $307,868 |
| Linear | 4,452 | 4,452 | $307,868 |
| Time Decay | 4,452 | 4,452 | $307,868 |

The models represent alternative allocations of the same underlying purchase revenue.

## 8. Advertising Performance – Phase 5

### Objective

Create a structured advertising performance layer from synthetic advertising records.

### Source

`customer_360_raw.ad_spend_unpartitioned`

### Models

- `fct_ad_spend_performance`
- `fct_campaign_performance_summary`
- `fct_channel_performance_summary`

### Recorded advertising totals

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Campaign-date records | 736 |
| Dates | 92 |
| Impressions | 9,246,272 |
| Clicks | 186,706 |
| Simulated conversions | 6,231 |
| Spend | $126,552.23 |

Metrics include CTR, CPC, simulated conversion rate, and cost per simulated conversion.

### Campaign mapping limitation

The synthetic campaign identifiers could not be reliably linked to GA4 purchase revenue.

One exact source/medium match was found, but the GA4 campaign value did not establish a verified mapping to synthetic campaign IDs.

Therefore, actual campaign ROI and GA4-based CPA remain unresolved.

## 9. Consolidated Marketing Reporting

Model:

`fct_marketing_performance_reporting`

The model contains 148 records:

- 8 synthetic advertising performance records.
- 140 GA4 attribution performance records.

The two data sources are intentionally kept separate.

This prevents unsupported attribution of GA4 purchase revenue to synthetic advertising campaigns.

## 10. Phase 6 – Campaign ROI and CPA

This phase will investigate whether a reliable campaign-level relationship can be established between advertising expenditure and GA4 purchase conversions.

The analysis will:

1. Reinspect available campaign identifiers.
2. Investigate source and medium fields.
3. Evaluate campaign-date compatibility.
4. Establish a defensible mapping if the data supports one.
5. Calculate actual campaign CPA and ROI only where valid.
6. Document metrics that cannot be calculated reliably.
7. Validate spend, conversion, and revenue reconciliation.

If reliable mapping cannot be established, actual campaign ROI and GA4-based CPA will be reported as unavailable rather than estimated from unrelated datasets.

## 11. Phase 7 – Tableau Visualization

The validated analytical models will be connected to Tableau.

Planned dashboard areas include:

- Customer 360 overview.
- RFM customer segmentation.
- Historical customer value.
- Attribution model comparison.
- Campaign performance.
- Marketing efficiency.
- Budget recommendations.

## 12. Phase 8 – Final Validation

Final validation will cover:

- Data quality.
- Model grain.
- Referential integrity.
- Revenue reconciliation.
- Attribution credit reconciliation.
- Advertising performance reconciliation.
- Dashboard metric accuracy.
- Documentation completeness.