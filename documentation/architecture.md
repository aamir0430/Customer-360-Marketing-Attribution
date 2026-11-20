# System Architecture

## 1. Overview

The Customer 360 & Marketing Attribution project follows a layered data analytics architecture designed to integrate customer information, resolve customer identities, transform analytical data and present business insights.

The architecture connects Google Analytics 4 sample data, synthetic CRM records, identity mapping and advertising data through Google BigQuery, dbt Core and Tableau.

## 2. Architecture Components

### 2.1 Data Sources

The solution uses:

- Google Analytics 4 public obfuscated sample e-commerce data.
- Synthetic CRM customer records.
- Synthetic identity mapping records.
- Synthetic advertising and campaign performance records.

### 2.2 Data Warehouse – Google BigQuery

Project ID:

`customer-360-mta`

Location:

`US`

Datasets:

| Dataset | Responsibility |
|---|---|
| customer_360_raw | Source-oriented data storage |
| customer_360_curated | Integrated and curated data |
| customer_360_dbt_dev | dbt transformation outputs |

Important raw tables:

- ga4_events
- ga4_sessions
- crm_customers
- identity_mapping

Curated output:

- identity_resolved_sessions

### 2.3 Identity Resolution

Identity resolution connects website-side identifiers with CRM-side customer identifiers using the supplied synthetic mapping data.

The implementation uses a LEFT JOIN approach to retain unmatched website records.

Identity statuses:

- IDENTIFIED
- UNIDENTIFIED

This prevents unmatched website activity from being silently discarded.

### 2.4 dbt Transformation Layer

Project:

`customer_360`

The transformation architecture consists of:

**Staging**

Standardizes and prepares source data.

Implemented staging models include:

- stg_ga4_sessions
- stg_ga4_events
- stg_crm_customers
- stg_identity_mapping
- stg_identity_resolved_sessions

**Intermediate**

Contains reusable analytical transformation logic.

**Marts**

Produces business-ready analytical models.

Core models:

- fct_sessions
- fct_orders
- dim_customer_profile

Additional analytical models support RFM, CLV, attribution and campaign efficiency.

### 2.5 Analytical Layer

The analytical layer includes:

- Customer 360 profile modelling.
- RFM customer segmentation.
- Customer lifetime value analysis.
- First-Touch attribution.
- Last-Touch attribution.
- Linear attribution.
- Time-Decay attribution.
- Campaign efficiency.
- Channel ROI analysis.

### 2.6 Visualization Layer – Tableau

Four dashboards were developed:

1. Customer 360 Executive Overview.
2. Marketing Attribution & Conversion Insights.
3. Campaign Performance.
4. Marketing Efficiency & Budget Recommendations.

## 3. End-to-End Data Flow

```text
GA4 Public Sample Data
Synthetic CRM Data
Identity Mapping Data
Synthetic Advertising Data
             |
             v
       Google BigQuery
             |
             v
        Raw Dataset
             |
             v
    Identity Resolution
             |
             v
      Curated Dataset
             |
             v
         dbt Core
             |
     -----------------
     |       |       |
  Staging Intermediate Marts
                     |
                     v
             Analytical Models
                     |
          ---------------------
          |                   |
     Customer Analytics   Marketing Analytics
          |                   |
          ---------------------
                     |
                     v
                  Tableau
                     |
                     v
             Business Insights
```

## 4. Data Quality and Validation

The architecture incorporates:

- dbt schema tests.
- dbt singular tests.
- SQL validation queries.
- Identity-resolution validation.
- Attribution reconciliation.
- Advertising spend reconciliation.

Recorded results include 21 schema tests, 5 singular tests and 10 channel ROI validation checks passing.

## 5. Architecture Limitations

- GA4 data is a public sample.
- CRM, identity mapping and advertising inputs are synthetic.
- Advertising conversions are simulated.
- Campaign/source-medium mapping remains incomplete.
- No custom REST API service is part of the implemented architecture.

## 6. Conclusion

The architecture provides an integrated analytical workflow connecting source data, identity resolution, transformation, customer analytics, marketing attribution and Tableau reporting.