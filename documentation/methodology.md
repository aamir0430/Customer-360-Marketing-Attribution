# Project Methodology

## 1. Overview

The project follows a structured data analytics methodology covering source integration, identity resolution, transformation, customer analytics, attribution, campaign efficiency and visualization.

## 2. Data Collection

The project uses:

- GA4 public sample e-commerce data.
- Synthetic CRM records.
- Synthetic identity mapping records.
- Synthetic advertising records.

## 3. Data Integration

Google BigQuery serves as the central data warehouse.

Source datasets are organized into raw, curated and dbt development datasets.

## 4. Identity Resolution

Website-side identifiers are connected to CRM-side identifiers through the supplied identity mapping.

A LEFT JOIN approach retains unmatched session records.

Identity outcomes are classified as IDENTIFIED or UNIDENTIFIED.

## 5. Data Transformation

dbt Core is used to organize SQL transformations into three layers.

### Staging

Source preparation and standardization.

### Intermediate

Reusable business logic and transformations.

### Marts

Business-ready analytical models, including fact sessions, fact orders and customer profiles.

## 6. Customer Analytics

### RFM Analysis

Customers are evaluated using:

- Recency.
- Frequency.
- Monetary Value.

The resulting scores support customer segmentation.

### CLV Analysis

Customer lifetime value is estimated using the assumptions and calculation logic implemented in the project.

These estimates should not be interpreted as verified future revenue.

## 7. Marketing Attribution

Four attribution approaches are implemented.

### First-Touch

Credit is assigned to the first eligible touchpoint.

### Last-Touch

Credit is assigned to the final eligible touchpoint before conversion.

### Linear

Credit is distributed equally among eligible touchpoints.

### Time-Decay

Credit is distributed with relatively greater weight assigned to touchpoints closer to conversion.

The models provide alternative allocation views of the same conversion/revenue scope.

## 8. Campaign Efficiency

Campaign performance is analyzed using advertising expenditure, impressions, clicks and simulated conversions.

Important metrics include:

- CTR.
- CPC.
- CPA.
- Attributed revenue.
- ROAS.

Campaign-level interpretation is restricted by mapping coverage.

Only Google/CPC was mapped in the final recorded implementation.

## 9. Tableau Visualization

Four dashboards present the analytical outputs:

1. Customer 360 Executive Overview.
2. Marketing Attribution & Conversion Insights.
3. Campaign Performance.
4. Marketing Efficiency & Budget Recommendations.

## 10. Validation Methodology

Validation includes:

- dbt schema tests.
- dbt singular tests.
- SQL data-quality checks.
- Identity-resolution checks.
- Attribution reconciliation.
- Advertising spend reconciliation.

## 11. Business Interpretation

Recommendations are based on available analytical evidence.

Unmapped campaign data is treated as a measurement limitation rather than zero performance.

Simulated conversions are not presented as verified live advertising results.

Revenue-based ROAS is not interpreted as profit ROI or incremental ROI.