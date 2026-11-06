# Customer 360 & Marketing Attribution Programme

An end-to-end data analytics and business intelligence project that integrates website, app, CRM, and advertising data into a unified customer view to understand customer behaviour, lifetime value, and marketing performance.

## Project Overview

The project aims to build a Customer 360 analytics platform that consolidates customer interactions across multiple data sources and identifies which marketing channels generate the most revenue.

## Objectives

- Integrate website and app behavioural data with CRM and advertising data.
- Develop a unified customer identity resolution system.
- Build a consolidated Customer 360 profile.
- Perform RFM analysis and customer segmentation.
- Calculate historical Customer Lifetime Value (CLV).
- Implement multi-touch marketing attribution models.
- Measure marketing ROI, CPA, and channel performance.
- Develop interactive Tableau dashboards.

## Data Sources

| Source | Dataset |
|---|---|
| Website & App | GA4 Ecommerce sample dataset in BigQuery |
| CRM | Synthetic CRM customer data |
| Advertising | Synthetic advertising spend data |
| Identity Mapping | Synthetic cross-platform identity mapping |

## Technology Stack

- Python – Data generation, processing and identity resolution
- SQL – Data extraction, transformation and analytics
- Google BigQuery – Cloud data warehouse
- dbt – Data transformation and modelling
- Tableau – Data visualization and dashboards
- Git & GitHub – Version control and documentation

## Project Architecture

Data Sources → Data Ingestion → BigQuery → SQL/dbt Transformations → Customer 360 & Attribution Analytics → Tableau Dashboards

## Repository Structure

- `data/` – Raw and processed datasets
- `python/` – Python scripts
- `sql/` – SQL transformations and analytics
- `dbt/` – Data modelling and transformation
- `tableau/` – Dashboards and visualizations
- `documentation/` – Technical and project documentation
- `tests/` – Project testing

## Project Status

<em>In development.</em>

Implementation progress, validation results, and final analytical findings will be documented here as the project progresses.

## Getting Started

1. Clone this repository.
2. Set up a Python virtual environment.
3. Install dependencies using `pip install -r requirements.txt`.
4. Configure Google Cloud authentication and BigQuery access.
5. Configure the required environment variables using `.env.example`.
6. Follow `documentation/setup_guide.md` for the complete setup process.

## License

To be determined.