# Project Setup Guide
## Customer 360 & Marketing Attribution Programme

## 1. Overview

This guide describes the initial environment setup required to work with the Customer 360 & Marketing Attribution project.

The project uses Python, Google BigQuery, SQL, dbt, Tableau and Git.

## 2. Prerequisites

Install the following tools:

| Tool | Purpose |
|---|---|
| Python 3.11 or compatible version | Data generation and processing |
| Visual Studio Code | Development environment |
| Git | Version control |
| Google Cloud Account | Cloud data warehouse access |
| Google BigQuery | Data storage and querying |
| dbt Core | Data transformation |
| Tableau Desktop or Tableau Public | Data visualization |

## 3. Clone the Repository

Clone the GitHub repository:

```bash
git clone https://github.com/YOUR_USERNAME/Customer-360-Marketing-Attribution.git
```

Navigate to the project directory:

```bash
cd Customer-360-Marketing-Attribution
```

## 4. Configure Python Environment

Create a virtual environment:

```bash
python -m venv .venv
```

Activate it on Windows:

```powershell
.\.venv\Scripts\Activate.ps1
```

Install the required dependencies:

```bash
pip install -r requirements.txt
```

## 5. Configure Environment Variables

Create a local environment file:

```powershell
Copy-Item .env.example .env
```

Configure the appropriate values in `.env`.

Example:

```env
GCP_PROJECT_ID=your-google-cloud-project-id
GCP_LOCATION=US

BQ_RAW_DATASET=customer_360_raw
BQ_STAGING_DATASET=customer_360_staging
BQ_ANALYTICS_DATASET=customer_360_analytics

ENVIRONMENT=development
RANDOM_SEED=42
```

Replace placeholder values with the actual Google Cloud project configuration.

Never upload `.env` or credentials to GitHub.

## 6. Google BigQuery Setup

1. Sign in to Google Cloud Console.
2. Select the Google Cloud project created for this project.
3. Open BigQuery.
4. Confirm that BigQuery is available and the necessary API and permissions are configured.
5. Access the public GA4 ecommerce sample dataset.
6. Create the project's raw, staging and analytics datasets when required.
7. Ensure the dataset locations are compatible with the source data and planned queries.

The planned BigQuery datasets are:

- `customer_360_raw`
- `customer_360_staging`
- `customer_360_analytics`

BigQuery billing configuration may be required for queries executed using your own Google Cloud project.

## 7. Data Source Access

### GA4 Public Ecommerce Dataset

Source:

`bigquery-public-data.ga4_obfuscated_sample_ecommerce.events_*`

The dataset can be accessed through BigQuery.

### Synthetic CSV Datasets

The following files are maintained under `data/raw/`:

- `synthetic_crm_customers.csv`
- `synthetic_ad_spend.csv`
- `identity_mapping.csv`

These files will be loaded into BigQuery during the data ingestion phase.

## 8. Python Execution

Python scripts are maintained in the `python/` directory.

The main scripts include:

- `generate_crm.py`
- `generate_ad_spend.py`
- `identity_resolution.py`

Execute scripts from the project root using:

```bash
python python/generate_crm.py
```

Use the corresponding script filename for other operations.

## 9. dbt Setup

dbt will be configured to connect to Google BigQuery.

The configuration will include:

- dbt project configuration.
- BigQuery connection profile.
- Source definitions.
- Staging models.
- Intermediate models.
- Analytical marts.
- Data quality tests.

Actual dbt configuration will be completed during the transformation phase.

## 10. Git and GitHub Workflow

Check the current repository status:

```bash
git status
```

Stage changes:

```bash
git add .
```

Commit changes:

```bash
git commit -m "Describe your changes"
```

Push changes:

```bash
git push origin main
```

## 11. Security Guidelines

- Never commit API keys or passwords.
- Never upload service-account credentials.
- Keep `.env` excluded from Git.
- Use synthetic data for development and demonstration.
- Avoid publishing personally identifiable information.
- Review files before pushing them to a public repository.

## 12. Setup Status

The initial GitHub repository and project folder structure have been established.

Python-based synthetic dataset generation has been completed.

BigQuery ingestion, dbt connection configuration and subsequent analytical environment configuration will be documented as those components are implemented.