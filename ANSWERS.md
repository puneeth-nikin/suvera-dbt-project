# Suvera Take-Home Assessment – Answers

This document presents responses to the questions outlined in the Suvera data take-home assessment. 

---

## Q1: How can we handle poor data quality and integrity?

To ensure data quality and integrity, the following steps were implemented:

* **Staging Layer**: Extracts structured fields from semi-structured data (e.g., `raw_patients` using regex logic).
* **Intermediate Layer (`cleaned_patients`)**:

  * Deduplicates records by `patient_id + practice_id`, retaining the most recent `registration_date`
  * Sets `age` to null if outside 0–120 range
  * Filters out records with `practice_id` null or equal to 999
* **QA Layer (`qa_flagged_patients`)**: Captures and categorises records that were excluded from the cleaned layer, indicating the specific reason (e.g., "invalid age", "missing practice ID"). This is materialised as a table for further down stream processing.
* **Testing**:

  * `not_null` tests for all required fields
  * `unique_combination_of_columns` test for `patient_id` + `practice_id`
  * QA coverage for edge cases

---

## Q2: How many patients belong to each PCN?

Use the model: `mart_patient_count_by_pcn`

```sql
SELECT * FROM mart_patient_count_by_pcn;
```

**Output:**

```text
|    |   pcn_id | pcn_name                           |   num_patients |
|----|----------|------------------------------------|----------------|
|  0 |        1 | visualize virtual niches PCN       |             97 |
|  1 |        2 | streamline proactive mindshare PCN |             87 |

```

(Replace with actual table)

---

## Q3: What's the average patient age per practice?

Use the model: `mart_avg_age_by_practice`

```sql
SELECT * FROM mart_avg_age_by_practice;
```

**Output:**

```text
|    |   practice_id |   avg_age |   num_patients |
|----|---------------|-----------|----------------|
|  0 |             1 |   59.1842 |             45 |
|  1 |             2 |   56.6579 |             42 |
|  2 |             4 |   56.35   |             45 |
|  3 |             3 |   49.3061 |             54 |
```

---

## Q4: Categorise patients into age groups (0–18, 19–35, 36–50, 51+) and show the count per group per PCN

Use the model: `mart_age_groups_by_pcn`

```sql
SELECT * FROM mart_age_groups_by_pcn;
```

**Output:**

```text
|    |   pcn_id | pcn_name                           | age_group   |   num_patients |
|----|----------|------------------------------------|-------------|----------------|
|  0 |        1 | visualize virtual niches PCN       | 0-18        |             16 |
|  1 |        1 | visualize virtual niches PCN       | 19-35       |             16 |
|  2 |        1 | visualize virtual niches PCN       | 36-50       |             20 |
|  3 |        1 | visualize virtual niches PCN       | 51+         |             37 |
|  4 |        1 | visualize virtual niches PCN       | Unknown     |             10 |
|  5 |        2 | streamline proactive mindshare PCN | 0-18        |              6 |
|  6 |        2 | streamline proactive mindshare PCN | 19-35       |             19 |
|  7 |        2 | streamline proactive mindshare PCN | 36-50       |              9 |
|  8 |        2 | streamline proactive mindshare PCN | 51+         |             42 |
|  9 |        2 | streamline proactive mindshare PCN | Unknown     |             11 |
```

---

## Q5: What percentage of patients have Hypertension at each practice?

Use the model: `mart_hypertension_pct_by_practice`

```sql
SELECT * FROM mart_hypertension_pct_by_practice;
```

**Output:**

```text
|    |   practice_id |   total_patients |   patients_with_hypertension |   pct_with_hypertension |
|----|---------------|------------------|------------------------------|-------------------------|
|  0 |             3 |               54 |                           22 |                    40.7 |
|  1 |             2 |               42 |                           16 |                    38.1 |
|  2 |             4 |               45 |                           17 |                    37.8 |
|  3 |             1 |               45 |                           12 |                    26.7 |
```

---

## Q6: For each patient, show their most recent activity date

Use the model: `mart_recent_activity_by_patient`

```sql
SELECT * FROM mart_recent_activity_by_patient;
```

**Sample Output:**

```text
|    |   patient_id | most_recent_activity   |
|----|--------------|------------------------|
|  0 |         1055 | 2025-03-01 16:45:00    |
|  1 |         1232 | 2025-02-10 10:30:00    |
|  2 |         1046 | 2025-01-09 12:15:00    |
|  3 |         1003 | 2025-02-11 13:00:00    |
|  4 |         1158 | 2025-02-02 16:45:00    |
```

---

## Q7: Find patients who had no activity for 3 months after their first

Use the model: `mart_patients_no_activity_3mo`

```sql
SELECT * FROM mart_patients_no_activity_3mo;
```

**Output:**

```text
| patient_id | first_activity | last_activity |
|------------|----------------|----------------|
| 1003       | YYYY-MM-DD     | YYYY-MM-DD     |
```

---

> Replace all `...` and placeholders with actual values based on notebook queries if including static answers.
