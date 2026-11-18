# Business and Analytical Definitions
## Customer 360 & Marketing Attribution Programme

## 1. Purpose

This document defines the key business terms, metrics, and analytical concepts used throughout the project.

## 2. Customer Analytics Definitions

### Customer 360

A unified analytical view of a customer combining available customer profile attributes, website activity, purchase behaviour, RFM metrics, customer segments, and historical value information.

### Recency

The number of days between the customer's most recent purchase date and the reference date used in the RFM analysis.

Lower recency generally indicates more recent purchasing activity.

### Frequency

The number of distinct purchase transactions attributed to a customer within the analysis period.

### Monetary Value

The total purchase revenue associated with a customer during the analysis period.

### RFM Analysis

A customer segmentation approach based on three dimensions:

- Recency.
- Frequency.
- Monetary value.

Customers receive scores based on their relative purchasing behaviour.

### RFM Score

A numerical classification assigned to a customer for each RFM dimension.

The final score and segment depend on the scoring rules implemented in the dbt models.

### Customer Segment

A customer classification derived from RFM behaviour.

Examples in this project include:

- Champions.
- Loyal Customers.
- Potential Loyalists.
- Recent Customers.
- Promising Customers.
- Customers Needing Attention.
- At Risk.
- Cannot Lose Them.
- Hibernating.
- Lost.
- No Purchase.

These labels represent rule-based classifications, not verified future customer behaviour.

### Customer Lifetime Value (CLV)

The historical revenue contribution associated with a customer over the observed dataset period.

**Important:** The project's current CLV is historical and descriptive, not a predictive lifetime revenue model.

### Observed Purchase Span

The difference between a customer's first and last observed purchase dates.

It does not represent the full customer relationship duration.

## 3. Marketing Attribution Definitions

### Conversion

A completed ecommerce purchase transaction represented by the GA4 purchase data.

### Customer Journey

The sequence of eligible website sessions or marketing touchpoints preceding a purchase.

### Touchpoint

An observed marketing or traffic interaction associated with a session in a conversion journey.

### Attribution Credit

The share of a purchase assigned to an eligible touchpoint under a particular attribution model.

For each transaction, the total attribution credit should equal 1.

### Attributed Revenue

The portion of purchase revenue assigned to a touchpoint or channel under an attribution model.

For each attribution model, total attributed revenue should reconcile to the underlying purchase revenue.

### First-Touch Attribution

Assigns 100% of a transaction's attribution credit to the earliest eligible touchpoint.

### Last-Touch Attribution

Assigns 100% of a transaction's attribution credit to the latest eligible touchpoint.

### Linear Attribution

Distributes attribution credit equally across all eligible touchpoints.

For a transaction with N eligible touchpoints:

`Credit per touchpoint = 1 / N`

### Time-Decay Attribution

Assigns greater initial weight to touchpoints closer to the conversion.

The project uses the following weighting function:

`Weight = 0.5 ^ (Seconds Before Conversion / Half-Life Seconds)`

The half-life is seven days.

Weights are normalized within each transaction so that total transaction credit equals 1.

The seven-day half-life is a modelling assumption, not an empirically estimated parameter.

## 4. Advertising Definitions

### Impressions

The number of times an advertisement is recorded as displayed in the synthetic advertising dataset.

### Clicks

The number of recorded advertising interactions in the synthetic dataset.

### Click-Through Rate (CTR)

`CTR = Clicks / Impressions * 100`

Measures the percentage of impressions that resulted in clicks.

### Cost Per Click (CPC)

`CPC = Advertising Spend / Clicks`

Measures average advertising expenditure per click.

### Simulated Conversion Rate

`Simulated Conversion Rate = Simulated Conversions / Clicks * 100`

This metric uses the synthetic advertising conversion field.

### Cost Per Simulated Conversion

`Cost Per Simulated Conversion = Advertising Spend / Simulated Conversions`

This metric is calculated using synthetic conversions. It must not be labelled as verified GA4 purchase CPA.

### Cost Per Acquisition (CPA)

`CPA = Advertising Spend / Acquisitions`

For this project, an actual campaign CPA requires a defensible definition of acquisition and verified mapping between campaign expenditure and the corresponding conversions.

### Return on Ad Spend (ROAS)

`ROAS = Attributed Revenue / Advertising Spend`

ROAS is meaningful only when the revenue and spend are associated with the same campaign or channel, currency, and compatible reporting period.

### Return on Investment (ROI)

`ROI = (Attributed Revenue - Advertising Spend) / Advertising Spend * 100`

ROI requires a reliable relationship between the expenditure and the revenue being evaluated.

## 5. Data Quality Definitions

### Unique Record

A record that is distinct according to the primary key or declared model grain.

### Referential Integrity

The condition where a foreign-key reference corresponds to an existing record in the related dataset.

### Reconciliation

A comparison of totals across related models to confirm that the transformation has not unexpectedly changed the underlying population or financial values.

### Null Validation

A check for missing values in fields that are expected to be populated.

### Grain

The level of detail represented by one row in a table.

Examples:

- One row per customer.
- One row per order.
- One row per session.
- One row per transaction-touchpoint relationship.

## 6. Important Interpretation Rules

1. Synthetic advertising conversions are not GA4 purchase transactions.
2. Historical CLV is not predictive CLV.
3. Attribution models are alternative ways of allocating the same purchase revenue.
4. Attribution credit and attributed revenue must reconcile at the transaction and model levels.
5. A source/medium match does not automatically prove campaign-ID mapping.
6. Campaign ROI and actual CPA must not be calculated from unrelated spend and revenue datasets.
7. Unidentified orders must not be assigned to CRM customers without evidence.
8. Synthetic identity mapping validates implementation consistency, not real-world identity accuracy.

# Phase 6 – Marketing Efficiency Definitions

### Advertising Metrics

**Click-Through Rate (CTR)**

Percentage of advertising impressions that resulted in clicks.

Formula:

Clicks / Impressions × 100

**Cost Per Click (CPC)**

Average advertising expenditure per click.

Formula:

Advertising Spend / Clicks

**Simulated Conversion Rate**

Percentage of advertising clicks that resulted in simulated conversions.

Formula:

Simulated Conversions / Clicks × 100

**Cost Per Simulated Conversion**

Average advertising expenditure per simulated conversion.

Formula:

Advertising Spend / Simulated Conversions

### Attribution-Based Metrics

**Attributed Revenue**

Revenue allocated to a marketing touchpoint or channel by an attribution model.

**Attribution Credit**

The fractional or full conversion credit assigned to a marketing touchpoint under an attribution model.

**Attributed Cost Per Acquisition (CPA)**

Advertising expenditure divided by attributed conversion credit.

Formula:

Advertising Spend / Attribution Credit

This project uses attribution credit for Linear and Time Decay calculations, so CPA can be based on fractional conversion credit.

**Return on Advertising Spend (ROAS)**

Ratio of attributed revenue to advertising expenditure.

Formula:

Attributed Revenue / Advertising Spend

**Revenue-Based Attributed Return**

Percentage difference between attributed revenue and advertising expenditure, relative to advertising expenditure.

Formula:

((Attributed Revenue - Advertising Spend) / Advertising Spend) × 100

This is a revenue-based efficiency measure, not verified profit-based ROI.

### Attribution Models

**First-Touch Attribution:** Assigns conversion credit to the first marketing touchpoint.

**Last-Touch Attribution:** Assigns conversion credit to the final marketing touchpoint.

**Linear Attribution:** Distributes conversion credit equally across eligible touchpoints.

**Time-Decay Attribution:** Assigns greater conversion credit to more recent touchpoints according to the configured seven-day half-life assumption.

### Mapping and Measurement Terms

**Campaign-Level Mapping:** A verified relationship connecting an advertising campaign identifier to GA4 campaign-level attributed revenue.

**Channel-Level Mapping:** A relationship connecting advertising expenditure and GA4 attributed revenue using matching source and medium values.

**Simulated Conversion:** A conversion generated within the synthetic advertising dataset. It is not necessarily an actual GA4 purchase.

**Incremental ROI:** Return attributable to marketing activity beyond what would have happened without that activity. Establishing it generally requires an appropriate incremental measurement design.