# Customer 360 & Marketing Attribution

### An End-to-End Customer Analytics and Marketing Performance Intelligence Solution

**Organization:** Nexvia Technologies  
**Project Domain:** Data Analytics | Customer Analytics | Marketing Attribution  
**Data Warehouse:** Google BigQuery  
**Transformation Framework:** dbt Core  
**Visualization:** Tableau  
**Programming & Query Languages:** Python, SQL  
**Version Control:** Git & GitHub  
**Project Status:** Completed

---

# 1. Project Overview

Customer 360 & Marketing Attribution is an end-to-end data analytics project designed to integrate fragmented customer information, establish unified customer identities, analyze customer behaviour, and evaluate marketing performance through multiple attribution methodologies.

Businesses collect customer information through different platforms, including website analytics, CRM systems and advertising channels. However, these datasets are often disconnected, making it difficult to understand the complete customer journey and accurately evaluate marketing effectiveness.

This project addresses these challenges by developing an integrated analytics pipeline using Google BigQuery, dbt Core and Tableau.

The solution combines customer data integration, identity resolution, customer segmentation, customer lifetime value analysis, marketing attribution and campaign efficiency reporting into one analytical framework.

The final output consists of four interactive Tableau dashboards that provide customer insights, marketing performance comparisons and evidence-based recommendations.

---

# 2. Business Problem

The project addresses five primary business challenges:

### 2.1 Fragmented Customer Data
Customer information exists across different systems, preventing businesses from developing a consolidated customer view.

### 2.2 Customer Identity Fragmentation
Website identifiers and CRM customer identifiers are different, making customer-level analysis difficult.

### 2.3 Limited Customer Understanding
Businesses need better methods to analyze customer purchasing behaviour, segment customers and estimate customer value.

### 2.4 Marketing Attribution Challenges
Customers interact with multiple marketing touchpoints before conversion. Relying on a single attribution approach can provide an incomplete understanding of marketing performance.

### 2.5 Campaign Performance Measurement
Businesses need to evaluate advertising expenditure, engagement, conversion efficiency and attributed revenue to support marketing decisions.

---

# 3. Project Objectives

The primary objectives were:

1. Integrate website analytics, CRM and advertising datasets.
2. Implement customer identity resolution.
3. Develop a consolidated Customer 360 analytical foundation.
4. Build customer segmentation using RFM analysis.
5. Develop customer lifetime value analysis.
6. Implement First-Touch, Last-Touch, Linear and Time-Decay attribution.
7. Analyze campaign and channel efficiency.
8. Calculate relevant marketing KPIs, including CPA and ROAS where supported by available data.
9. Develop interactive Tableau dashboards.
10. Provide evidence-based marketing measurement and budget recommendations.

---

# 4. Technology Stack

| Technology | Purpose |
|---|---|
| Google Analytics 4 | Website analytics source |
| Google BigQuery | Cloud data warehouse |
| SQL | Data integration, transformation and analysis |
| dbt Core | Modular data transformation and testing |
| Python | Data preparation and analytical support |
| Tableau | Interactive dashboards and reporting |
| Git | Version control |
| GitHub | Source code and documentation repository |

---

# 5. Data Sources

The project uses three primary categories of data.

### 5.1 Google Analytics 4

Source:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce`

The public GA4 sample dataset provides event-level website and e-commerce information.

It is used for session analysis, user behaviour, traffic-source analysis and transaction-related modelling.

### 5.2 Synthetic CRM Data

Contains customer records and customer-related attributes used for customer profile development.

Recorded volume: 5,000 customer records.

### 5.3 Synthetic Identity Mapping Data

Provides the mapping between website-side identifiers and CRM-side customer identifiers.

Recorded volume: 3,500 mapping records.

### 5.4 Synthetic Advertising Data

Contains campaign-level advertising information, including:

- Campaign identifiers
- Impressions
- Clicks
- Advertising expenditure
- Simulated conversions

Recorded volume: 736 records across 8 campaigns.

**Data transparency:** CRM, identity mapping and advertising inputs are synthetic. Advertising conversions are simulated. The GA4 source is Google's public obfuscated sample dataset, not a live organizational GA4 property.

---

# 6. Data Architecture

The project follows a layered analytical architecture.

### Layer 1 – Data Sources

- GA4 public sample data
- Synthetic CRM records
- Synthetic identity mapping
- Synthetic advertising data

### Layer 2 – BigQuery Raw Dataset

Dataset:

`customer_360_raw`

Contains source-oriented tables:

- `ga4_events`
- `ga4_sessions`
- `crm_customers`
- `identity_mapping`

### Layer 3 – Curated Dataset

Dataset:

`customer_360_curated`

Important output:

- `identity_resolved_sessions`

This layer contains the integrated identity-resolution output.

### Layer 4 – dbt Transformation

Project:

`customer_360`

Target dataset:

`customer_360_dbt_dev`

Transformation architecture:

- Staging
- Intermediate
- Marts

### Layer 5 – Analytical Models

Includes:

- Fact Sessions
- Fact Orders
- Customer Profile
- Customer Segmentation
- RFM Analysis
- Customer Lifetime Value
- Marketing Attribution
- Campaign Efficiency
- Channel ROI

### Layer 6 – Visualization

Tableau dashboards provide business-facing analytical insights and reporting.

---

# 7. Customer 360 Implementation

Customer 360 integrates website activity with CRM customer information.

The identity-resolution process connects website-side identifiers to CRM identifiers using the supplied identity mapping.

The implementation preserves unmatched website records rather than discarding them.

Identity statuses distinguish:

- IDENTIFIED
- UNIDENTIFIED

Recorded implementation results:

| Metric | Result |
|---|---:|
| GA4 Sessions | 360,129 |
| Identified Customers | 10,246 |
| Unidentified Sessions | 349,883 |
| Synthetic CRM Records | 5,000 |
| Identity Mapping Records | 3,500 |

The resulting customer analytics foundation supports customer profiling, segmentation and purchasing behaviour analysis.

---

# 8. dbt Transformation Models

The dbt project follows a modular architecture.

### Staging Layer

Key models:

- `stg_ga4_sessions`
- `stg_ga4_events`
- `stg_crm_customers`
- `stg_identity_mapping`
- `stg_identity_resolved_sessions`

### Intermediate Layer

Contains reusable transformation logic for downstream analytical models.

### Marts Layer

Core analytical models:

- `fct_sessions`
- `fct_orders`
- `dim_customer_profile`

Additional analytical models support customer segmentation, RFM, CLV, attribution and marketing efficiency.

---

# 9. Customer Analytics

### RFM Analysis

Customer segmentation is developed using:

- Recency
- Frequency
- Monetary Value

The analysis helps identify different customer groups according to purchasing behaviour.

### Customer Lifetime Value

CLV analysis provides an analytical estimate of customer value based on the implemented model assumptions and available historical data.

These analyses support customer profiling and customer-focused business decisions.

---

# 10. Marketing Attribution

Four attribution methodologies were implemented.

| Attribution Model | Methodology |
|---|---|
| First-Touch | Assigns credit to the first eligible touchpoint |
| Last-Touch | Assigns credit to the final eligible touchpoint |
| Linear | Distributes credit equally across eligible touchpoints |
| Time-Decay | Gives relatively greater credit to touchpoints closer to conversion |

These models provide alternative perspectives on conversion-credit distribution.

Recorded attribution validation:

- 4,452 attribution credits/records.
- $307,868 attributed revenue per attribution model.

The attribution models represent alternative allocation methodologies applied to the same underlying conversion/revenue scope. Their revenue figures should not be added together.

---

# 11. Campaign Performance and Marketing Efficiency

Campaign analytics were developed using synthetic advertising inputs.

Recorded results:

| Metric | Result |
|---|---:|
| Campaigns | 8 |
| Advertising Records | 736 |
| Impressions | 9,246,272 |
| Clicks | 186,706 |
| Simulated Conversions | 6,231 |
| Advertising Spend | $126,552.23 |
| Simulated CPA | $20.31 |

Analytical models include:

- `fct_campaign_efficiency`
- `fct_channel_roi`

The channel ROI implementation was validated using 10 validation records.

Validation results:

- 10 checks passed.
- 0 failures.
- $0.00 advertising spend reconciliation difference.

### Campaign Mapping Limitation

Only Google/CPC was mapped in the final recorded implementation.

Six source/medium combinations remained unmapped.

Google Brand and Generic campaign performance could not be reliably separated.

Therefore, complete campaign-level ROAS, CPA and profit-based ROI cannot be claimed across all campaigns.

Revenue-based ROAS must not be interpreted as profit ROI or incremental ROI.

---

# 12. Tableau Dashboards

Four Tableau dashboards were completed.

### Dashboard 01 – Customer 360 Executive Overview

Provides consolidated customer analytics and customer-level business insights.

### Dashboard 02 – Marketing Attribution & Conversion Insights

Compares the four attribution methodologies and presents conversion-credit insights.

### Dashboard 03 – Campaign Performance

Displays campaign activity, advertising expenditure, impressions, clicks and available engagement and conversion metrics.

### Dashboard 04 – Marketing Efficiency & Budget Recommendations

Combines available expenditure, attribution, campaign mapping coverage and efficiency metrics to support evidence-based marketing recommendations.

The dashboards help identify measurement gaps and opportunities for further campaign investigation.

---

# 13. Testing and Validation

Recorded project validation includes:

| Test Area | Result |
|---|---|
| dbt Schema Tests | 21 passed |
| dbt Singular Tests | 5 passed |
| Final Data Quality Query | 0 exception rows |
| Attribution Reconciliation | $307,868 per model |
| Attribution Output | 4,452 credits/records |
| Channel ROI Validation | 10 checks passed |
| Spend Reconciliation Difference | $0.00 |

These results represent recorded project execution evidence. They should be interpreted within the scope of the synthetic and public sample datasets.

---

# 14. Key Business Outcomes

The project established an analytical foundation for:

- Integrating fragmented customer data.
- Resolving customer identities where mappings exist.
- Understanding customer behaviour.
- Segmenting customers through RFM analysis.
- Evaluating customer value.
- Comparing multiple marketing attribution approaches.
- Monitoring campaign performance.
- Evaluating available advertising efficiency metrics.
- Identifying campaign measurement gaps.
- Supporting more informed marketing decisions.

---

# 15. Project Limitations

The following limitations are documented:

1. GA4 data comes from a public obfuscated sample dataset.
2. CRM and identity mapping records are synthetic.
3. Advertising inputs and conversion counts are synthetic.
4. Identity resolution depends on the supplied mapping records.
5. Six source/medium combinations remained unmapped.
6. Google Brand and Generic campaign performance could not be reliably separated.
7. Complete campaign-level ROAS and CPA are not verified.
8. Profit-based ROI and incremental ROI were not established.
9. CLV and attribution outputs depend on implemented analytical assumptions.

These limitations must be considered when interpreting results or making business recommendations.

---

# 16. Repository Structure

```text
Customer-360-Marketing-Attribution/
│
├── README.md
│
├── BigQuery/
│
├── dbt/
│   └── customer_360/
│
├── Tableau/
│   └── Dashboard_Screenshots/
│
├── Documentation/
│   ├── architecture.md
│   ├── data dictionary.md
│   ├── decisions.md
│   ├── definitions.md
│   ├── methodology.md
│   ├── project journal.md
│   ├── results.md
│   ├── setup guide.md
│   └── testing.md
│
├── Final Presentation/
```

---

# 17. Final Presentation and Working Demonstration

The project includes two recorded submission deliverables.

### Final Presentation

The final presentation covers:

- Business problem
- Project objectives
- Solution architecture
- Technology stack
- Customer 360 implementation
- Marketing attribution
- Campaign performance
- Tableau dashboards
- Challenges and limitations
- Individual reflection
- Future scope

Folder: `Final Presentation`

Google Drive video link:

**[(https://drive.google.com/drive/folders/1NqOojnF4_8HDE4aNvNmXU2YxDmdKSVYP?usp=drive_link)]**

### Working Demonstration

The working demonstration presents the implemented solution through:

- BigQuery
- Customer identity resolution
- dbt transformations
- Customer 360 dashboard
- Marketing attribution dashboard
- Campaign performance dashboard
- Marketing efficiency dashboard

Folder: `Working Demo`

Google Drive video link:

**[(https://drive.google.com/drive/folders/1NqOojnF4_8HDE4aNvNmXU2YxDmdKSVYP?usp=drive_link)]**

The recorded videos are hosted on Google Drive. The README provides access links to these recordings.

---

# 18. Setup Instructions

1. Clone the GitHub repository.
2. Configure access to Google BigQuery.
3. Ensure the required BigQuery datasets and source tables are available.
4. Configure Python and dbt Core.
5. Configure the dbt BigQuery adapter and local credentials.
6. Execute the dbt models.
7. Run dbt tests.
8. Generate dbt documentation.
9. Connect Tableau to the relevant BigQuery analytical models.
10. Open the Tableau workbook and refresh the available data.

Refer to `Documentation/setup guide.md` for detailed instructions.

Credentials and service-account keys must not be committed to the repository.

---

# 19. Project Documentation

Detailed technical documentation is available in the `Documentation/` folder.

| Document | Description |
|---|---|
| architecture.md | End-to-end system architecture |
| data dictionary.md | Data sources, tables and analytical fields |
| decisions.md | Important implementation decisions |
| definitions.md | Business and technical terminology |
| methodology.md | Data integration and analytical methodology |
| project journal.md | Project implementation history |
| results.md | Final analytical results |
| setup guide.md | Environment and reproduction instructions |
| testing.md | Validation procedures and results |

---

# 20. Conclusion

Customer 360 & Marketing Attribution demonstrates how data integration, customer identity resolution, analytical modelling and marketing attribution can be combined into an integrated business intelligence solution.

Through Google BigQuery, dbt Core and Tableau, the project establishes a structured analytical foundation for understanding customers, evaluating marketing performance and identifying opportunities for improved measurement.

The project also demonstrates the importance of data quality, validation, transparent assumptions and responsible interpretation of analytical results.

**Project Status: Completed**

**Final Submission: GitHub Repository + Google Drive Demonstrations + Final Presentation**

---