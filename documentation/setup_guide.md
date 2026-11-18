# Project Setup Guide
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This guide describes the development environment and configuration required to work with the project.

The project uses Python, Google BigQuery, SQL, dbt Core, Git, and Tableau.

## 2. Prerequisites

| Tool | Version / Requirement | Purpose |
|---|---|---|
| Python | 3.11.4 | Synthetic data generation and processing |
| Google Cloud | BigQuery access | Cloud data warehouse |
| dbt Core | 1.12.7 | Data transformation |
| dbt-bigquery | 1.12.3 | BigQuery adapter |
| Git | Installed | Version control |
| VS Code | Recommended | Development environment |
| Tableau | Desktop or Public | Planned visualization |

## 3. Clone the Repository

```bash
git clone https://github.com/aamir0430/Customer-360-Marketing-Attribution.git
cd Customer-360-Marketing-Attribution