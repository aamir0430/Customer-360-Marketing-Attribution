# Project Journal
## Customer 360 & Marketing Attribution Programme

---

## Phase 1 – Data Source Setup and Dataset Generation

**Status:** Completed

### Work completed

- Selected Google's public GA4 ecommerce sample in BigQuery: `bigquery-public-data.ga4_obfuscated_sample_ecommerce`.
- Inspected GA4 event data, identifiers, session information, traffic sources, and ecommerce purchase information.
- Generated `synthetic_crm_customers.csv`.
- Generated `synthetic_ad_spend.csv`.
- Generated `identity_mapping.csv`.
- Organized the synthetic source files under `data/raw/`.

**Phase 1 status: Completed.**

---

## Phase 2 – Build an Identity Resolution Step That Links Sessions and Customers

**Status:** Completed

### Objective

Build a BigQuery dataset that links GA4 sessions to CRM customer profiles wherever a corresponding synthetic identity mapping exists.

### Work completed

1. Prepared and loaded GA4 sessions, CRM customers, and identity mapping into `customer_360_raw`.
2. Verified source table presence and row counts.
3. Inspected the synthetic identity mapping and relevant identifiers.
4. Previewed joins between sessions, mapping records, and CRM customers.
5. Used LEFT JOIN logic to preserve the full GA4 session population.
6. Created `customer_360_curated.identity_resolved_sessions`.
7. Added `identity_resolution_status` to distinguish identified and unidentified sessions.
8. Executed final validation queries.

### Recorded validation results

| Measure | Result |
|---|---:|
| Total sessions | 360,129 |
| Unique sessions | 360,129 |
| Identified sessions | 10,246 |
| Unidentified sessions | 349,883 |
| CRM customers represented among identified sessions | 3,500 |
| Missing CRM customer records | 0 |
| Mismatched synthetic IDs | 0 |

All source sessions were retained. The identified and unidentified counts reconcile to 360,129.

### Limitation

The identity mapping is synthetic. The checks establish consistency against the generated mappings, not real-world identity accuracy.

**Phase 2 status: Completed.**

---

## Phase 3 – dbt Data Modelling: Sessions, Orders, and Customer Profiles

**Status:** Completed

### Objective

Build a dbt transformation layer on top of the BigQuery raw and curated data, producing reusable session, order, and customer-profile models for downstream analytics.

### Step 3.1 – Configure the dbt Environment

- Set up the dbt project named `customer_360`.
- Configure the BigQuery connection and development target.
- Resolve a local Python package compatibility issue encountered during dbt diagnostics.
- Re-run `dbt debug` and confirm that all checks passed.

### Step 3.2 – Validate the dbt Project

- Run `dbt parse` successfully.
- Review project configuration warnings.
- Inspect the available BigQuery datasets and tables before defining sources and models.

### Step 3.3 – Configure dbt Sources

Configure the upstream sources required by the modelling workflow:

- `ga4_sessions`
- `ga4_events`
- `crm_customers`
- `identity_mapping`
- `identity_resolved_sessions`

These sources span the existing raw and curated BigQuery layers.

### Step 3.4 – Build the Staging Layer

Create the following staging models:

- `stg_ga4_sessions.sql`
- `stg_ga4_events.sql`
- `stg_crm_customers.sql`
- `stg_identity_mapping.sql`
- `stg_identity_resolved_sessions.sql`

The staging layer standardizes source data for downstream transformations. GA4 event staging retains nested ecommerce and item structures required for purchase-related modelling. Staging models are configured as views.

### Step 3.5 – Build Core Analytical Models

Create the three core marts:

- `fct_sessions.sql`
- `fct_orders.sql`
- `dim_customer_profile.sql`

The models provide session-level, order-level, and consolidated customer-profile outputs. Intermediate reusable transformations are configured as ephemeral models where appropriate.

### Step 3.6 – Configure Model Metadata

Maintain dbt source/model YAML metadata and documentation for the source declarations, staging models, and core models.

### Step 3.7 – Build and Validate BigQuery Outputs

- Build dbt outputs in the development target dataset `customer_360_dbt_dev`.
- Validate the `fct_sessions` output.
- Validate the `fct_orders` output.
- Validate the `dim_customer_profile` output.

The project owner confirmed that all three core mart validations were successful.

### Step 3.8 – Generate dbt Documentation

- Run `dbt docs generate` successfully.
- Generate the catalog at `dbt/target/catalog.json`.
- Note that non-fatal `agate` `table_owner` warnings appeared during generation; catalog generation completed.

### Phase 3 Deliverables

- Configured dbt project `customer_360`.
- Configured five upstream BigQuery sources.
- Created five staging models.
- Created `fct_sessions`, `fct_orders`, and `dim_customer_profile`.
- Configured staging views and ephemeral intermediate transformations where appropriate.
- Created and validated the three core mart outputs in `customer_360_dbt_dev`.
- Completed dbt diagnostics and project parsing.
- Generated dbt documentation and catalog.

**Evidence note:** Exact final automated test/build totals and individual mart row counts are not included because those numerical outputs are not available in the completion record. They should be added only from saved command output or query evidence.

**Phase 3 status: Completed.**

---

## Next Phase – Customer Analytics

Phase 4 will use the completed dbt models to develop customer analytics, including RFM segmentation and historical Customer Lifetime Value (CLV). Marketing attribution, campaign ROI/CPA analysis, and Tableau dashboards remain later phases.