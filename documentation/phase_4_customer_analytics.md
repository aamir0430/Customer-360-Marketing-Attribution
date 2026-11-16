# Phase 4 – Customer Analytics: RFM, Segmentation and Historical CLV

**Status: Completed**  
**Warehouse:** BigQuery project `customer-360-mta`, dataset `customer_360_dbt_dev`  
**dbt project:** `customer_360`

## Objective

Build customer-level analytical models that combine recency, frequency, monetary value (RFM), customer segmentation and historical customer lifetime value (CLV), while retaining the full CRM customer population.

## Models delivered

| Model | Purpose |
|---|---|
| `fct_customer_rfm` | Customer-level recency, frequency, monetary value and purchase eligibility |
| `fct_customer_rfm_scores` | R, F and M scores and combined RFM score |
| `dim_customer_segments` | RFM customer segments, descriptions and recommended marketing actions |
| `fct_customer_clv` | Historical identified revenue, order count, average order value, observed purchase span and historical value segment |
| `dim_customer_360_analytics` | Unified customer-level RFM, segmentation and historical CLV output |

The final model uses `dim_customer_segments` as its RFM/segmentation input and LEFT JOINs `fct_customer_clv` by `customer_id`. This avoids redundant joins to upstream RFM models because their required fields are already represented in `dim_customer_segments`.

## Key modelling decisions and definitions

- The customer population retains customers without identified purchases.
- RFM and CLV use identified customer transactions only. Orders without a resolved `customer_id` are not assigned to a CRM customer.
- Historical CLV is observed identified revenue in the available dataset; it is not a predictive future-lifetime-value estimate.
- The CLV model's `customer_lifespan_days` is exposed in the unified model as `observed_purchase_span_days`. It is the date difference between first and last observed purchase, not the full customer relationship duration.
- A zero-day purchase span means first and last observed purchases occurred on the same calendar date.
- Percentile-based historical value groups can have unequal sizes where tied values occur.
- RFM segment labels describe rule-based behaviour in the observed dataset. They are not independently verified churn outcomes.

## Source reconciliation finding

The order model contains 4,452 orders and $307,868 in total revenue. Of these, 2,504 orders and $169,649 are associated with CRM customers. The remaining 1,948 orders and $138,219 have no resolved CRM customer identifier and are excluded from customer-level RFM and CLV. They remain in the order-level source model and are not force-assigned.

## Final unified model validation

| Validation | Result | Status |
|---|---:|---|
| Final rows | 5,000 | Passed |
| Distinct customer IDs | 5,000 | Passed |
| RFM purchasers | 2,091 | Passed |
| RFM non-purchasers | 2,909 | Passed |
| CLV purchasers | 2,091 | Passed |
| CLV non-purchasers | 2,909 | Passed |
| RFM identified orders | 2,504 | Passed |
| CLV identified orders | 2,504 | Passed |
| RFM identified revenue | $169,649 | Passed |
| Historical CLV total | $169,649 | Passed |
| Frequency mismatches | 0 | Passed |
| Revenue mismatches | 0 | Passed |
| Null customer IDs | 0 | Passed |
| Missing RFM segments | 0 | Passed |
| Missing historical value segments | 0 | Passed |
| Missing eligibility statuses | 0 | Passed |
| RFM/CLV eligibility mismatches | 0 | Passed |
| Missing CLV records | 0 | Passed |

### RFM segment distribution

| RFM segment | Customers | Customer share | Historical revenue |
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

### Historical value distribution

| Historical value segment | Customers | Historical CLV | Revenue contribution |
|---|---:|---:|---:|
| High Value | 424 | $89,551 | 52.79% |
| Low Value | 889 | $38,371 | 22.62% |
| Medium Value | 415 | $36,127 | 21.30% |
| Very Low Value | 363 | $5,600 | 3.30% |
| No Purchase | 2,909 | $0 | 0.00% |
| **Total** | **5,000** | **$169,649** | **100.00%** |

## Interpretation and limitations

- High Value customers are 424 of the 2,091 purchasers and contribute 52.79% of identified customer revenue.
- The 2,909 customers without identified purchases are not necessarily confirmed never-buyers; no eligible identified purchase is present for them in this model.
- The observed purchase window is limited. Recency, segments and purchase spans must be interpreted within that window.
- Synthetic identity mappings are used. These results demonstrate pipeline logic against generated mappings and do not establish real-world identity-resolution accuracy.

## Validation evidence

Store the six final unified-model CSV outputs under:

`documentation/validation/phase_4_rfm_clv/dim_customer_360_analytics/`

- `01_customer_population_validation.csv`
- `02_rfm_clv_reconciliation.csv`
- `03_rfm_segment_distribution.csv`
- `04_historical_value_distribution.csv`
- `05_missing_data_validation.csv`
- `06_customer_360_inspection.csv`

Store the dbt build log at:

`documentation/validation/phase_4_rfm_clv/dbt_customer_360_analytics_build.txt`

The project owner reported a successful dbt build. The six CSV outputs were reviewed for this completion record.

## Phase 4 completion

The unified Customer 360 Analytics model has been built and its six validation outputs reviewed. Population, order, revenue, eligibility and completeness checks reconcile. Phase 4 is complete; proceed to marketing attribution modelling.