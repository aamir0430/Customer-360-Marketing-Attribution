# Technical Decision Log
## Customer 360 & Marketing Attribution Programme

This document records key technical and architectural decisions made during the project.

---

## Decision 001 – Use the GA4 Public Ecommerce Sample

**Status:** Accepted

**Decision:** Use Google's public GA4 ecommerce sample hosted in BigQuery as the primary website behavioural data source.

**Source:** `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

**Reasoning:** It provides ecommerce event, session, traffic-source, and purchase-related data for behavioural analysis.

---

## Decision 002 – Generate Synthetic CRM Data

**Status:** Accepted and Implemented

**Decision:** Generate synthetic CRM customer records using Python.

**Dataset:** `synthetic_crm_customers.csv`

**Reasoning:** Synthetic records avoid using real customer information and provide controlled inputs for identity resolution and customer analytics.

---

## Decision 003 – Generate Synthetic Advertising Spend Data

**Status:** Accepted and Implemented

**Decision:** Generate synthetic advertising campaign and spend data using Python.

**Dataset:** `synthetic_ad_spend.csv`

**Reasoning:** Advertising expenditure is required for planned campaign-performance and ROI analysis.

---

## Decision 004 – Maintain a Separate Synthetic Identity Mapping Dataset

**Status:** Accepted and Implemented

**Decision:** Use a dedicated synthetic mapping dataset to bridge website-side identifiers and CRM customer identifiers.

**Dataset:** `identity_mapping.csv`

**Reasoning:** The identifiers differ across platforms. A separate mapping bridge allows controlled development and validation of identity-resolution logic.

**Qualification:** Matches validate the implemented logic against generated data; they do not establish real-world identity accuracy.

---

## Decision 005 – Use BigQuery as the Central Warehouse

**Status:** Accepted and Implemented

**Decision:** Use Google BigQuery for source data, curated identity-resolution outputs, and dbt development models.

**Datasets:**
- `customer_360_raw`
- `customer_360_curated`
- `customer_360_dbt_dev`

**Reasoning:** A cloud warehouse provides a common environment for source integration, transformation, and analytical modelling.

---

## Decision 006 – Separate Raw Inputs from Processed Data

**Status:** Accepted

**Decision:** Keep original generated source files under `data/raw/` and reserve `data/processed/` for transformed local outputs.

**Reasoning:** This separation improves traceability and reproducibility.

---

## Decision 007 – Use Git and Maintain Project Documentation

**Status:** Accepted and Implemented

**Decision:** Use Git/GitHub for version control and maintain separate technical documentation.

**Reasoning:** This provides a traceable history of implementation, decisions, architecture, and validation.

---

## Decision 008 – Preserve Every GA4 Session During Identity Resolution

**Status:** Accepted and Implemented

**Decision:** Use LEFT JOIN-based identity enrichment so every source GA4 session remains in the final output, whether or not a mapping is found.

**Output:** `customer_360_curated.identity_resolved_sessions`

**Reasoning:** Dropping unmatched sessions would remove behavioural data. Retaining them with an explicit identity status preserves the session population.

---

## Decision 009 – Treat Identity Mapping as Synthetic Test Data

**Status:** Accepted

**Decision:** Interpret identity matches as matches against the generated synthetic mapping dataset, not as verified real-world identity links.

**Reasoning:** Validation can confirm referential consistency and correct application of the generated mapping rules, but cannot establish real-world identity accuracy.

---

## Decision 010 – Use dbt Core for the Transformation Layer

**Status:** Accepted and Implemented in Phase 3

**Decision:** Use dbt Core with BigQuery to organize source-aligned staging transformations and reusable analytical models.

**Implementation:**
- dbt project: `customer_360`.
- Configure upstream sources for GA4 sessions, GA4 events, CRM customers, identity mapping, and curated identity-resolved sessions.
- Materialize staging models as views.
- Use ephemeral materialization for intermediate transformations where configured.
- Build `fct_sessions`, `fct_orders`, and `dim_customer_profile`.
- Use `customer_360_dbt_dev` as the development target dataset.

**Reasoning:** Separating source cleanup from analytical outputs improves model organization, reuse, lineage, and maintainability. It creates a consistent foundation for downstream customer analytics and marketing attribution.

**Validation:** dbt diagnostics and parsing completed successfully, documentation was generated, and the three core marts were validated in BigQuery.

**Evidence boundary:** Exact automated dbt test/build totals and individual mart row counts should be added only from saved command output or query evidence.

---

## Decision Review

Phases 1–3 established the synthetic data foundation, BigQuery identity-resolution output, and dbt staging/core marts. New decisions will be recorded as customer analytics, attribution, and dashboard development progress.

---

## Decision 011 – Use Four Alternative Attribution Models

**Status:** Accepted and Implemented

**Decision:** Implement first-touch, last-touch, linear, and time-decay attribution models.

**Models:**

- `fct_first_last_touch_attribution`
- `fct_linear_attribution`
- `fct_time_decay_attribution`
- `fct_attribution_comparison`

**Reasoning:** Comparing different attribution approaches demonstrates how the allocation of purchase revenue changes depending on the attribution methodology.

**Validation:** All four models reconcile to 4,452 transactions, 4,452 total attribution credit, and approximately $307,868 attributed revenue.

---

## Decision 012 – Use a Seven-Day Half-Life for Time-Decay Attribution

**Status:** Accepted and Implemented

**Decision:** Use a seven-day half-life for the time-decay attribution weighting formula.

**Formula:**

`Weight = 0.5 ^ (Seconds Before Conversion / (7 * 24 * 60 * 60))`

**Reasoning:** This provides a consistent recency-weighting assumption for comparing touchpoints.

**Qualification:** The seven-day half-life is a modelling assumption and was not empirically estimated.

---

## Decision 013 – Keep Synthetic Advertising and GA4 Attribution Separate

**Status:** Accepted and Implemented

**Decision:** Do not force a campaign-level join between synthetic advertising spend and GA4 attributed purchase revenue without verified campaign mapping.

**Reasoning:** The source investigation did not establish a reliable campaign-ID relationship.

**Implementation:** `fct_marketing_performance_reporting` retains separate advertising and GA4 attribution records.

**Qualification:** Synthetic cost per simulated conversion is not equivalent to actual CPA based on GA4 purchases.

---

## Decision 014 – Validate Attribution Credit and Revenue Reconciliation

**Status:** Accepted and Implemented

**Decision:** Validate that each attribution model preserves the total transaction credit and underlying purchase revenue.

**Reasoning:** Attribution models redistribute credit; they must not create or remove purchase revenue.

**Validation:** All four models reconciled to the same transaction population and total revenue.

---

## Decision 015 – Report Campaign ROI and Actual CPA Only When Mapping Is Defensible

**Status:** Accepted

**Decision:** Campaign ROI, ROAS, and actual CPA will only be calculated when campaign expenditure can be reliably connected to the corresponding purchase conversions and revenue.

**Reasoning:** Joining unrelated synthetic advertising metrics and GA4 purchase revenue would produce misleading business results.

**Next step:** Investigate campaign mapping during Phase 6. If mapping remains unavailable, report the limitation explicitly and retain synthetic advertising efficiency metrics separately.

# Phase 6 – Campaign ROI and CPA Decisions

## Decision 1: Reuse Existing Campaign Performance Models

**Decision:** Reuse the Phase 5 `fct_campaign_performance_summary` model as the advertising performance source for Phase 6.

**Reason:** Avoid duplicating existing advertising aggregation and calculation logic.

## Decision 2: Separate Campaign and Channel Efficiency

**Decision:** Maintain two separate dbt models:

- `fct_campaign_efficiency`
- `fct_channel_roi`

**Reason:** Campaign-level advertising metrics and channel-level attributed revenue have different levels of measurement reliability.

## Decision 3: Aggregate Advertising Spend by Source and Medium

**Decision:** Aggregate campaign expenditure by source and medium before joining with GA4 attribution.

**Reason:** Multiple advertising campaigns can share the same source and medium. Aggregating expenditure prevents duplicated advertising costs when joining attribution results.

## Decision 4: Preserve Attribution Models Separately

**Decision:** Maintain First Touch, Last Touch, Linear and Time Decay as separate attribution results.

**Reason:** These models represent alternative allocations of the same conversion revenue. Their revenue values must not be combined.

## Decision 5: Do Not Force Unverified Campaign Mappings

**Decision:** Do not assign GA4 attributed revenue to individual advertising campaign IDs without a verified relationship.

**Reason:** Only Google CPC had an identified source/medium match. GA4 did not provide verified campaign-level distinctions between the two Google CPC advertising campaigns.

## Decision 6: Separate Simulated and Actual Conversions

**Decision:** Keep synthetic advertising conversions separate from GA4 purchase transactions.

**Reason:** Simulated conversions cannot be assumed to represent actual purchases.

## Decision 7: Distinguish Revenue-Based Return from Profit-Based ROI

**Decision:** Label the calculated return as revenue-based attributed return.

**Reason:** The available data does not establish incremental revenue, profit margin or actual campaign profitability. Therefore, the calculation should not be presented as verified profit-based ROI.

## Decision 8: Retain Unmapped Channel Limitations

**Decision:** Keep unmatched advertising source/medium combinations in the campaign efficiency model and explicitly identify their attribution mapping status.

**Reason:** Excluding unmatched campaigns would hide advertising expenditure and produce an incomplete view of campaign performance.

## Final Decision

Phase 6 provides campaign-level advertising efficiency and mapped channel-level attribution-based marketing efficiency.

Individual campaign profitability and true incremental ROI remain outside the verified measurement scope until reliable campaign-level revenue and incremental performance data become available.