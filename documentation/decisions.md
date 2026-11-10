# Technical Decision Log
## Customer 360 & Marketing Attribution Programme

This document records important technical and architectural decisions made throughout the project.

---

## Decision 001 – Selection of GA4 Public Ecommerce Dataset

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:** Use Google's publicly available GA4 ecommerce sample dataset hosted in BigQuery as the primary website behavioural data source.

**Source:** `bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

**Reasoning:** It provides ecommerce event data, customer-related identifiers, session information, traffic source information and purchase events for behavioural and marketing analysis.

---

## Decision 002 – Use Synthetic CRM Customer Data

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:** Generate synthetic CRM customer records using Python rather than relying on real customer information.

**Dataset:** `synthetic_crm_customers.csv`

**Reasoning:** Synthetic records avoid using real customer information and provide controlled customer attributes and identifiers for analytical development and identity-resolution testing.

---

## Decision 003 – Generate Synthetic Advertising Spend Data

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:** Generate synthetic advertising spend data using Python.

**Dataset:** `synthetic_ad_spend.csv`

**Reasoning:** The GA4 sample does not provide a complete advertising cost dataset for the planned marketing analysis. Synthetic campaign spending data will support later campaign performance, CPA and ROAS analysis.

---

## Decision 004 – Create a Separate Identity Mapping Dataset

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:** Maintain a separate synthetic identity mapping dataset.

**Dataset:** `identity_mapping.csv`

**Reasoning:** Website identifiers and CRM identifiers differ across systems. A dedicated mapping dataset provides a controlled bridge for testing cross-platform identity resolution.

**Important qualification:** The mappings are synthetic. A successful match validates the implemented logic against the generated mapping data; it does not establish that the identities represent real people or demonstrate production-grade identity accuracy.

---

## Decision 005 – Use BigQuery as the Central Data Warehouse

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:** Use Google BigQuery as the central warehouse for integrating GA4, CRM, advertising and identity mapping data.

**Dataset organization:** `customer_360_raw` for source data and `customer_360_curated` for the Phase 2 integrated identity-resolution output. Staging and analytics datasets remain part of the planned downstream architecture.

---

## Decision 006 – Maintain Synthetic and Raw Data Separately

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:** Store generated source CSV files under `data/raw/` and reserve `data/processed/` for future transformed local datasets.

**Reasoning:** Separating original inputs from transformed outputs improves traceability and reproducibility.

---

## Decision 007 – Maintain Version Control and Technical Documentation

**Date:** 10 November 2026  
**Status:** Accepted

**Decision:** Use Git and GitHub for version control and maintain separate project documentation.

**Reasoning:** This provides a traceable record of implementation progress, architecture and technical decisions.

---

## Decision 008 – Preserve Every GA4 Session During Identity Resolution

**Status:** Accepted and Implemented

**Decision:** Use LEFT JOIN-based identity enrichment so that every source GA4 session remains in the final identity-resolution output, whether or not a mapping is found.

**Output:** `customer_360_curated.identity_resolved_sessions`

**Reasoning:** Dropping unmatched sessions would remove behavioural data from subsequent customer journey analysis. Retaining them and assigning an explicit identity status preserves the complete session population while distinguishing identified from unidentified sessions.

---

## Decision 009 – Treat Identity Mapping as Synthetic Test Data

**Status:** Accepted

**Decision:** Interpret identity-resolution matches as matches against the project's generated synthetic mapping dataset, not as verified real-world identity links.

**Reasoning:** The identity mapping was deliberately generated for this project. Validation can confirm referential consistency and correct application of the mapping rules, but cannot establish real-world identity accuracy.

**Reporting implication:** The identified-session count and match rate must be labelled as results from a synthetic test dataset.

---

## Decision Review

Phase 2 implemented the identity-resolution design and created the curated session-level output. Further decisions will be recorded as dbt modelling, customer analytics, attribution and dashboard development progress.