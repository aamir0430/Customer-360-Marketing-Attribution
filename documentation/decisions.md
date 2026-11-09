# Technical Decision Log
## Customer 360 & Marketing Attribution Programme

This document records important technical and architectural decisions made throughout the project.

---

## Decision 001 – Selection of GA4 Public Ecommerce Dataset

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:**

Use Google's publicly available GA4 ecommerce sample dataset hosted in BigQuery as the primary website and app behavioural data source.

**Source:**

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

**Reasoning:**

- Provides realistic ecommerce event data.
- Contains customer-related identifiers and session information.
- Includes traffic source and campaign information.
- Contains ecommerce purchase events.
- Allows analysis of customer behaviour and marketing interactions.

**Expected Benefits:**

Provides the behavioural foundation required for customer journey analysis, identity resolution, and marketing attribution.

---

## Decision 002 – Use Synthetic CRM Customer Data

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:**

Generate synthetic CRM customer records using Python rather than relying on real customer information.

**Dataset:**

`synthetic_crm_customers.csv`

**Reasoning:**

- Avoids exposing personally identifiable customer information.
- Provides control over customer attributes and identifiers.
- Allows the creation of realistic customer records for analytical development.
- Supports testing of identity resolution logic.

**Expected Benefits:**

Provides a simulated CRM source for building unified customer profiles.

---

## Decision 003 – Generate Synthetic Advertising Spend Data

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:**

Generate synthetic advertising spend data using Python.

**Dataset:**

`synthetic_ad_spend.csv`

**Reasoning:**

The GA4 sample dataset does not provide a complete advertising cost dataset covering all the requirements of the planned marketing attribution analysis.

Synthetic advertising data will provide campaign-level spending information for future analysis.

**Expected Benefits:**

Enables future calculations of:

- Advertising ROI.
- Cost per acquisition (CPA).
- Campaign performance.
- Marketing channel efficiency.

---

## Decision 004 – Create a Separate Identity Mapping Dataset

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:**

Maintain a separate synthetic identity mapping dataset.

**Dataset:**

`identity_mapping.csv`

**Reasoning:**

Website identifiers and CRM customer identifiers may differ across platforms.

A dedicated mapping dataset provides a structured foundation for connecting these identities.

**Expected Benefits:**

- Connect website sessions with CRM customers.
- Support cross-platform identity resolution.
- Build unified customer profiles.
- Enable customer journey analysis.

The mapping dataset will be used as an input to the identity resolution process rather than treated as the final identity resolution output.

---

## Decision 005 – Use BigQuery as the Central Data Warehouse

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:**

Use Google BigQuery as the central data warehouse for integrating the GA4, CRM, advertising, and identity mapping datasets.

**Reasoning:**

- GA4 sample data is already hosted in BigQuery.
- Supports SQL-based data analysis and transformations.
- Provides a suitable environment for managing multiple datasets.
- Integrates with dbt and other analytical tools.

**Planned Dataset Organization:**

- `customer_360_raw`
- `customer_360_staging`
- `customer_360_analytics`

These datasets will separate source data, transformed data, and analytical outputs.

---

## Decision 006 – Maintain Synthetic and Raw Data Separately

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:**

Organize source CSV files under `data/raw/` and reserve `data/processed/` for future transformed datasets.

**Reasoning:**

Maintaining separate raw and processed data locations improves project organization and traceability.

Original generated datasets will remain separate from future cleaned and transformed outputs.

---

## Decision 007 – Maintain Version Control and Technical Documentation

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:**

Use Git and GitHub for version control and maintain separate project documentation.

**Documentation Files:**

- `project_journal.md`
- `decisions.md`
- `architecture.md`
- `data_dictionary.md`
- `methodology.md`
- `testing.md`

**Reasoning:**

Maintaining documentation throughout development improves project traceability, reproducibility, and maintainability.

It also provides a clear record of implementation progress and technical decisions.

---

## Decision Review

The above decisions establish the initial data architecture and development approach.

Additional decisions will be documented as the project progresses through identity resolution, data modelling, customer analytics, marketing attribution, and dashboard development.