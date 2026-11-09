# Testing and Validation
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document describes the testing and validation strategy for the Customer 360 & Marketing Attribution platform.

Testing will be performed throughout development to ensure data accuracy, consistency, reliability and correctness of analytical outputs.

## 2. Testing Objectives

- Verify the correctness of generated datasets.
- Validate data ingestion into BigQuery.
- Identify missing and duplicate records.
- Validate customer identity matching.
- Verify SQL transformations.
- Validate analytical calculations.
- Ensure marketing attribution results are consistent.
- Verify Tableau dashboard metrics.

## 3. Dataset Validation

The following datasets will undergo validation:

| Dataset | Planned Validation |
|---|---|
| GA4 Ecommerce Data | Schema, event completeness and identifier availability |
| Synthetic CRM Customers | Required fields, duplicate records and data types |
| Synthetic Advertising Spend | Campaign attributes, spending values and date consistency |
| Identity Mapping | Identifier completeness, mapping consistency and duplicate mappings |

## 4. Python Testing

Python scripts will be tested to verify:

- Successful dataset generation.
- Expected output files.
- Correct data structures.
- Valid data types.
- Duplicate handling.
- Identity matching behaviour.

Pytest will be used for automated Python testing.

## 5. SQL Testing

SQL transformations will undergo:

- Schema validation.
- Null value checks.
- Duplicate detection.
- Referential integrity checks.
- Join validation.
- Aggregation verification.
- Calculation accuracy checks.

## 6. dbt Testing

The dbt testing framework will be used for:

- Unique constraints.
- Not-null constraints.
- Accepted values.
- Referential integrity.
- Source freshness, where applicable.
- Custom business rule validation.

## 7. Identity Resolution Testing

Identity resolution will be validated using:

- Matching identifier checks.
- Valid mapping checks.
- Unmatched identifier detection.
- Duplicate identity detection.
- Customer-level consistency checks.

Matching accuracy will be assessed against the synthetic mapping data used as the reference.

## 8. Analytical Testing

The following analytical components will undergo validation:

### RFM Analysis

Verify recency, frequency and monetary calculations.

### Customer Lifetime Value

Verify customer-level revenue calculations and aggregation logic.

### Marketing Attribution

Verify conversion credit allocation and attribution reconciliation.

### Marketing Performance

Verify advertising spend, attributed revenue, ROAS and acquisition cost calculations.

## 9. Dashboard Testing

Tableau dashboards will be validated for:

- KPI accuracy.
- Filter functionality.
- Data consistency.
- Interactive behaviour.
- Visual presentation.
- Correct aggregation.

## 10. Test Execution Status

| Component | Status |
|---|---|
| Synthetic CRM dataset generation | Completed; detailed validation pending |
| Synthetic advertising dataset generation | Completed; detailed validation pending |
| Identity mapping dataset generation | Completed; detailed validation pending |
| BigQuery ingestion | Pending |
| Identity resolution | Pending |
| SQL transformation testing | Pending |
| dbt testing | Pending |
| RFM and CLV validation | Pending |
| Attribution validation | Pending |
| Tableau dashboard testing | Pending |

## 11. Test Results

Actual test cases, execution evidence, failures and resolutions will be recorded as testing progresses.

No analytical validation results are claimed at this stage.