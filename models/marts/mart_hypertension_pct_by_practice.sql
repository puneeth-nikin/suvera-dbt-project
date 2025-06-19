with patients as (
    select
        patient_id,
        practice_id,
        conditions
    from {{ ref('cleaned_patients') }}
),

exploded as (
    select
        patient_id,
        practice_id,
        unnest(conditions) as condition
    from patients
),

hypertension_counts as (
    select
        practice_id,
        count(distinct patient_id) as patients_with_hypertension
    from exploded
    where lower(condition) = 'hypertension'
    group by practice_id
),

total_patients as (
    select
        practice_id,
        count(distinct patient_id) as total_patients
    from patients
    group by practice_id
)

select
    t.practice_id,
    t.total_patients,
    coalesce(h.patients_with_hypertension, 0) as patients_with_hypertension,
    round(
        coalesce(h.patients_with_hypertension, 0) * 100.0 / t.total_patients,
        1
    ) as pct_with_hypertension
from total_patients t
left join hypertension_counts h
    on t.practice_id = h.practice_id
order by pct_with_hypertension desc
