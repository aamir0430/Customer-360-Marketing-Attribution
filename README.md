# Customer 360 & Marketing Attribution Programme

An end-to-end data analytics and marketing intelligence project that integrates customer, e-commerce, and advertising data to develop a unified Customer 360 view, perform customer segmentation, implement multi-touch marketing attribution, and evaluate marketing campaign efficiency.

The project uses Google BigQuery, dbt Core, SQL, Python, and Tableau to build a structured analytical data platform and generate actionable business insights.

---

## Table of Contents

1. [Project Overview](#1-project-overview)
2. [Business Objectives](#2-business-objectives)
3. [Technology Stack](#3-technology-stack)
4. [Data Sources](#4-data-sources)
5. [Project Architecture](#5-project-architecture)
6. [Repository Structure](#6-repository-structure)
7. [Project Implementation](#7-project-implementation)
   - Phase 1: Data Source Setup
   - Phase 2: Data Ingestion and Identity Resolution
   - Phase 3: dbt Data Modelling
   - Phase 4: RFM Analysis, Customer Segmentation and Customer 360
   - Phase 5: Marketing Attribution
   - Phase 6: Campaign ROI and Marketing Efficiency
8. [Key Analytical Models](#8-key-analytical-models)
9. [Key Project Results](#9-key-project-results)
10. [Attribution Methodology](#10-attribution-methodology)
11. [Business Insights](#11-business-insights)
12. [Data Quality and Validation](#12-data-quality-and-validation)
13. [Known Limitations and Assumptions](#13-known-limitations-and-assumptions)
14. [Project Setup and Execution](#14-project-setup-and-execution)
15. [Documentation and Validation Evidence](#15-documentation-and-validation-evidence)
16. [Project Status and Future Work](#16-project-status-and-future-work)

---

# 1. Project Overview

The Customer 360 & Marketing Attribution Programme is an end-to-end data analytics solution designed to connect customer behaviour, e-commerce transactions, and marketing performance.

Modern businesses collect customer information across multiple platforms, including websites, CRM systems, advertising channels, and transaction databases. However, these sources frequently operate independently, making it difficult to understand the complete customer journey and evaluate marketing effectiveness.

This project addresses these challenges by developing an integrated analytical environment that:

- Consolidates customer information from multiple sources.
- Resolves customer identities across different datasets.
- Builds unified customer profiles.
- Analyses purchasing behaviour using RFM analysis.
- Estimates historical Customer Lifetime Value (CLV).
- Implements multiple marketing attribution models.
- Evaluates advertising campaign and channel efficiency.
- Provides a foundation for interactive business intelligence dashboards.

The final objective is to transform disconnected customer and marketing data into structured, reliable, and actionable business intelligence.

---

# 2. Business Objectives

The project addresses the following business requirements:

### Customer Analytics

- Integrate GA4 e-commerce data with CRM customer records.
- Resolve customer identities across multiple data sources.
- Build a unified Customer 360 profile.
- Analyse customer purchasing behaviour.
- Segment customers using Recency, Frequency and Monetary analysis.
- Calculate historical Customer Lifetime Value.

### Marketing Attribution

- Reconstruct customer conversion journeys.
- Identify marketing touchpoints associated with purchases.
- Implement First-Touch attribution.
- Implement Last-Touch attribution.
- Implement Linear attribution.
- Implement Time-Decay attribution.
- Compare revenue allocation across attribution models.

### Marketing Performance

- Analyse advertising expenditure.
- Calculate impressions, clicks and conversion metrics.
- Evaluate cost per click and cost per simulated conversion.
- Calculate attributed CPA where mapping is supported.
- Calculate channel-level ROAS and revenue-based attributed return.
- Identify limitations in campaign-to-revenue attribution.

### Business Intelligence

- Develop analytical dashboards in Tableau.
- Present customer segmentation and purchasing insights.
- Compare marketing attribution models.
- Communicate marketing efficiency findings.
- Support data-driven marketing recommendations.

---

# 3. Technology Stack

| Technology | Purpose |
|---|---|
| Google BigQuery | Cloud data warehouse and analytical SQL processing |
| dbt Core | Data transformation, modelling and testing |
| dbt-bigquery | BigQuery integration for dbt |
| SQL | Data extraction, transformation and analytical queries |
| Python 3.11.4 | Data preparation and supporting analytics |
| Google Analytics 4 (GA4) | E-commerce sessions, events and purchase data |
| Tableau | Planned business intelligence dashboards |
| Git | Version control |
| GitHub | Source code management and project documentation |
| Segment | Customer data and identity-related technology context |

### Environment Versions

- Python: 3.11.4
- dbt Core: 1.12.7
- dbt-bigquery: 1.12.3

---

# 4. Data Sources

The project combines actual sample e-commerce event data with synthetic supporting datasets.

## 4.1 Google Analytics 4 Sample E-commerce Dataset

Source: GA4 public sample e-commerce dataset hosted in Google BigQuery.

Contains information about:

- Website sessions.
- User interactions.
- Traffic sources and mediums.
- Marketing campaigns.
- Product interactions.
- E-commerce purchases.
- Transaction identifiers.
- Purchase revenue.

Used for customer journey reconstruction, transaction analysis, customer behaviour modelling, and marketing attribution.

## 4.2 Synthetic CRM Dataset

A synthetic CRM dataset containing 5,000 customer records.

Contains customer-related information used for:

- Customer identification.
- Identity resolution.
- Customer profile construction.
- RFM segmentation.
- Historical CLV analysis.

## 4.3 Synthetic Identity Mapping Dataset

A supporting mapping dataset containing 3,500 customer identity mappings.

Used to connect identifiers from GA4 sessions with CRM customer records.

## 4.4 Synthetic Advertising Spend Dataset

Contains advertising campaign performance records for eight marketing campaigns across 92 dates.

The dataset includes:

- Campaign ID.
- Campaign name.
- Advertising channel.
- Source and medium.
- Impressions.
- Clicks.
- Simulated conversions.
- Advertising expenditure.
- Campaign dates.

The advertising dataset is used to analyse advertising efficiency and calculate cost per simulated conversion.

**Important:** Synthetic advertising conversions are separate from actual GA4 purchase transactions.

---

# 5. Project Architecture

The project follows a layered data architecture.

```text
                  DATA SOURCES
                       |
          +------------+------------+
          |            |            |
       GA4 Data     CRM Data    Ad Spend Data
          |            |            |
          +------------+------------+
                       |
                       v
              GOOGLE BIGQUERY
                       |
                       v
              RAW DATA LAYER
             customer_360_raw
                       |
                       v
             DATA PREPARATION
                       |
                       v
             CURATED DATA LAYER
           customer_360_curated
                       |
                       v
             IDENTITY RESOLUTION
                       |
                       v
                  dbt CORE
                       |
           +-----------+-----------+
           |           |           |
        STAGING    INTERMEDIATE   MARTS
           |           |           |
           +-----------+-----------+
                       |
                       v
             ANALYTICAL DATA MODELS
                       |
        +--------------+--------------+
        |              |              |
     Customer       Marketing       Campaign
      360           Attribution     Efficiency
        |              |              |
        +--------------+--------------+
                       |
                       v
              TABLEAU DASHBOARDS
                       |
                       v
             BUSINESS INSIGHTS
             AND RECOMMENDATIONS
```

## BigQuery Datasets

| Dataset | Purpose |
|---|---|
| `customer_360_raw` | Raw source data and synthetic datasets |
| `customer_360_curated` | Prepared and identity-resolved data |
| `customer_360_dbt_dev` | dbt development and analytical models |

**Google Cloud Project ID:**

`customer-360-mta`

**BigQuery Location:**

`US`

---

# 6. Repository Structure

The repository is organised to separate SQL scripts, dbt models, documentation, and validation evidence.

```text
Customer-360-Marketing-Attribution/
│
├── README.md
│
├── dbt/
│   └── customer_360/
│       │
│       ├── models/
│       │   ├── staging/
│       │   │   ├── ga4/
│       │   │   ├── crm/
│       │   │   └── ads/
│       │   │
│       │   ├── intermediate/
│       │   │
│       │   └── marts/
│       │       ├── core/
│       │       └── marketing/
│       │
│       ├── macros/
│       ├── seeds/
│       ├── snapshots/
│       ├── tests/
│       ├── dbt_project.yml
│       └── packages.yml
│
├── SQL/
│   ├── 00_Profiling/
│   ├── 001_Restore/
│   ├── 02_Warehouse/
│   ├── 03_ETL/
│   │
│   └── 06_Campaign_ROI_CPA/
│       ├── 01_campaign_roi_schema_investigation.sql
│       ├── 02_campaign_efficiency_validation.sql
│       ├── 03_campaign_mapping_investigation.sql
│       └── 04_channel_roi_validation.sql
│
├── documentation/
│   ├── architecture.md
│   ├── data_dictionary.md
│   ├── definitions.md
│   ├── decisions.md
│   ├── methodology.md
│   ├── project_journal.md
│   ├── results.md
│   ├── setup_guide.md
│   ├── testing.md
│   │
│   └── validation/
│       ├── phase_1/
│       ├── phase_2/
│       ├── phase_3/
│       ├── phase_4/
│       ├── phase_5/
│       └── phase_6/
│
└── .gitignore
```

*Note: The tree represents the logical organisation of the project. Individual folders contain the scripts, models and evidence created during their respective phases.*

---

# 7. Project Implementation

The project is divided into eight implementation phases.

## Phase 1 – Data Source Setup

**Status: Completed**

### Objective

Establish the required source datasets for the Customer 360 and Marketing Attribution Programme.

### Activities

- Identified and accessed the GA4 sample e-commerce dataset.
- Created the Google Cloud project and BigQuery environment.
- Prepared the synthetic CRM customer dataset.
- Prepared the synthetic identity mapping dataset.
- Generated the synthetic advertising spend dataset.
- Established the raw data environment.

### Deliverables

- GA4 source data access.
- CRM dataset.
- Identity mapping dataset.
- Advertising spend dataset.
- BigQuery raw dataset structure.

---

## Phase 2 – BigQuery Ingestion and Identity Resolution

**Status: Completed**

### Objective

Load the source datasets into BigQuery and establish relationships between GA4 user identifiers and CRM customer records.

### Activities

- Loaded source datasets into BigQuery.
- Inspected and profiled the source tables.
- Created the identity resolution mapping.
- Matched GA4 identifiers against synthetic CRM records.
- Created the identity-resolved session dataset.
- Validated identity mapping results.

### Key Results

- CRM customer records: 5,000.
- Identity mapping records: 3,500.
- GA4 sessions retained in the identity-resolved dataset: 360,129.
- Identified session records: 10,246.
- Unidentified session records: 349,883.

The identity resolution process established a foundation for customer-level analysis.

**Limitation:** The identity mapping is synthetic and does not establish real-world identity-resolution accuracy.

---

## Phase 3 – dbt Data Modelling

**Status: Completed**

### Objective

Build a structured transformation layer using dbt Core.

### Activities

- Configured the dbt project.
- Connected dbt to Google BigQuery.
- Established staging models.
- Developed intermediate transformations.
- Created core analytical marts.
- Generated dbt documentation.
- Reviewed model dependencies and lineage.

### Main Models

- `fct_sessions`
- `fct_orders`
- `dim_customer_profile`

### dbt Development Environment

- Project: `customer_360`
- Development dataset: `customer_360_dbt_dev`

The resulting models provide the foundation for customer analytics, segmentation, and marketing attribution.

---

## Phase 4 – RFM Analysis, Customer Segmentation and Customer 360

**Status: Completed**

### Objective

Develop customer-level analytical models to understand purchasing behaviour, customer value, and customer segments.

### Activities

1. Developed Recency, Frequency and Monetary metrics.
2. Calculated RFM scores.
3. Created customer segments.
4. Calculated historical Customer Lifetime Value.
5. Integrated customer, transaction, and segmentation information.
6. Created the unified Customer 360 analytical model.
7. Validated customer-level metrics and relationships.

### Main Models

| Model | Purpose |
|---|---|
| `fct_customer_rfm` | Customer RFM calculations |
| `fct_customer_rfm_scores` | RFM scoring |
| `dim_customer_segments` | Customer segment classification |
| `fct_customer_clv` | Historical Customer Lifetime Value |
| `dim_customer_360_analytics` | Unified Customer 360 analytical profile |

### Key Results

| Metric | Result |
|---|---:|
| CRM customers | 5,000 |
| Purchasers | 2,091 |
| Non-purchasers | 2,909 |
| Identified customer orders | 2,504 |
| Identified customer revenue | $169,649 |
| Historical CLV revenue | $169,649 |
| Missing customer segments | 0 |
| Missing CLV records | 0 |

### Unresolved Customer Transactions

A total of 1,948 orders worth $138,219 had no resolved CRM customer ID.

These transactions remain unassigned and are excluded from customer-level RFM and CLV calculations.

### Outcome

The unified Customer 360 model provides a consolidated view of customer purchasing behaviour, segmentation, and historical value.

**Limitation:** Historical CLV is descriptive and is not a predictive future revenue estimate.

---

## Phase 5 – Marketing Attribution and Advertising Performance

**Status: Completed**

### Objective

Reconstruct customer conversion journeys and implement multiple attribution methodologies to understand how marketing touchpoints receive purchase credit.

### Activities

- Prepared advertising performance data.
- Developed customer conversion journey models.
- Implemented First-Touch attribution.
- Implemented Last-Touch attribution.
- Implemented Linear attribution.
- Implemented Time-Decay attribution.
- Created attribution comparison models.
- Developed campaign and channel performance summaries.
- Built consolidated marketing performance reporting.
- Validated transaction, attribution credit, and revenue reconciliation.

### Main Models

| Model | Purpose |
|---|---|
| `fct_conversion_journeys` | Customer conversion journeys |
| `fct_first_last_touch_attribution` | First-Touch and Last-Touch attribution |
| `fct_linear_attribution` | Linear attribution |
| `fct_time_decay_attribution` | Time-Decay attribution |
| `fct_attribution_comparison` | Comparison of attribution models |
| `fct_ad_spend_performance` | Advertising performance |
| `fct_campaign_performance_summary` | Campaign performance aggregation |
| `fct_channel_performance_summary` | Channel performance aggregation |
| `fct_marketing_performance_reporting` | Consolidated marketing reporting |

### Attribution Results

The attribution models were validated against the same set of GA4 purchase transactions.

| Metric | Result |
|---|---:|
| GA4 purchase transactions | 4,452 |
| GA4 purchase revenue | $307,868 |
| Conversion journey records | 11,496 |
| Distinct touchpoint sessions | 9,144 |

All four attribution models reconcile to:

- 4,452 purchase transactions.
- 4,452 total attribution credit.
- $307,868 attributed revenue.

### Advertising Dataset Results

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Campaign-date records | 736 |
| Advertising dates | 92 |
| Impressions | 9,246,272 |
| Clicks | 186,706 |
| Simulated conversions | 6,231 |
| Advertising spend | $126,552.23 |

### Outcome

Phase 5 established a complete attribution modelling foundation and consolidated advertising performance reporting.

**Important limitation:** Advertising campaign identifiers could not be reliably mapped to individual GA4 purchase revenue. This limitation was carried forward into Phase 6.

---

## Phase 6 – Campaign ROI, CPA and Marketing Efficiency

**Status: Implementation and validation completed, with documented measurement limitations.**

### Objective

Calculate campaign and channel marketing efficiency by combining advertising expenditure with available GA4 attribution results.

The phase focused on:

- Campaign-level advertising efficiency.
- Cost per simulated conversion.
- Attributed Cost per Acquisition.
- Return on Advertising Spend.
- Revenue-based attributed return.
- Campaign-to-GA4 mapping investigation.

### Models Developed

#### 1. `fct_campaign_efficiency`

Location:

`dbt/models/marts/marketing/fct_campaign_efficiency.sql`

Provides campaign-level advertising efficiency metrics.

Includes:

- Campaign identifiers and names.
- Advertising expenditure.
- Impressions and clicks.
- Simulated conversions.
- CTR.
- CPC.
- Simulated conversion rate.
- Cost per simulated conversion.
- Campaign mapping status.

#### 2. `fct_channel_roi`

Location:

`dbt/models/marts/marketing/fct_channel_roi.sql`

Provides channel-level attribution-based marketing efficiency metrics.

Includes:

- Advertising source and medium.
- Campaign count.
- Total advertising expenditure.
- Attribution model.
- Attributed transactions.
- Attribution credit.
- Attributed revenue.
- Attributed CPA.
- ROAS.
- Revenue-based attributed return.
- Mapping status.

### Campaign Efficiency Results

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Impressions | 9,246,272 |
| Clicks | 186,706 |
| Simulated conversions | 6,231 |
| Total advertising spend | $126,552.23 |
| Overall cost per simulated conversion | $20.31 |

### Google Paid Search Attribution Results

The investigation identified a source/medium match for:

`google / cpc`

Two synthetic advertising campaigns shared this source/medium combination:

- CMP001 – Google Search - Brand
- CMP002 – Google Search - Generic

Their combined advertising expenditure was $71,555.99.

GA4 did not distinguish their individual campaign IDs, so expenditure was aggregated before calculating channel-level efficiency.

| Metric | First Touch | Last Touch | Linear | Time Decay |
|---|---:|---:|---:|---:|
| Advertising Spend | $71,555.99 | $71,555.99 | $71,555.99 | $71,555.99 |
| Attributed Revenue | $5,087.00 | $2,960.00 | $3,718.36 | $3,524.97 |
| Attribution Credit | 68 | 43 | 51.004 | 48.4607 |
| Attributed CPA | $1,052.29 | $1,664.09 | $1,402.95 | $1,476.58 |
| ROAS | 0.0711x | 0.0414x | 0.0520x | 0.0493x |
| Revenue-Based Return | -92.89% | -95.86% | -94.80% | -95.07% |

### Phase 6 Validation

The following checks were completed:

- Campaign record count validation.
- Distinct campaign validation.
- Advertising expenditure reconciliation.
- Simulated conversion reconciliation.
- Campaign mapping investigation.
- Channel-level attribution metric validation.
- Mapping status validation.

All campaign and channel reconciliation checks passed.

### Outcome

Phase 6 provides:

- Campaign-level advertising efficiency for all eight campaigns.
- Cost per simulated conversion.
- Channel-level attributed CPA where mapping is supported.
- Channel-level ROAS.
- Revenue-based attributed return.
- Explicit reporting of unavailable campaign-level metrics.

**Measurement limitation:** Actual individual campaign-level CPA and ROAS remain unavailable because the campaign identifiers cannot be reliably linked to individual GA4 attributed revenue. Revenue-based attributed return is not equivalent to verified profit-based ROI or incremental marketing ROI.

---

# 8. Key Analytical Models

The project includes several analytical model categories.

## Customer Analytics

| Model | Description |
|---|---|
| `fct_sessions` | Session-level analytical data |
| `fct_orders` | E-commerce transaction analysis |
| `dim_customer_profile` | Customer profile information |
| `fct_customer_rfm` | RFM calculations |
| `fct_customer_rfm_scores` | Customer scoring |
| `dim_customer_segments` | Customer segment classification |
| `fct_customer_clv` | Historical customer value |
| `dim_customer_360_analytics` | Unified customer analytics |

## Marketing Attribution

| Model | Description |
|---|---|
| `fct_conversion_journeys` | Conversion journey reconstruction |
| `fct_first_last_touch_attribution` | First and last touch attribution |
| `fct_linear_attribution` | Linear credit distribution |
| `fct_time_decay_attribution` | Time-weighted credit distribution |
| `fct_attribution_comparison` | Attribution model comparison |

## Marketing Efficiency

| Model | Description |
|---|---|
| `fct_ad_spend_performance` | Daily advertising metrics |
| `fct_campaign_performance_summary` | Campaign-level advertising aggregation |
| `fct_channel_performance_summary` | Channel-level advertising aggregation |
| `fct_marketing_performance_reporting` | Consolidated marketing reporting |
| `fct_campaign_efficiency` | Campaign-level efficiency metrics |
| `fct_channel_roi` | Channel-level attribution efficiency |

---

# 9. Key Project Results

The following table summarises the major results achieved across the completed phases.

| Area | Key Result |
|---|---|
| CRM Dataset | 5,000 customers |
| Identity Mapping | 3,500 mappings |
| GA4 Sessions | 360,129 sessions retained in identity-resolved dataset |
| Identified Sessions | 10,246 |
| Customer Purchasers | 2,091 |
| Identified Customer Orders | 2,504 |
| Identified Customer Revenue | $169,649 |
| GA4 Purchase Transactions | 4,452 |
| GA4 Purchase Revenue | $307,868 |
| Conversion Journey Records | 11,496 |
| Attribution Models | 4 |
| Advertising Campaigns | 8 |
| Advertising Impressions | 9,246,272 |
| Advertising Clicks | 186,706 |
| Simulated Conversions | 6,231 |
| Advertising Spend | $126,552.23 |
| Overall Cost per Simulated Conversion | $20.31 |
| Mapped Advertising Source/Medium | Google / CPC |

These figures belong to different analytical datasets and scopes. They should not be combined into a single revenue or profitability calculation without a verified relationship.

---

# 10. Attribution Methodology

Four attribution models were developed to compare how marketing touchpoints receive credit for conversions.

## First-Touch Attribution

Assigns 100% of conversion credit to the first recorded marketing touchpoint in the conversion journey.

Purpose:

Understand which marketing channels initially introduce customers to the business.

## Last-Touch Attribution

Assigns 100% of conversion credit to the final recorded marketing touchpoint before conversion.

Purpose:

Understand which channels receive credit immediately before purchase.

## Linear Attribution

Distributes conversion credit equally across all eligible touchpoints in a conversion journey.

Purpose:

Understand the contribution of marketing channels throughout the customer journey.

## Time-Decay Attribution

Assigns greater conversion credit to more recent touchpoints.

The implementation uses a seven-day half-life assumption.

Purpose:

Give more weight to marketing interactions closer to the purchase event.

### Attribution Comparison

The four models provide alternative interpretations of marketing contribution.

They are not independent revenue streams. Each model allocates the same underlying purchase revenue differently.

---

# 11. Business Insights

The project establishes several important analytical capabilities.

### Customer Insights

- Customer records can be consolidated into a unified analytical profile.
- Purchasing behaviour can be evaluated using RFM analysis.
- Customers can be grouped into behavioural segments.
- Historical customer value can be analysed.
- Unidentified transactions can be distinguished from resolved customer purchases.

### Marketing Insights

- Different attribution models distribute conversion credit differently.
- First-Touch and Last-Touch attribution provide different perspectives on marketing contribution.
- Linear and Time-Decay attribution provide alternative multi-touch allocation approaches.
- Advertising expenditure and simulated conversions can be evaluated at campaign level.
- Google Paid Search expenditure can be compared with matching GA4 attributed revenue at the channel level.

### Marketing Efficiency Insights

The Google CPC channel shows attributed revenue below advertising expenditure across all four attribution models.

This indicates weak observed attributed-revenue efficiency within the available data.

However, the result should not be interpreted as proof of actual campaign profitability or incremental marketing impact.

---

# 12. Data Quality and Validation

Data quality and model validation were incorporated throughout the project.

### Validation Activities

- Source table profiling.
- Data type inspection.
- Identity mapping validation.
- Customer-level metric reconciliation.
- RFM scoring validation.
- CLV reconciliation.
- Attribution transaction reconciliation.
- Attribution credit reconciliation.
- Attribution revenue reconciliation.
- Advertising spend reconciliation.
- Campaign mapping investigation.
- Channel-level CPA and ROAS validation.

### Phase 5 dbt Testing

The recorded Phase 5 schema and singular test execution reported:

- 21 tests passed.
- 0 warnings.
- 0 errors.

The five singular tests are included within the 21-test execution and should not be counted again as additional unique tests.

### Phase 6 Validation

Campaign efficiency and channel ROI validation confirmed:

- Eight campaign records.
- Eight distinct campaign IDs.
- Zero advertising spend reconciliation difference.
- Zero simulated conversion reconciliation difference.
- Ten channel ROI validation records.
- Zero failed validation records.

Validation evidence is maintained in:

`documentation/validation/`

---

# 13. Known Limitations and Assumptions

The project documents the following limitations to ensure that analytical findings are interpreted correctly.

## 13.1 Synthetic Identity Mapping

The CRM identity mapping dataset is synthetic.

Therefore, successful matching does not establish the accuracy of real-world identity resolution.

## 13.2 Unidentified Customer Transactions

A portion of GA4 purchase transactions could not be associated with a resolved CRM customer.

These transactions are excluded from customer-level RFM and CLV calculations.

## 13.3 Historical CLV

The calculated CLV represents historical observed customer revenue.

It is not a predictive estimate of future customer revenue.

## 13.4 Synthetic Advertising Conversions

The advertising dataset contains simulated conversions.

These conversions must not be treated as actual GA4 purchase transactions.

## 13.5 Campaign Mapping

The advertising dataset uses campaign identifiers, while GA4 attribution contains campaign touchpoint information.

A verified campaign-ID-level relationship could not be established for all eight campaigns.

Google CPC was the only identified source/medium match.

Consequently, CMP001 and CMP002 expenditure was aggregated for channel-level efficiency calculations.

Individual campaign-level attributed revenue remains unavailable.

## 13.6 Attribution Assumptions

The Time-Decay model uses a seven-day half-life assumption.

Different attribution windows or weighting assumptions may produce different results.

## 13.7 Revenue-Based Return

The Phase 6 revenue-based attributed return calculation is:

`((Attributed Revenue - Advertising Spend) / Advertising Spend) × 100`

This is an attributed-revenue efficiency proxy.

It is not equivalent to profit-based ROI because verified profit margins, incremental revenue, and other associated costs are not available.

## 13.8 Attribution Interpretation

Attribution models allocate credit to marketing touchpoints.

They do not independently prove that a particular touchpoint caused a purchase.

---

# 14. Project Setup and Execution

The following instructions describe how to configure the development environment.

## Prerequisites

- Python 3.11.4
- Google Cloud account
- Google BigQuery access
- dbt Core
- dbt-bigquery adapter
- Git
- Access to the required source datasets

## Step 1: Clone the Repository

```bash
git clone https://github.com/aamir0430/Customer-360-Marketing-Attribution.git
```

Navigate to the project directory:

```bash
cd Customer-360-Marketing-Attribution
```

## Step 2: Install dbt

Install the required packages:

```bash
pip install dbt-core==1.12.7 dbt-bigquery==1.12.3
```

Verify installation:

```bash
dbt --version
```

## Step 3: Configure BigQuery Authentication

Configure Google Cloud authentication using an appropriate Google Cloud authentication method.

Ensure that the authenticated account has permission to access the required BigQuery project and datasets.

Configure the dbt BigQuery profile in:

`~/.dbt/profiles.yml`

The profile should specify:

- Project ID: `customer-360-mta`
- Dataset: `customer_360_dbt_dev`
- Location: `US`
- Adapter: BigQuery

Authentication credentials should remain outside the GitHub repository.

## Step 4: Configure dbt

Navigate to the dbt project directory:

```bash
cd dbt/customer_360
```

Verify the dbt connection:

```bash
dbt debug
```

## Step 5: Run dbt Models

Execute the models:

```bash
dbt run
```

To execute a specific model:

```bash
dbt run --select fct_campaign_efficiency
```

Or:

```bash
dbt run --select fct_channel_roi
```

## Step 6: Execute Tests

Run the configured dbt tests:

```bash
dbt test
```

## Step 7: Generate dbt Documentation

Generate documentation:

```bash
dbt docs generate
```

Serve the documentation locally:

```bash
dbt docs serve
```

This provides access to model descriptions, dependencies, and lineage information.

**Note:** Successful execution depends on having the required source datasets, dbt configuration, authentication, and model dependencies available.

---

# 15. Documentation and Validation Evidence

Technical documentation and supporting validation evidence are maintained separately from the implementation models.

| Documentation File | Description |
|---|---|
| `architecture.md` | Project architecture and data flow |
| `data_dictionary.md` | Table and column descriptions |
| `definitions.md` | Business and analytical metric definitions |
| `decisions.md` | Technical and analytical decisions |
| `methodology.md` | Data transformation and analytical methodology |
| `project_journal.md` | Development progress and phase history |
| `results.md` | Project findings and analytical results |
| `setup_guide.md` | Environment setup instructions |
| `testing.md` | Validation and testing results |

### Validation Evidence

Validation outputs are maintained under:

```text
documentation/validation/
```

Separate folders are maintained for the individual project phases.

Phase 6 validation evidence includes:

1. `01_campaign_roi_schema_investigation.csv`
2. `02_campaign_efficiency_validation.csv`
3. `03_campaign_mapping_investigation.csv`
4. `04_channel_roi_validation.csv`

These files provide evidence of the campaign efficiency calculations, mapping investigation, and channel-level validation.

---

# 16. Project Status and Future Work

## Overall Project Progress

| Phase | Description | Status |
|---|---|---|
| Phase 1 | Data Source Setup | Completed |
| Phase 2 | Data Ingestion and Identity Resolution | Completed |
| Phase 3 | dbt Data Modelling | Completed |
| Phase 4 | RFM Analysis, Customer Segmentation and Customer 360 | Completed |
| Phase 5 | Marketing Attribution | Completed |
| Phase 6 | Campaign ROI and Marketing Efficiency | Implementation and validation completed, with limitations |
| Phase 7 | Tableau Dashboard Development and Recommendations | Planned |
| Phase 8 | Final Testing and Project Completion | Planned |

## Phase 7 – Tableau Dashboard Development

The next phase will focus on presenting the analytical models through interactive Tableau dashboards.

Planned dashboard areas include:

### Customer 360 Dashboard

- Customer distribution.
- Customer segment analysis.
- Customer purchasing behaviour.
- Historical customer value.
- Customer revenue contribution.

### Marketing Attribution Dashboard

- Conversion journey analysis.
- First-Touch versus Last-Touch comparison.
- Linear attribution analysis.
- Time-Decay attribution analysis.
- Attributed revenue by channel.
- Attribution model comparison.

### Campaign Efficiency Dashboard

- Advertising spend.
- Impressions and clicks.
- CTR and CPC.
- Simulated conversions.
- Cost per simulated conversion.
- Channel-level attributed CPA.
- Channel-level ROAS.
- Revenue-based attributed return.

### Business Recommendations

- Customer segment opportunities.
- Marketing channel performance.
- Advertising efficiency observations.
- Attribution model comparison.
- Data quality and measurement improvement recommendations.

All dashboards will clearly distinguish actual GA4 attribution metrics from synthetic advertising performance.

## Phase 8 – Final Testing and Project Completion

The final phase will focus on:

- End-to-end data pipeline verification.
- Analytical model testing.
- Dashboard validation.
- Business findings and recommendations.
- Final technical documentation.
- GitHub repository cleanup.
- Final project presentation and demonstration.

---

# Project Conclusion

The Customer 360 & Marketing Attribution Programme establishes an integrated analytical foundation connecting customer data, e-commerce transactions, customer segmentation, conversion journeys, and advertising performance.

Across the first six phases, the project has developed:

- A BigQuery-based analytical data environment.
- An identity resolution workflow.
- A dbt transformation architecture.
- Unified Customer 360 analytical models.
- RFM-based customer segmentation.
- Historical Customer Lifetime Value analysis.
- Four marketing attribution models.
- Consolidated advertising performance reporting.
- Campaign-level advertising efficiency analysis.
- Channel-level attribution-based CPA, ROAS, and revenue-based return calculations.

The project also identifies important data quality and campaign mapping limitations rather than introducing unsupported assumptions.

The remaining phases will focus on Tableau dashboard development, business recommendations, and final project delivery.

---

**Project:** Customer 360 & Marketing Attribution Programme

**Repository:** [Customer-360-Marketing-Attribution](https://github.com/aamir0430/Customer-360-Marketing-Attribution)

**Primary Technologies:** Google BigQuery, dbt Core, SQL, Python, Tableau, Git and GitHub.