# System Architecture
## Customer 360 & Marketing Attribution Programme

## 1. Overview

The project implements an analytical data platform integrating website behavioural information, synthetic CRM customer records, synthetic identity mappings, and synthetic advertising data.

Google BigQuery serves as the central data warehouse. SQL is used for data preparation, identity resolution, analytical transformations, and validation. dbt Core manages reusable data models, dependencies, testing, and documentation. Tableau is planned as the business intelligence and visualization layer.

## 2. High-Level Architecture

The project follows this logical architecture:

```text
                    DATA SOURCES
                         |
       +-----------------+------------------+
       |                 |                  |
      GA4             Synthetic CRM    Synthetic Ad Spend
       |                 |                  |
       +-----------------+------------------+
                         |
                    BIGQUERY
                         |
             +-----------+-----------+
             |                       |
          RAW DATA              CURATED DATA
             |                       |
             |               Identity Resolution
             |                       |
             +-----------+-----------+
                         |
                    dbt Core
                         |
        +----------------+----------------+
        |                |                |
     Staging         Intermediate       Marts
        |                |                |
        +----------------+----------------+
                         |
               CUSTOMER ANALYTICS
                         |
          RFM / CLV / CUSTOMER 360
                         |
               MARKETING ANALYTICS
                         |
        Conversion Journeys / Attribution
                         |
          Advertising Performance Models
                         |
             Consolidated Reporting
                         |
                 Tableau (Planned)
```

The advertising performance and GA4 attribution datasets remain separate where campaign-level mapping cannot be verified.

## 3. Data Sources

| Source | Location | Description |
|---|---|---|
| GA4 ecommerce events | `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` | Public ecommerce event data |
| Prepared GA4 sessions | `customer_360_raw.ga4_sessions` | Session-level GA4 data |
| CRM customers | `customer_360_raw.crm_customers` | Synthetic customer records |
| Identity mapping | `customer_360_raw.identity_mapping` | Synthetic website-to-CRM identity bridge |
| Advertising spend | `customer_360_raw.ad_spend_unpartitioned` | Synthetic campaign-date advertising data |
| Identity-resolved sessions | `customer_360_curated.identity_resolved_sessions` | Session data enriched with CRM identity information where available |

## 4. Technology Architecture

| Layer | Technology | Responsibility |
|---|---|---|
| Source data | GA4 and CSV datasets | Behavioural, CRM, identity, and advertising inputs |
| Data generation | Python and Pandas | Synthetic dataset generation |
| Data warehouse | Google BigQuery | Centralized data storage |
| Data preparation | SQL | Data cleaning, profiling, and ingestion validation |
| Identity resolution | BigQuery SQL | Link session identifiers to CRM identifiers |
| Transformation | dbt Core and SQL | Staging, intermediate, and analytical models |
| Testing | dbt tests and SQL | Data quality and business-rule validation |
| Documentation | dbt Docs and Markdown | Model lineage and technical documentation |
| Visualization | Tableau | Planned dashboard and reporting layer |
| Version control | Git and GitHub | Source control and project documentation |

## 5. BigQuery Organization

**Google Cloud project:** `customer-360-mta`

**Location:** `US`

| Dataset | Purpose |
|---|---|
| `customer_360_raw` | Raw and prepared source tables |
| `customer_360_curated` | Curated identity-resolution outputs |
| `customer_360_dbt_dev` | dbt development model outputs |

### Raw layer

Important source tables include:

- `ga4_sessions`
- `crm_customers`
- `identity_mapping`
- `ad_spend_unpartitioned`

The GA4 public event source is also used for event-level and purchase-related transformations.

### Curated layer

Main output:

`customer_360_curated.identity_resolved_sessions`

This table enriches GA4 sessions with CRM information where a synthetic identity mapping is available. Unmatched sessions are retained.

## 6. Identity Resolution Architecture

The identity-resolution process uses a synthetic mapping bridge between website-side identifiers and CRM customer identifiers.

Logical flow:

```text
GA4 Sessions
     |
     | user_pseudo_id
     |
Identity Mapping
     |
     | customer_id
     |
CRM Customers
     |
     v
Identity-Resolved Sessions
```

LEFT JOIN logic preserves the complete session population.

The resulting records distinguish:

- `IDENTIFIED`
- `UNIDENTIFIED`

The synthetic mapping validates the implementation logic against generated records; it does not establish real-world identity accuracy.

## 7. dbt Transformation Architecture

**dbt project:** `customer_360`

**Development dataset:** `customer_360_dbt_dev`

### Staging layer

The staging layer standardizes upstream sources.

- `stg_ga4_sessions`
- `stg_ga4_events`
- `stg_crm_customers`
- `stg_identity_mapping`
- `stg_identity_resolved_sessions`

### Core analytical marts

- `fct_sessions`
- `fct_orders`
- `dim_customer_profile`

### Customer analytics models

- `fct_customer_rfm`
- `fct_customer_rfm_scores`
- `dim_customer_segments`
- `fct_customer_clv`
- `dim_customer_360_analytics`

### Marketing attribution models

- `fct_conversion_journeys`
- `fct_first_last_touch_attribution`
- `fct_linear_attribution`
- `fct_time_decay_attribution`
- `fct_attribution_comparison`

### Advertising performance models

- `fct_ad_spend_performance`
- `fct_campaign_performance_summary`
- `fct_channel_performance_summary`
- `fct_marketing_performance_reporting`

The consolidated reporting model retains separate records for GA4 attribution and synthetic advertising performance. It does not imply a verified campaign-level revenue relationship.

## 8. Analytical Architecture

### Customer Analytics

The customer analytics layer provides:

- Recency.
- Frequency.
- Monetary value.
- RFM scores.
- Customer segments.
- Historical CLV.
- Historical value segments.
- Unified Customer 360 attributes.

### Marketing Attribution

The attribution layer evaluates four alternative models:

1. First-touch.
2. Last-touch.
3. Linear.
4. Time-decay.

The attribution models allocate GA4 purchase revenue across observed eligible touchpoints.

### Advertising Performance

The advertising layer summarizes synthetic campaign expenditure, impressions, clicks, and simulated conversions.

Actual campaign ROI and CPA using GA4 purchases require verified campaign mapping and remain the focus of Phase 6.

## 9. Visualization Architecture

Tableau is planned as the reporting layer.

Potential dashboard areas:

- Customer 360 overview.
- RFM segmentation.
- Customer value analysis.
- Marketing attribution comparison.
- Campaign performance.
- Advertising efficiency.
- Marketing budget recommendations.

Dashboard development is not yet completed.

## 10. Architecture Status

| Component | Status |
|---|---|
| Source data preparation | Completed |
| BigQuery raw and curated layers | Completed |
| Identity resolution | Completed |
| dbt staging and core marts | Completed |
| RFM and CLV analytics | Completed |
| Customer 360 unified model | Completed |
| Attribution models | Completed |
| Advertising performance foundations | Completed |
| Verified campaign ROI and GA4-based CPA | Pending Phase 6 |
| Tableau dashboards | Planned Phase 7 |
| Final project validation | Planned Phase 8 |

## 11. Architecture Limitations

- CRM and identity mapping datasets are synthetic.
- Advertising spend and simulated conversions are synthetic.
- GA4 is a public sample ecommerce dataset.
- Synthetic campaign identifiers have not been reliably mapped to GA4 purchase revenue.
- Tableau dashboards have not yet been implemented.