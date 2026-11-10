# Project Journal
## Customer 360 & Marketing Attribution Programme

---

## Phase 1 – Data Source Setup and Dataset Generation

**Status:** Completed

### Objective

Establish the initial project data sources and generate the synthetic datasets required for the Customer 360 and Marketing Attribution platform.

### Work Completed

- Selected Google's public GA4 ecommerce sample dataset in BigQuery: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`.
- Inspected GA4 event data, identifiers, session information, traffic sources and ecommerce purchase information.
- Generated the synthetic CRM customer dataset: `synthetic_crm_customers.csv`.
- Generated the synthetic advertising spend dataset: `synthetic_ad_spend.csv`.
- Generated the synthetic identity mapping dataset: `identity_mapping.csv`.

### Phase 1 Deliverables

The three synthetic CSV datasets were generated and organized under `data/raw/`. The GA4 public ecommerce sample was selected as the behavioural data source.

**Phase 1 status: Completed.**

---

## Phase 2 – Build an Identity Resolution Step That Links Sessions and Customers

**Status:** Completed

### Objective

Prepare the source data and build a usable BigQuery dataset that links GA4 sessions to CRM customer profiles wherever a corresponding synthetic identity mapping exists.

### Step 2.1 – Prepare and Load Data into BigQuery

- Prepared and loaded the required source data into the `customer_360_raw` dataset.
- Used the source tables `ga4_sessions`, `crm_customers` and `identity_mapping`.
- Verified that the three expected raw tables were present and checked their row counts.

### Step 2.2 – Inspect and Validate Identity Mapping

- Examined the synthetic identity mapping data.
- Reviewed the identifiers and mapping fields required to connect GA4 sessions to CRM records.
- Performed mapping quality checks before using the mapping in joins.

### Step 2.3 – Preview the Identity Resolution Join

- Previewed the joins between GA4 sessions, identity mapping and CRM customer records.
- Checked the relationship between session identifiers, synthetic user identifiers and CRM customer identifiers.
- Used LEFT JOIN logic to retain the complete GA4 session population.

### Step 2.4 – Validate the Identity Resolution Output

- Checked session coverage and uniqueness.
- Checked identified and unidentified session counts.
- Checked that identified mappings resolve to CRM customer records.
- Checked synthetic identifier consistency.

### Step 2.5 – Create the Final Identity Resolution Table

Created the curated BigQuery table:

`customer_360_curated.identity_resolved_sessions`

The table combines GA4 session fields with available synthetic mapping fields and CRM profile attributes. It includes `identity_resolution_status` to distinguish identified and unidentified sessions.

### Step 2.6 – Verify the Final Curated Table

Executed the final validation query successfully.

Recorded validation results:

| Validation measure | Result |
|---|---:|
| Total sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

All source sessions were retained in the final output. Identified and unidentified session counts reconcile to 360,129.

### Phase 2 Deliverables

- Raw GA4 session, CRM customer and identity mapping tables available in BigQuery.
- Identity mapping inspected and validated.
- Session-to-mapping-to-CRM join logic previewed and checked.
- Curated table `customer_360_curated.identity_resolved_sessions` created.
- Final validation query executed successfully.
- Identity status available to distinguish identified and unidentified sessions.

### Important Limitation

The identity mapping dataset is synthetic. The validation confirms the consistency of the implemented joins against the generated mapping data; it does not establish real-world identity accuracy.

**Phase 2 status: Completed.**

---

## Next Phase – Customer 360 Data Modelling with dbt

The next phase is to create dbt models for:
1. Sessions.
2. Orders.
3. Customer profiles.

These models will build on the source and identity-resolution work completed in Phases 1 and 2.