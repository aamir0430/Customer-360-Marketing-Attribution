# Project Journal
## Customer 360 & Marketing Attribution Programme

This journal records the implementation progress, major technical activities, decisions, and outcomes of the project.

---

## Phase 1 – Data Source Setup and Synthetic Dataset Generation

**Status: Completed**

### Activities

- Selected Google's public GA4 ecommerce sample.
- Generated synthetic CRM customer records.
- Generated synthetic advertising spend records.
- Generated synthetic identity mapping records.
- Prepared source datasets for BigQuery ingestion.

### Outcome

The project established its initial source-data foundation using public GA4 data and synthetic supporting datasets.

---

## Phase 2 – BigQuery Ingestion and Identity Resolution

**Status: Completed**

### Activities

- Loaded prepared GA4 session data into BigQuery.
- Loaded synthetic CRM customer records.
- Loaded synthetic identity mapping records.
- Inspected source identifiers.
- Tested joins between GA4 sessions, identity mapping, and CRM.
- Created `customer_360_curated.identity_resolved_sessions`.
- Validated population preservation and mapping consistency.

### Final validation

| Measure | Result |
|---|---:|
| Total sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented | 3,500 |
| Missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

### Outcome

Identity resolution was implemented successfully.

The synthetic identity mapping was used to validate the technical workflow. It does not establish real-world identity accuracy.

---

## Phase 3 – dbt Data Modelling

**Status: Completed**

### Activities

- Configured the dbt Core project.
- Configured the BigQuery adapter.
- Resolved local Python package compatibility issues.
- Configured BigQuery sources.
- Created five staging models.
- Created core session, order, and customer-profile models.
- Validated the core model outputs.
- Generated dbt documentation.

### Core models

- `fct_sessions`
- `fct_orders`
- `dim_customer_profile`

### Outcome

The dbt transformation layer was established successfully and the core analytical marts were validated.

---

## Phase 4 – RFM Analysis, Customer Segmentation, and Historical CLV

**Status: Completed**

### Activities

- Developed customer RFM metrics.
- Created RFM scoring logic.
- Created customer segmentation.
- Calculated historical CLV.
- Developed the unified Customer 360 analytical model.
- Executed final model validation.
- Reviewed segment and value distributions.

### Models

- `fct_customer_rfm`
- `fct_customer_rfm_scores`
- `dim_customer_segments`
- `fct_customer_clv`
- `dim_customer_360_analytics`

### Final results

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
| Missing segments | 0 |
| Missing CLV records | 0 |

### Important findings

- The unified Customer 360 model contains one row per CRM customer.
- RFM and historical CLV totals reconcile.
- 1,948 orders worth $138,219 do not have a resolved CRM customer ID.
- Unresolved orders were not assigned to customers without evidence.
- Historical CLV is descriptive, not predictive.

### Outcome

Phase 4 completed with successful final unified-model validation.

---

## Phase 5 – Marketing Attribution and Advertising Performance

**Status: Completed**

### Step 5.1 – Source Profiling

- Inspected the available GA4 and advertising source data.
- Reviewed source fields and campaign attributes.
- Identified the available traffic-source information.
- Investigated advertising data structure and campaign identifiers.

### Step 5.2 – Marketing Touchpoints

- Developed the marketing touchpoint model.
- Connected session-level traffic information with the attribution workflow.
- Validated the resulting touchpoint data.

### Step 5.3 – Conversion Journey Modelling

Created:

`fct_conversion_journeys`

The model connects purchase transactions with eligible preceding touchpoints.

Recorded validation:

- 4,452 transactions.
- 11,496 journey-touchpoint records.
- 9,144 distinct touchpoint sessions.

### Step 5.4 – First-Touch and Last-Touch Attribution

Created:

`fct_first_last_touch_attribution`

Both attribution models reconciled to:

- 4,452 transactions.
- $307,868 purchase revenue.
- 4,452 total attribution credit.

### Step 5.5 – Linear Attribution

Created:

`fct_linear_attribution`

Validation confirmed:

- 11,496 rows.
- 4,452 distinct transactions.
- 9,144 distinct touchpoint sessions.
- 4,452 total attribution credit.
- $307,868 attributed revenue.

### Step 5.6 – Time-Decay Attribution

Created:

`fct_time_decay_attribution`

Implemented a seven-day half-life weighting assumption.

Weights were normalized per transaction.

Validation confirmed transaction-level attribution reconciliation.

### Step 5.7 – Attribution Comparison

Created:

`fct_attribution_comparison`

Consolidated all four attribution models.

Final validation confirmed:

- 4,452 transactions per model.
- $307,868 attributed revenue per model.
- 4,452 total attribution credit per model.
- No transaction-level credit exceptions.

### Step 5.8 – Advertising Performance and Consolidated Reporting

Created:

- `fct_ad_spend_performance`
- `fct_campaign_performance_summary`
- `fct_channel_performance_summary`
- `fct_marketing_performance_reporting`

Advertising dataset summary:

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Campaign-date records | 736 |
| Dates | 92 |
| Impressions | 9,246,272 |
| Clicks | 186,706 |
| Simulated conversions | 6,231 |
| Spend | $126,552.23 |

The consolidated reporting model contains 148 rows:

- 8 synthetic advertising performance rows.
- 140 GA4 attribution performance rows.

### Testing

- Marketing schema tests: 21 passed, 0 warnings, 0 errors.
- Dedicated singular tests: 5 passed, 0 warnings, 0 errors.
- Reporting-model data-quality validation returned zero exception rows.
- dbt documentation generation and lineage checks completed successfully.

The five singular tests were also included in the model-selected test run. They are five unique tests, not ten separate tests.

### Important limitation discovered

Synthetic advertising campaign IDs could not be reliably mapped to GA4 purchase revenue.

The source/medium comparison produced only one exact match, and it did not establish campaign-level identity.

Consequently:

- Synthetic cost per simulated conversion is available.
- Actual GA4-based campaign CPA remains unverified.
- Campaign ROAS and ROI cannot yet be calculated defensibly.
- Advertising spend and GA4 purchase revenue remain separate in the reporting model.

### Outcome

The four attribution models and advertising performance foundations were completed and validated.

---

## Next – Phase 6: Campaign ROI, CPA, and Marketing Efficiency

**Status: Planned**

### Objectives

- Investigate campaign-level mapping between synthetic advertising data and GA4 purchase conversions.
- Determine whether actual campaign CPA can be calculated.
- Determine whether campaign ROI and ROAS can be calculated.
- Validate spend and conversion relationships.
- Document any limitations where reliable mapping is unavailable.

---

## Phase 7 – Tableau Dashboards

**Status: Planned**

- Connect validated analytical models to Tableau.
- Build customer analytics dashboards.
- Build marketing attribution dashboards.
- Build campaign performance dashboards.
- Present actionable marketing recommendations.

---

## Phase 8 – Final Testing and Project Completion

**Status: Planned**

- Perform end-to-end validation.
- Verify dashboard metrics.
- Review technical documentation.
- Finalize the project README.
- Prepare final project demonstration and presentation.