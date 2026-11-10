# Project Methodology
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document describes the analytical methods used and planned for the Customer 360 & Marketing Attribution platform. The project combines data integration, identity resolution, customer analytics and marketing attribution.

## 2. Data Integration

The project uses:
- GA4 ecommerce behavioural and session data.
- Synthetic CRM customer records.
- Synthetic advertising spend data.
- Synthetic identity mapping records.

The data is integrated in Google BigQuery. Source data is held in the raw layer, while the completed Phase 2 identity-resolution output is stored in a curated dataset.

## 3. Customer Identity Resolution

### Objective

Connect GA4 website sessions with CRM customer records wherever a corresponding identity mapping exists, while preserving sessions that cannot be identified.

### Implemented workflow – Phase 2

1. Prepared and loaded the required GA4 session, CRM customer and identity mapping tables into BigQuery.
2. Inspected the identity mapping records and checked mapping quality.
3. Previewed the joins between GA4 sessions, identity mapping and CRM customer records.
4. Validated the proposed identity-resolution output, including session coverage and CRM linkage.
5. Created the final curated table: `customer_360_curated.identity_resolved_sessions`.
6. Executed final validation checks on the created table.

### Join and matching approach

The final session-level output uses LEFT JOIN logic from the GA4 session population to the synthetic identity mapping and then to CRM customer records. This preserves all source GA4 sessions even when no matching identity is available.

The output includes GA4 session fields, available mapping attributes, CRM profile attributes when a match exists, and an `identity_resolution_status` field.

### Identity status

- `IDENTIFIED`: a session was connected to a CRM customer through the synthetic mapping.
- `UNIDENTIFIED`: no matching mapping was available for that session.

### Phase 2 validation results

| Measure | Result |
|---|---:|
| Total sessions in output | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Missing CRM customer records in identified output | 0 |
| Mismatched synthetic IDs in validation | 0 |

The identified and unidentified session counts reconcile to the full session population.

### Interpretation and limitation

The mapping data is synthetic. These results demonstrate that the SQL workflow correctly applied the generated mapping and passed the recorded consistency checks. They must not be interpreted as real-world identity resolution accuracy or as proof of actual customer identities.

## 4. Customer 360 Development

### Objective

Develop a consolidated customer profile containing information from multiple platforms.

### Planned Components

- Customer identifiers.
- CRM customer attributes.
- Website behavioural information.
- Ecommerce purchase information.
- Marketing interaction information.

The identity-resolved session table provides an input for the subsequent customer profile models.

## 5. RFM Customer Segmentation

RFM analysis will classify customers according to:
- **Recency:** How recently a customer made a purchase.
- **Frequency:** How frequently a customer purchased.
- **Monetary:** How much a customer spent.

Final scoring rules, thresholds and segments will be established after examining the transaction data.

## 6. Customer Lifetime Value

Historical Customer Lifetime Value analysis will estimate customer revenue over the observed purchasing history. The final definition and calculation will be documented after the transaction fields and business rules are established.

## 7. Marketing Attribution

The project plans to compare:
- **First-touch attribution:** credits the first eligible touchpoint.
- **Last-touch attribution:** credits the final eligible touchpoint before conversion.
- **Linear attribution:** distributes credit equally across eligible touchpoints.
- **Time-decay attribution:** gives greater credit to touchpoints closer to conversion.

Implementation requires reliable customer journey, timestamp, channel and conversion information.

## 8. Marketing Performance Measurement

Planned metrics include total advertising spend, attributed revenue, ROAS, CAC, CPA, conversion rate and channel-level revenue contribution. Metric definitions will be documented before reporting.

## 9. Visualization

Tableau is planned for dashboards covering Customer 360, customer segmentation, CLV, channel performance, attribution comparison and campaign ROI.

## 10. Methodology Validation

Validation will include identity matching consistency, data completeness, duplicate detection, referential integrity, RFM and CLV calculation checks, attribution reconciliation and marketing KPI validation.

## 11. Implementation Status

**Completed:** Phase 1 data source setup and synthetic dataset generation; Phase 2 identity resolution through creation and validation of `customer_360_curated.identity_resolved_sessions`.

**Next:** Build dbt models for sessions, orders and customer profiles. RFM, CLV, marketing attribution and dashboards remain future implementation work.