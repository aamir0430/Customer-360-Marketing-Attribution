# Project Journal
## Customer 360 & Marketing Attribution Programme

---

## Phase 1 – Data Source Setup and Dataset Generation

**Status:** Completed  
**Completion Date:** 10 November 2026

### 1. Objective

The objective of Phase 1 was to establish the project's initial data sources and generate the synthetic datasets required for building an integrated Customer 360 and Marketing Attribution analytics platform.

The project uses the Google Analytics 4 (GA4) public ecommerce sample dataset in BigQuery, supplemented by synthetic CRM customer data, advertising spend data, and identity mapping data.

### 2. Work Completed

#### 2.1 GA4 Sample Dataset Inspection

- Selected Google's public GA4 ecommerce sample dataset in BigQuery.
- Source dataset: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`.
- Examined the available event data, identifiers, session information, traffic sources, and ecommerce purchase information.
- Reviewed the available GA4 fields to guide the design of the synthetic CRM and advertising datasets.

#### 2.2 Synthetic CRM Customer Dataset

Generated a synthetic CRM customer dataset using Python.

**File:** `synthetic_crm_customers.csv`

Purpose:
- Represent customer records maintained by a CRM system.
- Provide customer attributes and identifiers.
- Support future customer identity resolution and unified customer profile development.

#### 2.3 Synthetic Advertising Spend Dataset

Generated a synthetic advertising spend dataset using Python.

**File:** `synthetic_ad_spend.csv`

Purpose:
- Represent advertising campaigns and their associated spending information.
- Support marketing performance analysis.
- Enable future calculations of advertising ROI, customer acquisition cost, and campaign effectiveness.

#### 2.4 Identity Mapping Dataset

Generated a synthetic identity mapping dataset.

**File:** `identity_mapping.csv`

Purpose:
- Represent relationships between customer identifiers across different platforms.
- Support the development and testing of the identity resolution process.
- Provide a mapping foundation for connecting website sessions with CRM customers.

### 3. Generated Datasets

The following three CSV datasets have been generated successfully:

| Dataset | File |
|---|---|
| Synthetic CRM Customers | `synthetic_crm_customers.csv` |
| Synthetic Advertising Spend | `synthetic_ad_spend.csv` |
| Identity Mapping | `identity_mapping.csv` |

These datasets are organized under:

`data/raw/`

The GA4 public ecommerce dataset remains available through BigQuery and serves as the behavioural data source.

### 4. Technology and Tools Used

- Python
- Pandas
- Faker
- Google BigQuery
- SQL
- Git
- GitHub

### 5. Phase 1 Deliverables

- Identified the GA4 public ecommerce sample dataset.
- Inspected the GA4 data structure for integration requirements.
- Generated the synthetic CRM customer dataset.
- Generated the synthetic advertising spend dataset.
- Generated the synthetic identity mapping dataset.
- Established the initial data foundation for the Customer 360 project.

### 6. Current Project Status

**Phase 1: Completed.**

All three synthetic CSV datasets have been generated.

The next phase focuses on building an identity resolution process that connects website sessions with CRM customer records.

The immediate next task is to prepare and load the required CSV files into BigQuery so that all necessary source tables are available for subsequent SQL transformations and identity resolution.

### 7. Next Steps

**Phase 2 – Identity Resolution**

1. Prepare the three CSV files for BigQuery ingestion.
2. Load the required CSV datasets into the appropriate BigQuery raw dataset.
3. Validate the loaded tables and their schemas.
4. Develop SQL logic to connect website sessions with customer records.
5. Build and validate the identity resolution output.

---

*End of Phase 1 Journal Entry.*