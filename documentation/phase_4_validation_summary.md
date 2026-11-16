# Phase 4 – Unified Customer 360 Analytics Validation Summary

**Model:** `dim_customer_360_analytics`  
**BigQuery relation:** `customer-360-mta.customer_360_dbt_dev.dim_customer_360_analytics`  
**Status:** Six supplied validation outputs reviewed; all reported checks passed.

## Population

- Rows: 5,000
- Distinct customers: 5,000
- RFM purchasers: 2,091
- RFM non-purchasers: 2,909
- CLV purchasers: 2,091
- CLV non-purchasers: 2,909

## RFM/CLV reconciliation

- RFM orders: 2,504
- CLV orders: 2,504
- RFM revenue: $169,649
- Historical CLV: $169,649
- Frequency mismatch count: 0
- Revenue mismatch count: 0

## Completeness and eligibility

| Check | Invalid / missing records |
|---|---:|
| Null customer IDs | 0 |
| Missing customer segments | 0 |
| Missing historical value segments | 0 |
| Missing RFM eligibility | 0 |
| Missing CLV eligibility | 0 |
| RFM/CLV eligibility mismatches | 0 |
| Missing CLV records | 0 |

## RFM segment distribution

| Segment | Customers | Customer share | Historical revenue |
|---|---:|---:|---:|
| No Purchase | 2,909 | 58.18% | $0 |
| Hibernating | 414 | 8.28% | $32,939 |
| Customers Needing Attention | 395 | 7.90% | $34,824 |
| Lost | 387 | 7.74% | $28,981 |
| Recent Customers | 381 | 7.62% | $24,255 |
| Promising Customers | 372 | 7.44% | $24,943 |
| Potential Loyalists | 99 | 1.98% | $13,296 |
| Champions | 15 | 0.30% | $4,247 |
| Loyal Customers | 12 | 0.24% | $2,264 |
| At Risk | 9 | 0.18% | $1,720 |
| Cannot Lose Them | 7 | 0.14% | $2,180 |
| **Total** | **5,000** | **100.00%** | **$169,649** |

## Historical value distribution

| Segment | Customers | Historical CLV | Revenue share |
|---|---:|---:|---:|
| High Value | 424 | $89,551 | 52.79% |
| Low Value | 889 | $38,371 | 22.62% |
| Medium Value | 415 | $36,127 | 21.30% |
| Very Low Value | 363 | $5,600 | 3.30% |
| No Purchase | 2,909 | $0 | 0.00% |
| **Total** | **5,000** | **$169,649** | **100.00%** |

## Discrepancy review

No discrepancies were found in the six supplied final-model CSV outputs. Customer population, identified order count, identified revenue, RFM/CLV eligibility and required-field completeness all reconcile.

The 50-row customer inspection is a sample for row-level plausibility, not an exhaustive test. The displayed customers show matching frequency/order counts and monetary value/historical CLV.

## Caveats

- Historical CLV is descriptive observed revenue, not predictive CLV.
- `observed_purchase_span_days` measures the interval between first and last observed purchase dates. Zero means purchases occurred on the same date.
- The 1,948 unidentified orders ($138,219) are not attributed to CRM customers.
- RFM segments are rule-based categories over the available historical window, not verified churn labels.