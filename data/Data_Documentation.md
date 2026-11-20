# Customer 360 & Marketing Attribution
## Data Architecture, Data Dictionary and Data Integration Documentation

**Document status:** Submission-ready technical documentation  
**Platform:** Google BigQuery, dbt Core, Python, Tableau  
**BigQuery project:** `customer-360-mta`  
**BigQuery location:** `US`  
**dbt project:** `customer_360`

---

## 1. Purpose and scope

This document describes the implemented data architecture, source systems, BigQuery datasets, identity-resolution process, dbt transformation layers, analytical outputs, attribution methodology, Tableau consumption layer, validation evidence, and integration/data integration boundaries.

The solution combines web analytics, CRM-style customer records, and advertising campaign data to support a unified customer view and marketing performance analysis.

### Important implementation distinction

- GA4 source data is the public Google Analytics 4 obfuscated sample e-commerce dataset.
- CRM customer records, identity mapping records, and advertising spend/campaign records are synthetic project inputs.
- Advertising conversion counts are simulated; they must not be represented as verified conversions from a live advertising platform.
- The project uses BigQuery SQL and dbt transformations. No custom REST data integration service or production data integration endpoint is documented as implemented.
- Segment was part of the broader technology discussion, but it is not represented here as a deployed component of the final data pipeline.

---

## 2. High-level architecture

![Architecture diagram](Customer360_MarketingAttribution_Architecture.png)

The architecture follows this logical flow:

1. Source data is obtained from GA4 public sample data and synthetic CRM/advertising files.
2. Data is stored and organized in Google BigQuery.
3. Identity mapping is applied to associate website-side identifiers with CRM customer identifiers where a valid mapping exists.
4. dbt transforms the integrated data into reusable staging, intermediate, and mart models.
5. Customer analytics, RFM/CLV analysis, conversion journeys, attribution, and campaign-efficiency outputs are prepared.
6. Validation checks assess schema, model logic, reconciliation, and data quality.
7. Tableau presents the analytical outputs through executive, attribution, campaign, and marketing-efficiency dashboards.

---

## 3. Technology components

| Component | Technology | Role |
|---|---|---|
| Web analytics source | GA4 public BigQuery sample | Session, event and e-commerce activity |
| Customer data | Synthetic CRM CSV | Customer attributes and CRM-side identifiers |
| Identity input | Synthetic identity mapping CSV | Mapping website identifiers to CRM identifiers |
| Advertising input | Synthetic advertising spend CSV | Campaign-level spend and simulated performance |
| Data warehouse | Google BigQuery | Central storage and SQL processing |
| Transformation | dbt Core | Modular SQL transformations, tests and documentation |
| Supporting analytics | Python | Synthetic data generation and analytical support where used |
| Visualization | Tableau | Customer and marketing dashboards |
| Version control | Git and GitHub | Source control and project documentation |

---

## 4. Source data inventory

### 4.1 GA4 public sample data

**Source:** `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

This is Google's public, obfuscated sample e-commerce export in BigQuery. It provides event-level web analytics and e-commerce activity. The project uses this as the web-behaviour and transaction-event source.

Typical GA4 export concepts used in modelling include event date/time, event name, user/pseudo-user identifiers, traffic-source attributes, device/platform context, and e-commerce transaction or item information. The exact fields available depend on the source event schema and the transformations selected in the project.

**Important:** This is a public sample dataset, not a live export from the internship organization's GA4 property.

### 4.2 Synthetic CRM customer data

**Project input file:** `synthetic_crm_customers.csv`  
**BigQuery table:** `customer_360_raw.crm_customers`  
**Recorded source volume:** 5,000 customer records

Purpose:
- Represent CRM-side customer records.
- Provide customer identifiers and available customer attributes.
- Enable identity matching and customer-profile analysis.

The precise field list should be taken from the committed CSV header or BigQuery table schema. Do not infer or add fields that are not present in the actual file.

### 4.3 Synthetic identity mapping data

**Project input file:** `identity_mapping.csv`  
**BigQuery table:** `customer_360_raw.identity_mapping`  
**Recorded source volume:** 3,500 mapping records

Purpose:
- Link website-side identifiers to CRM-side identifiers.
- Support unified customer identification.
- Preserve unmatched web activity rather than dropping it.

The mapping is a project-generated identity bridge. It is not a claim of deterministic identity resolution across every GA4 visitor.

### 4.4 Synthetic advertising and campaign data

**Project input file:** `synthetic_ad_spend.csv`  
**BigQuery table:** `customer_360_raw.ad_spend_unpartitioned`  
**Recorded source volume:** 736 records

Recorded campaign scope:
- 8 campaigns.
- Advertising spend: **$126,552.23**.
- Simulated conversions: **6,231**.

Purpose:
- Provide campaign-level advertising investment and performance inputs.
- Support campaign and channel efficiency analysis.
- Enable demonstration of marketing reporting when live platform exports are not available.

The conversion figures are simulated and should always be labelled as such.

---

## 5. BigQuery environment and dataset inventory

**Project ID:** `customer-360-mta`  
**Location:** `US`

| Dataset | Purpose | Known tables / outputs |
|---|---|---|
| `customer_360_raw` | Source landing area | `ga4_sessions`, `crm_customers`, `identity_mapping`, `ad_spend_unpartitioned` |
| `customer_360_curated` | Integrated and curated data | `identity_resolved_sessions` |
| `customer_360_dbt_dev` | dbt development outputs | dbt staging, intermediate and mart relations, including the core marts below |

### 5.1 Raw layer

The raw layer retains source-oriented tables for GA4 sessions, CRM customers, identity mappings, and advertising spend.

### 5.2 Curated layer

`customer_360_curated.identity_resolved_sessions` is the curated identity-resolution output. The identity-matching logic uses the supplied mapping to associate website identifiers with CRM identifiers.

The process uses a `LEFT JOIN` pattern so that unmatched website records remain in the output. The resulting identity status distinguishes `IDENTIFIED` from `UNIDENTIFIED` records.

### 5.3 dbt development layer

`customer_360_dbt_dev` contains relations built by the dbt project. The exact relation names should be verified against the deployed BigQuery dataset because dbt target schemas and aliases can change with configuration.

---

## 6. Identity resolution logic

### Objective

A person may interact with the website under a web analytics identifier while their CRM profile is stored under a separate customer identifier. Identity resolution connects these records when a mapping exists.

### Logical process

1. Read the GA4 session-level input.
2. Read the synthetic identity mapping bridge.
3. Join the website-side identifier to the corresponding mapping key.
4. Obtain the CRM-side customer identifier where a match exists.
5. Retain unmatched sessions through a left join.
6. Assign an identity status of `IDENTIFIED` or `UNIDENTIFIED`.
7. Make the curated result available for downstream customer analytics.

### Output

`customer_360_curated.identity_resolved_sessions`

### Known result

The project recorded 360,129 GA4 sessions and 10,246 identified customers in the earlier validation/reporting results. These are project-run figures; they should be reconfirmed against the final deployed tables before being used as a current dashboard KPI.

### Interpretation and limitation

An `UNIDENTIFIED` record is not necessarily invalid. It indicates that the available mapping did not connect that web activity to a CRM identifier. Identity resolution coverage is constrained by the synthetic mapping inputs and matching rules.

---

## 7. dbt transformation architecture

**dbt project:** `customer_360`

The project uses a layered modelling approach:

### 7.1 Staging layer

Purpose:
- Standardize source structures.
- Rename and cast fields where required.
- Apply source-level cleaning and preparation.
- Provide consistent inputs to downstream models.

The project recorded five staging models. The exact model filenames and columns should be read from the committed `models/staging/` directory and corresponding SQL/YAML files.

### 7.2 Intermediate layer

Purpose:
- Encapsulate reusable business logic.
- Prepare joins and transformations used by analytical marts.
- Reduce duplication in downstream SQL.

### 7.3 Marts layer

Known core marts:

| Model | Purpose |
|---|---|
| `fct_sessions` | Session-level analytical fact model |
| `fct_orders` | Order/transaction-level analytical fact model |
| `dim_customer_profile` | Customer-level profile dimension |

Additional project work includes customer 360/RFM/CLV analysis, conversion journey modelling, attribution outputs, and advertising/campaign reporting. Use the actual final dbt model directory as the source of truth for exact filenames.

### 7.4 dbt commands used

Typical project workflow:

```bash
dbt debug
dbt parse
dbt run
dbt test
dbt docs generate
```

Run commands from the dbt project directory and use the configured profile/target. Credentials and local profile configuration must not be committed to GitHub.

---

## 8. Customer analytics outputs

The Customer 360 analytical work includes:

- Consolidated customer profile modelling.
- Customer-level session and order analysis.
- RFM analysis (recency, frequency, monetary value).
- Customer segmentation.
- Customer lifetime value analysis, where supported by the model's defined assumptions.

### RFM interpretation

| Dimension | Meaning |
|---|---|
| Recency | How recently a customer purchased |
| Frequency | How often a customer purchased within the defined analysis window |
| Monetary | How much revenue the customer generated within the defined analysis window |

RFM scores and segment labels depend on the scoring thresholds implemented in the SQL/dbt models. The exact thresholds should be documented from the final model SQL rather than assumed.

### CLV interpretation

Customer lifetime value is an analytical estimate based on the project's chosen calculation logic and available history. It should not be described as observed future revenue unless a predictive model and validation process explicitly support that claim.

---

## 9. Marketing attribution and campaign analytics

### 9.1 Attribution models

The project implements four attribution approaches:

| Model | Credit assignment |
|---|---|
| First-Touch | Assigns conversion credit to the first eligible touchpoint in the journey |
| Last-Touch | Assigns conversion credit to the last eligible touchpoint before conversion |
| Linear | Distributes credit equally across eligible touchpoints |
| Time-Decay | Gives relatively more credit to touchpoints closer to conversion, according to the implemented decay logic |

The precise journey window, eligible-touchpoint rules, and time-decay parameter must be taken from the final attribution SQL/model definitions.

### 9.2 Attribution reconciliation

Recorded Phase 5 validation results:
- 21 schema tests passed.
- 5 singular tests passed.
- Attribution reconciliation reported **$307,868 attributed revenue per attribution model**.
- The recorded output contained 4,452 attribution credits/records as described in the project validation notes.

The $307,868 figure is a model-level attributed revenue result, not four independent revenue pools to be added together. Attribution models are alternative credit-allocation views of the same underlying conversion/revenue scope.

### 9.3 Campaign efficiency and channel ROI

Known analytical models:
- `fct_campaign_efficiency`
- `fct_channel_roi`

Recorded campaign inputs:
- 8 campaigns.
- 736 advertising records.
- $126,552.23 advertising spend.
- 6,231 simulated conversions.

### 9.4 Critical mapping limitation

The final project validation identified incomplete campaign/source-medium mapping:
- Only the Google/CPC channel was mapped in the current implementation.
- Six source/medium combinations remained unmapped.
- Google Brand and Generic campaign performance could not be reliably separated with the available mapping.
- Campaign-level ROI and profit/incremental ROI were not established as verified measures.
- Actual GA4-based CPA for every campaign/channel is therefore unavailable.

Consequently:
- Do not describe the simulated conversion count as verified platform conversions.
- Do not present campaign-level ROAS/ROI as complete where campaign mapping is missing.
- Do not call revenue-based ROAS “profit” or “incremental ROI”.
- Use the mapped channel result only within its documented coverage.
- Treat unmapped campaign results as measurement gaps, not zero performance.

---

## 10. Tableau consumption layer

The Tableau layer presents the project's analytical outputs through four dashboards:

1. **Customer 360 Executive Overview** — consolidated customer and customer analytics view.
2. **Marketing Attribution & Conversion Insights** — comparison of the four attribution models and conversion journey insights.
3. **Campaign Performance** — campaign delivery and engagement metrics such as spend, impressions, clicks, CTR and CPC, plus available conversion metrics.
4. **Marketing Efficiency & Budget Recommendations** — available spend/revenue efficiency views, mapping coverage, CPA/ROAS measures where supported, and evidence-based recommendations.

Dashboard titles above reflect the working project naming used in the demonstration plan. Confirm the exact workbook tab captions before publishing screenshots or final documentation.

---

## 11. Data integration and access documentation

### 11.1 Data interfaces used

This project is a warehouse-centric analytics pipeline. Its documented data interfaces are:

| Interface | Type | Use |
|---|---|---|
| Google public BigQuery dataset | BigQuery SQL access | Read GA4 obfuscated sample e-commerce events |
| BigQuery tables | SQL / warehouse relations | Store raw, curated and dbt-generated data |
| CSV files | File-based ingestion | Load synthetic CRM, identity mapping and advertising data |
| dbt | SQL transformation framework | Build, test and document warehouse models |
| Tableau data connection | BI/warehouse connector | Query and visualize analytical outputs |

### 11.2 GA4 data source distinction

The project source is the public GA4 sample dataset exposed through BigQuery. This is not the same as implementing a live GA4 export integration for a production property.

### 11.3 Segment status

Segment may be listed as a potential future customer-data collection/integration capability only if clearly labelled as proposed or not deployed. It should not appear as an active data-flow component in the implementation architecture unless a working integration is subsequently verified.

### 11.4 Credentials and access

- Do not commit service-account JSON keys, OAuth tokens, passwords, or local `profiles.yml` credentials.
- Use Google Cloud IAM and local/environment-specific credential configuration.
- Grant only the BigQuery permissions required for the user's task.
- Remove customer-identifying or sensitive data from public screenshots and sample exports.

---

## 12. Validation and test evidence

Recorded validation evidence from the project:

| Validation area | Recorded result |
|---|---|
| dbt schema tests | 21 passed |
| dbt singular tests | 5 passed |
| Final data-quality validation query | Returned zero exception rows |
| Attribution reconciliation | $307,868 attributed revenue per model |
| Attribution output | 4,452 credits/records in the recorded validation |
| Campaign input scope | 8 campaigns / 736 records |
| Campaign spend | $126,552.23 |
| Simulated conversions | 6,231 |
| Channel ROI validation | Passed for the mapped channel scope |

These are historical project-run results captured during implementation. Preserve query outputs, dbt logs, and screenshots in the repository as evidence. Re-run tests against the final target before claiming that the current deployed environment still passes.

---

## 13. Known limitations and assumptions

1. GA4 is a public obfuscated sample dataset, not live organizational production data.
2. CRM, identity mapping and advertising datasets are synthetic.
3. Advertising conversions are simulated.
4. Identity resolution depends on the supplied mapping bridge; unmatched records remain unidentified.
5. Campaign/source-medium mapping is incomplete.
6. Only Google/CPC was mapped in the final recorded implementation; six source/medium combinations remained unmapped.
7. Campaign-level ROI and profit/incremental ROI are not verified.
8. Attribution outputs depend on the implemented journey definition, touchpoint eligibility, and attribution logic.
9. RFM and CLV outputs depend on the analysis window and assumptions encoded in the models.
10. No custom REST data integration service is part of the documented deployed architecture.

---

## 14. Reproduction and setup outline

1. Create or select a Google Cloud project and configure billing/IAM as required by Google Cloud.
2. Enable BigQuery access and use the `US` location for the project datasets.
3. Ensure access to the public source `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`.
4. Load the synthetic project CSV inputs into `customer_360_raw`.
5. Run the identity-resolution SQL to create `customer_360_curated.identity_resolved_sessions`.
6. Configure dbt Core and the BigQuery adapter.
7. Configure the local dbt profile for project `customer-360-mta`, dataset/target `customer_360_dbt_dev`, and the correct authentication method.
8. Run dbt debug, parse, build/run, tests, and documentation generation.
9. Connect Tableau to the relevant BigQuery/dbt output relations and refresh the workbook.
10. Execute the validation queries and compare results with the recorded evidence.

Exact package versions, file paths, and model-specific execution order should be taken from the committed `requirements.txt`, `dbt_project.yml`, profile example (without secrets), SQL scripts, and repository README.

---

## 15. Recommended repository evidence

Store the following supporting evidence alongside this document:

- Architecture PNG and editable SVG.
- BigQuery table inventory and schema exports.
- Identity-resolution SQL and validation output.
- dbt model SQL and YAML tests.
- dbt run/test logs.
- Attribution reconciliation query and output.
- Campaign mapping coverage query and output.
- Tableau workbook and dashboard screenshots.
- Final demo recording link.

---

## 16. Glossary

| Term | Definition |
|---|---|
| GA4 | Google Analytics 4 |
| BigQuery | Google's cloud data warehouse |
| dbt | Data Build Tool, used for SQL-based transformation and testing |
| Identity resolution | Linking records that refer to the same customer across systems |
| RFM | Recency, Frequency, Monetary customer analysis |
| CLV | Customer Lifetime Value |
| Attribution | Allocation of conversion credit across marketing touchpoints |
| CPA | Cost per Acquisition |
| CPC | Cost per Click |
| CTR | Click-Through Rate |
| ROAS | Return on Advertising Spend, typically attributed revenue divided by ad spend |
| ROI | Return on Investment; definition must specify whether based on revenue, profit, or incremental lift |

---

**Documentation note:** Where exact column-level schemas or model-specific formulas are required, the deployed BigQuery schema and committed SQL/YAML definitions are the source of truth. This document intentionally avoids inventing fields, data integration endpoints, or calculation rules that were not verified in the project record.
