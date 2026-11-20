# Project Results and Business Insights

## 1. Overview

This document summarizes the recorded implementation results of the Customer 360 & Marketing Attribution project.

## 2. Customer 360 Results

| Metric | Result |
|---|---:|
| GA4 Sessions | 360,129 |
| Identified Customers | 10,246 |
| Unidentified Sessions | 349,883 |
| Synthetic CRM Records | 5,000 |
| Identity Mapping Records | 3,500 |

The identity-resolution implementation connected website activity to CRM identifiers wherever valid mapping records were available.

Unmatched records were retained.

## 3. dbt Modelling Results

The dbt project established:

- Five staging models.
- Intermediate transformation logic.
- Fact sessions model.
- Fact orders model.
- Customer profile dimension.
- Additional customer and marketing analytical models.

## 4. Customer Analytics Results

The project implemented:

- Customer profile modelling.
- RFM analysis.
- Customer segmentation.
- Customer lifetime value analysis.

These outputs provide analytical perspectives on customer behaviour and customer value.

## 5. Marketing Attribution Results

Four attribution approaches were implemented.

| Model | Method |
|---|---|
| First-Touch | First eligible touchpoint |
| Last-Touch | Last eligible touchpoint |
| Linear | Equal credit distribution |
| Time-Decay | Greater weight to recent touchpoints |

Recorded reconciliation results:

- 4,452 attribution credits/records.
- $307,868 attributed revenue per model.

These values represent alternative attribution views and must not be added together.

## 6. Campaign Performance Results

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Advertising Records | 736 |
| Impressions | 9,246,272 |
| Clicks | 186,706 |
| Simulated Conversions | 6,231 |
| Advertising Spend | $126,552.23 |
| Simulated CPA | $20.31 |

## 7. Channel ROI Validation

The channel ROI implementation was validated using 10 validation records.

| Validation Metric | Result |
|---|---:|
| Validation Checks | 10 |
| Passed | 10 |
| Failed | 0 |
| Spend Reconciliation Difference | $0.00 |

Only Google/CPC was mapped in the final recorded implementation.

Recorded Google/CPC analytical results:

| Attribution Model | Attributed Revenue | ROAS | CPA |
|---|---:|---:|---:|
| First-Touch | $5,087.00 | 0.0711x | $1,052.29 |
| Last-Touch | $2,960.00 | 0.0414x | $1,664.09 |
| Linear | $3,718.36 | 0.0520x | $1,402.95 |
| Time-Decay | $3,524.97 | 0.0493x | $1,476.58 |

These are model-specific recorded results for the mapped channel scope, not complete campaign-level performance results.

## 8. dbt Testing Results

| Test Category | Result |
|---|---:|
| Schema Tests | 21 passed |
| Singular Tests | 5 passed |
| Final Data Quality Query | 0 exception rows |

## 9. Tableau Deliverables

Four dashboards were completed:

1. Customer 360 Executive Overview.
2. Marketing Attribution & Conversion Insights.
3. Campaign Performance.
4. Marketing Efficiency & Budget Recommendations.

## 10. Business Interpretation

The project demonstrates how customer identity resolution, customer analytics and marketing attribution can support business intelligence.

The dashboards provide a foundation for:

- Understanding customer groups.
- Comparing attribution methodologies.
- Monitoring campaign activity.
- Evaluating available marketing efficiency metrics.
- Identifying incomplete measurement coverage.

## 11. Limitations

- CRM, identity mapping and advertising data are synthetic.
- Advertising conversions are simulated.
- Six source/medium combinations remained unmapped.
- Google Brand and Generic campaign performance could not be reliably separated.
- Complete campaign-level ROAS and CPA are not verified.
- Profit-based and incremental ROI are not established.

## 12. Final Outcome

The project successfully established an integrated analytics workflow connecting data integration, identity resolution, dbt modelling, customer analytics, marketing attribution and Tableau reporting.

The results demonstrate the analytical capabilities of the solution within the limitations of the available datasets.