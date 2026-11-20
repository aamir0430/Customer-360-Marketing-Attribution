# Architecture and Implementation Decisions

## 1. Overview

This document records important technical and analytical decisions made during the development of the Customer 360 & Marketing Attribution project.

## 2. Data Warehouse Selection

**Decision:** Google BigQuery.

**Reason:**

BigQuery provides scalable cloud data storage and SQL-based analytical processing.

It also provides direct access to Google's public GA4 sample dataset.

## 3. Data Source Selection

**Decision:** Use GA4 public sample data with synthetic CRM, identity mapping and advertising inputs.

**Reason:**

The combination provides a practical environment for demonstrating customer integration and marketing analytics without requiring access to private organizational production data.

**Implication:**

Synthetic data and simulated conversions must be clearly disclosed.

## 4. Identity Resolution Strategy

**Decision:** Use an identity mapping bridge and LEFT JOIN.

**Reason:**

The approach connects available website identifiers with CRM identifiers while retaining unmatched website activity.

**Implication:**

Unidentified records remain available for analysis but cannot be assigned to a known CRM customer.

## 5. dbt Transformation Architecture

**Decision:** Use staging, intermediate and marts layers.

**Reason:**

This improves modularity, reusability, testing and maintainability.

## 6. Customer Analytics

**Decision:** Use RFM segmentation and CLV analysis.

**Reason:**

These methods provide complementary views of customer purchasing behaviour and estimated customer value.

## 7. Attribution Methodology

**Decision:** Implement four attribution approaches.

- First-Touch.
- Last-Touch.
- Linear.
- Time-Decay.

**Reason:**

Comparing multiple models provides different perspectives on conversion-credit allocation.

## 8. Campaign Data Handling

**Decision:** Use synthetic advertising records.

**Reason:**

The project requires advertising expenditure and campaign performance inputs for demonstrating efficiency analysis.

**Implication:**

Simulated conversions must not be represented as verified live advertising conversions.

## 9. Campaign Mapping Limitation

**Decision:** Preserve incomplete mapping coverage as a documented limitation instead of assigning unsupported campaign attribution.

**Reason:**

Only Google/CPC was mapped in the final recorded implementation. Six source/medium combinations remained unmapped.

**Implication:**

Complete campaign-level ROAS, CPA and profit-based ROI cannot be claimed.

## 10. Visualization Selection

**Decision:** Use Tableau.

**Reason:**

Tableau supports interactive business-facing dashboards and comparisons of customer and marketing performance.

## 11. Reporting and Recommendation Strategy

**Decision:** Provide evidence-based marketing recommendations rather than unsupported budget reallocations.

**Reason:**

Incomplete campaign mapping and simulated conversion data limit the reliability of campaign-level conclusions.

## 12. Final Documentation Strategy

**Decision:** Maintain separate architecture, data dictionary, methodology, definitions, results, testing and setup documents.

**Reason:**

Separating technical architecture, business logic and validation evidence improves repository readability and maintainability.