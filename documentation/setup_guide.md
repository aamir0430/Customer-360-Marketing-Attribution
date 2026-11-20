# Project Setup Guide

## 1. Overview

This document describes the steps required to configure and reproduce the Customer 360 & Marketing Attribution project.

## 2. Prerequisites

Required tools:

- Google Cloud account.
- BigQuery access.
- Python.
- dbt Core.
- dbt BigQuery adapter.
- Git.
- Tableau Desktop.

## 3. Google BigQuery Setup

Project ID:

`customer-360-mta`

Location:

`US`

Required datasets:

- customer_360_raw
- customer_360_curated
- customer_360_dbt_dev

Ensure that the public GA4 sample dataset is accessible:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce`

Required raw tables:

- ga4_events
- ga4_sessions
- crm_customers
- identity_mapping

Advertising inputs are synthetic project data.

## 4. Authentication

Configure Google Cloud authentication using an appropriate Google Cloud authentication method.

Ensure that the account has the required BigQuery permissions.

Do not commit:

- Service-account JSON keys.
- OAuth tokens.
- Passwords.
- Local credential files.
- Sensitive configuration.

## 5. Python and dbt Setup

Verify Python:

```bash
python --version
```

Install dbt Core and the BigQuery adapter using the versions recorded in the project environment.

The development environment used:

- Python 3.11.4
- dbt Core 1.12.7
- dbt BigQuery adapter 1.12.3

Configure the local dbt profile for:

- Project: customer-360-mta
- Target dataset: customer_360_dbt_dev
- Location: US

Use the project's `dbt_project.yml` and a locally configured `profiles.yml`.

Do not upload credential-containing profiles.

## 6. dbt Execution

Navigate to the dbt project directory.

Run:

```bash
dbt debug
```

Parse the project:

```bash
dbt parse
```

Build the available models:

```bash
dbt build
```

Generate documentation:

```bash
dbt docs generate
```

Run tests independently when required:

```bash
dbt test
```

## 7. Tableau Setup

1. Open Tableau Desktop.
2. Open the project workbook.
3. Connect to the relevant BigQuery analytical tables.
4. Verify the configured data sources.
5. Refresh the available data.
6. Open each dashboard.
7. Verify filters and KPI calculations.

Completed dashboards:

- Customer 360 Executive Overview.
- Marketing Attribution & Conversion Insights.
- Campaign Performance.
- Marketing Efficiency & Budget Recommendations.

## 8. Final Validation

Before presenting the project:

- Verify BigQuery table availability.
- Run dbt tests.
- Check customer identity outputs.
- Validate attribution reconciliation.
- Check advertising spend reconciliation.
- Verify Tableau dashboard filters.
- Confirm the documented campaign mapping limitations.

## 9. Google Drive Deliverables

The final presentation and working demonstration recordings are stored in Google Drive.

Their access links are maintained in the main README.

## 10. Security

Never commit credentials, authentication tokens, passwords or private customer data to GitHub.