with patients as (
    select patient_id
    from {{ ref('cleaned_patients') }}
),

activities as (
    select
        patient_id,
        activity_date
    from {{ ref('stg_activities') }}
),

filtered as (
    select *
    from activities
    where patient_id in (select patient_id from patients)
)

select
    patient_id,
    max(activity_date) as most_recent_activity
from filtered
group by patient_id
