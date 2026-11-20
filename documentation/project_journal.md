# Project Journal

## Project: Customer 360 & Marketing Attribution

This journal summarizes the major implementation milestones completed during the project.

## Phase 1 – Data Source Preparation

- Identified the GA4 public sample e-commerce dataset.
- Prepared synthetic CRM customer records.
- Prepared synthetic identity mapping records.
- Prepared synthetic advertising campaign data.
- Established the initial project data structure.

## Phase 2 – Customer 360 and Identity Resolution

- Created the BigQuery project environment.
- Organized raw and curated datasets.
- Loaded GA4 and synthetic customer inputs.
- Implemented identity resolution using the supplied mapping.
- Preserved unmatched records.
- Validated identified and unidentified customer activity.

Recorded results:

- 360,129 GA4 sessions.
- 10,246 identified customers.
- 349,883 unidentified sessions.

## Phase 3 – dbt Data Modelling

- Configured Python and dbt Core.
- Configured the BigQuery adapter.
- Created the `customer_360` dbt project.
- Developed staging models.
- Developed intermediate transformation logic.
- Developed fact sessions and fact orders models.
- Developed the customer profile dimension.
- Generated dbt documentation.

## Phase 4 – Customer Analytics

- Developed customer-level analytical models.
- Implemented RFM analysis.
- Developed customer segmentation.
- Worked on customer lifetime value analysis.
- Validated customer analytics outputs.

## Phase 5 – Marketing Attribution

- Developed First-Touch attribution.
- Developed Last-Touch attribution.
- Developed Linear attribution.
- Developed Time-Decay attribution.
- Created attribution comparison outputs.
- Performed attribution reconciliation.

Recorded validation:

- 4,452 attribution credits/records.
- $307,868 attributed revenue per attribution model.

## Phase 6 – Campaign Efficiency and CPA

- Prepared campaign-level advertising analysis.
- Developed `fct_campaign_efficiency`.
- Developed `fct_channel_roi`.
- Calculated advertising efficiency metrics.
- Investigated campaign mapping coverage.
- Performed channel ROI validation.
- Documented incomplete campaign mapping.

Recorded validation:

- 8 campaigns.
- 736 advertising records.
- 6,231 simulated conversions.
- $126,552.23 advertising spend.
- 10 validation checks passed.
- $0.00 spend reconciliation difference.

## Phase 7 – Tableau Visualization and Recommendations

- Developed the Customer 360 Executive Overview.
- Developed Marketing Attribution & Conversion Insights.
- Developed Campaign Performance.
- Developed Marketing Efficiency & Budget Recommendations.
- Incorporated analytical findings into business-facing dashboards.
- Documented campaign mapping limitations and recommendation boundaries.

## Final Submission

- Prepared the system architecture diagram.
- Prepared data documentation.
- Updated technical documentation.
- Prepared the working demonstration.
- Prepared the final internship presentation.
- Completed individual reflection.
- Organized final deliverables for GitHub and Google Drive.

## Project Status

**Completed – Final Submission Stage**

The project establishes an integrated customer analytics and marketing attribution solution using public sample data and synthetic business inputs.