# Project Results
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document summarizes the implementation outcomes and recorded validation results for the completed project phases.

The project combines Google's public GA4 ecommerce sample with synthetic CRM, identity mapping, and advertising datasets.

---

## 2. Phase 1 – Data Source Setup

**Status: Completed**

Data sources established:

- GA4 public ecommerce sample.
- Synthetic CRM customer dataset.
- Synthetic identity mapping dataset.
- Synthetic advertising spend dataset.

GA4 source period:

November 2020 – January 2021.

---

## 3. Phase 2 – Identity Resolution

**Status: Completed**

Output:

`customer_360_curated.identity_resolved_sessions`

### Validation results

| Measure | Result |
|---|---:|
| Total output sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

All source sessions were retained.

The identity mapping is synthetic, so these results demonstrate implementation consistency rather than real-world identity accuracy.

---

## 4. Phase 3 – dbt Data Modelling

**Status: Completed**

### Core models

| Model | Purpose | Status |
|---|---|---|
| `fct_sessions` | Session-level analytical output | Validated |
| `fct_orders` | Order-level analytical output | Validated |
| `dim_customer_profile` | Customer-profile output | Validated |

### dbt environment

| Item | Value |
|---|---|
| dbt project | `customer_360` |
| dbt Core | 1.12.7 |
| dbt-bigquery | 1.12.3 |
| Development dataset | `customer_360_dbt_dev` |

dbt diagnostics, parsing, and documentation generation completed successfully.

---

## 5. Phase 4 – Customer Analytics

**Status: Completed**

### Models

- `fct_customer_rfm`
- `fct_customer_rfm_scores`
- `dim_customer_segments`
- `fct_customer_clv`
- `dim_customer_360_analytics`

### Unified Customer 360 validation

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
| Missing customer IDs | 0 |
| Missing customer segments | 0 |
| Missing CLV records | 0 |

### RFM segment distribution

| Segment | Customers | Revenue |
|---|---:|---:|
| No Purchase | 2,909 | $0 |
| Hibernating | 414 | $32,939 |
| Customers Needing Attention | 395 | $34,824 |
| Lost | 387 | $28,981 |
| Recent Customers | 381 | $24,255 |
| Promising Customers | 372 | $24,943 |
| Potential Loyalists | 99 | $13,296 |
| Champions | 15 | $4,247 |
| Loyal Customers | 12 | $2,264 |
| At Risk | 9 | $1,720 |
| Cannot Lose Them | 7 | $2,180 |

### Historical value distribution

| Segment | Customers | Historical Revenue |
|---|---:|---:|
| High Value | 424 | $89,551 |
| Medium Value | 415 | $36,127 |
| Low Value | 889 | $38,371 |
| Very Low Value | 363 | $5,600 |
| No Purchase | 2,909 | $0 |

### Interpretation

The unified model retains all 5,000 CRM customers.

A total of 2,091 customers have identified purchases, while 2,909 have no identified purchase records in the resolved customer population.

A total of 1,948 orders worth $138,219 do not have a resolved CRM customer ID. These orders are excluded from customer-level RFM and CLV rather than being assigned without evidence.

Historical CLV is descriptive, not predictive.

---

## 6. Phase 5 – Marketing Attribution

**Status: Completed**

### Attribution models

- First-touch.
- Last-touch.
- Linear.
- Time-decay.

### Conversion journey results

| Measure | Result |
|---|---:|
| Purchase transactions | 4,452 |
| Conversion journey rows | 11,496 |
| Distinct touchpoint sessions | 9,144 |
| Purchase revenue | $307,868 |

### Attribution reconciliation

| Model | Transactions | Total Credit | Attributed Revenue |
|---|---:|---:|---:|
| First Touch | 4,452 | 4,452 | $307,868 |
| Last Touch | 4,452 | 4,452 | $307,868 |
| Linear | 4,452 | 4,452 | $307,868 |
| Time Decay | 4,452 | 4,452 | $307,868 |

All four models reconcile to the same transaction population and purchase revenue.

The time-decay model uses a seven-day half-life as a modelling assumption.

### Channel attribution observations

The leading source/medium combinations included:

- `google / organic`
- `shop.googlemerchandisestore.com / referral`
- `<other> / referral`
- `(direct) / (none)`

The ranking of channels differs somewhat across attribution models, demonstrating that the choice of attribution methodology affects how credit is allocated.

The results are descriptive of the GA4 sample dataset and should not be interpreted as actual advertising campaign profitability.

---

## 7. Phase 5 – Advertising Performance

**Status: Completed**

### Advertising dataset summary

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Campaign-date records | 736 |
| Reporting dates | 92 |
| Impressions | 9,246,272 |
| Clicks | 186,706 |
| Simulated conversions | 6,231 |
| Advertising spend | $126,552.23 |

### Models

- `fct_ad_spend_performance`
- `fct_campaign_performance_summary`
- `fct_channel_performance_summary`

### Calculated metrics

- CTR.
- CPC.
- Simulated conversion rate.
- Cost per simulated conversion.

These are advertising-source metrics based on synthetic data.

### Consolidated reporting model

`fct_marketing_performance_reporting`

| Source | Rows |
|---|---:|
| Synthetic advertising performance | 8 |
| GA4 attribution performance | 140 |
| Total | 148 |

The model keeps the two sources separate.

---

## 8. Phase 5 – Testing Results

| Test Category | Result |
|---|---|
| Marketing schema tests | 21 passed |
| Singular tests | 5 passed |
| Warnings | 0 |
| Errors | 0 |
| Reporting-model data-quality exceptions | 0 |
| dbt documentation generation | Successful |
| dbt lineage checks | Successful |

The five singular tests are unique tests and were also included in the model-selected test run.

---

## 9. Outstanding Campaign Measurement Limitation

The synthetic advertising campaigns could not be reliably mapped to GA4 purchase revenue at campaign-ID level.

Only one exact source/medium match was found. It did not establish a verified mapping between GA4 campaign values and the synthetic campaign identifiers.

Therefore:

- Synthetic cost per simulated conversion is available.
- Actual GA4-based campaign CPA is not yet established.
- Campaign ROAS is not yet established.
- Campaign ROI is not yet established.

These metrics require a defensible relationship between advertising spend and the corresponding purchase conversions and revenue.

This is the focus of Phase 6.

---

## 10. Remaining Project Work

| Phase | Work | Status |
|---|---|---|
| Phase 6 | Campaign ROI, CPA, and marketing efficiency analysis | Pending |
| Phase 7 | Tableau dashboards and marketing recommendations | Pending |
| Phase 8 | Final testing, validation, and project completion | Pending |

---

## 11. Final Interpretation

The completed work establishes a validated Customer 360 data foundation, customer segmentation and historical value analysis, four alternative marketing attribution models, and a separate synthetic advertising performance layer.

The remaining work is to investigate whether campaign expenditure can be defensibly connected to GA4 purchase conversions, followed by Tableau visualization and final project validation.

## Phase 6 – Campaign Efficiency, CPA and ROAS

### Implementation

Created two dbt models:

1. `fct_campaign_efficiency`
2. `fct_channel_roi`

The campaign efficiency model reports advertising expenditure, impressions, clicks, simulated conversions, CTR, CPC and cost per simulated conversion.

The channel ROI model combines advertising expenditure by source and medium with GA4 attributed revenue across four attribution models.

### Campaign Efficiency Results

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Impressions | 9,246,272 |
| Clicks | 186,706 |
| Simulated conversions | 6,231 |
| Advertising spend | $126,552.23 |
| Cost per simulated conversion | $20.31 |

### Google Paid Search Results

| Attribution Model | Attributed Revenue | Attributed CPA | ROAS | Revenue-based Return |
|---|---:|---:|---:|---:|
| First Touch | $5,087.00 | $1,052.29 | 0.0711x | -92.89% |
| Last Touch | $2,960.00 | $1,664.09 | 0.0414x | -95.86% |
| Linear | $3,718.36 | $1,402.95 | 0.0520x | -94.80% |
| Time Decay | $3,524.97 | $1,476.58 | 0.0493x | -95.07% |

The channel-level CPA uses weighted attribution credit, including fractional credit for Linear and Time Decay.

### Key Findings

- Eight advertising campaigns were included in the efficiency model.
- Two Google CPC campaigns were aggregated into one Paid Search expenditure group.
- GA4 attributed revenue was available for the Google CPC source/medium combination.
- Six other advertising source/medium combinations had no verified GA4 mapping.
- Total advertising expenditure reconciled to $126,552.23.
- Overall cost per simulated conversion was $20.31.

### Measurement Limitations

Campaign-level revenue could not be reliably assigned to individual campaign IDs.

The calculated revenue-based return is an attributed-revenue efficiency proxy, not verified incremental profit ROI.

Actual individual campaign CPA and ROAS remain unavailable for campaigns without a verified mapping.

Synthetic advertising conversions are not treated as GA4 purchases.