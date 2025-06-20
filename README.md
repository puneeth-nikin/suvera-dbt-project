# Suvera DBT Project

This project uses DBT and DuckDB to clean and analyse synthetic healthcare data for Suvera's data task.  Project developed and tested using Python 3.13.5 version

## Answers

For answers and sample outputs, see [`ANSWERS.md`](./ANSWERS.md).

## Setup Instructions

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt

# Run the full pipeline
dbt deps

# Load the seed CSVs
dbt seed

# Build all models
dbt run

# Run all tests
dbt test

# Generate and view documentation
dbt docs generate
dbt docs serve
```

## Project Structure

| Folder                 | Description                                  |
| ---------------------- | -------------------------------------------- |
| `models/staging/`      | Extracts and parses raw input columns        |
| `models/intermediate/` | Applies deduplication and data quality rules |
| `models/qa/`           | Captures excluded records with reasons       |
| `models/marts/`        | Final outputs to answer business questions   |
| `seeds/`               | Raw input files (CSV)                        |
| `scripts/notebooks/`   | Optional: query exploration in Jupyter       |
| `ANSWERS.md`           | Answers to the questions using SQL outputs   |




---

This project follows DBT best practices and self-documenting with `dbt docs`.
