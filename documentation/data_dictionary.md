# Data Dictionary
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This document describes the datasets used in the Customer 360 & Marketing Attribution Programme.

It identifies the data sources, their purposes, and their roles in the analytical architecture.

Detailed column-level definitions, data types, and business rules will be added after source schema inspection and validation.

## 2. Data Source Inventory

| Dataset | File / Source | Data Type | Purpose |
|---|---|---|---|
| GA4 Ecommerce Events | `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*` | Public sample data | Website behavioural and ecommerce analysis |
| CRM Customers | `synthetic_crm_customers.csv` | Synthetic | Customer information and CRM identifiers |
| Advertising Spend | `synthetic_ad_spend.csv` | Synthetic | Advertising campaign and spending information |
| Identity Mapping | `identity_mapping.csv` | Synthetic | Cross-platform customer identifier mapping |

## 3. GA4 Ecommerce Dataset

**Source:** Google Analytics 4 public ecommerce sample dataset.

**BigQuery Table Pattern:**

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

### Purpose

Provides website interaction, traffic acquisition and ecommerce event information.

### Expected Analytical Usage

- Website session analysis.
- Customer journey analysis.
- Traffic source analysis.
- Ecommerce purchase analysis.
- Marketing channel attribution.
- Customer behavioural analysis.

### Important Considerations

GA4 uses event-level data. A single customer journey may involve multiple events and sessions.

Anonymous and authenticated identifiers may need to be connected through identity resolution.

The detailed field definitions will be documented after inspecting the source schema.

## 4. Synthetic CRM Customer Dataset

**File:** `synthetic_crm_customers.csv`

**Location:** `data/raw/`

### Purpose

Represents customer information maintained by a CRM system.

### Expected Analytical Usage

- Customer profile development.
- Customer identification.
- Customer demographic analysis, where applicable.
- Customer segmentation.
- Customer 360 development.

### Data Classification

Synthetic data generated using Python.

### Column-Level Documentation

To be populated after inspecting the CSV schema.

## 5. Synthetic Advertising Spend Dataset

**File:** `synthetic_ad_spend.csv`

**Location:** `data/raw/`

### Purpose

Represents advertising campaign and spending information.

### Expected Analytical Usage

- Campaign performance analysis.
- Marketing channel analysis.
- Advertising cost analysis.
- Cost per acquisition calculations.
- Marketing ROI calculations.

### Data Classification

Synthetic data generated using Python.

### Column-Level Documentation

To be populated after inspecting the CSV schema.

## 6. Synthetic Identity Mapping Dataset

**File:** `identity_mapping.csv`

**Location:** `data/raw/`

### Purpose

Represents relationships between customer identifiers across different platforms.

### Expected Analytical Usage

- Identity matching.
- Website-to-CRM identity resolution.
- Customer profile consolidation.
- Cross-platform customer journey analysis.

### Data Classification

Synthetic data generated using Python.

### Column-Level Documentation

To be populated after inspecting the CSV schema.

## 7. Data Layer Organization

| BigQuery Dataset | Purpose |
|---|---|
| `customer_360_raw` | Original source datasets |
| `customer_360_staging` | Cleaned and standardized datasets |
| `customer_360_analytics` | Integrated and analytical datasets |

These datasets represent the planned warehouse organization.

## 8. Data Dictionary Maintenance

This document will be updated whenever:

- A new data source is introduced.
- A dataset is loaded into BigQuery.
- New columns are created.
- Existing columns are transformed.
- Data types are modified.
- Business definitions or calculations are introduced.

Detailed column-level documentation will be maintained as the data integration and modelling phases progress.