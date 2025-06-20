with activities as (
    select
        patient_id,
        activity_date
    from {{ ref('stg_activities') }}
),

first_activity as (
    select
        patient_id,
        min(activity_date) as first_date
    from activities
    group by patient_id
),

follow_up_activity as (
    select
        a.patient_id
    from activities a
    join first_activity f
        on a.patient_id = f.patient_id
    where a.activity_date > f.first_date
      and a.activity_date <= f.first_date + interval '90 days'
),

inactive_patients as (
    select
        f.patient_id,
        f.first_date
    from first_activity f
    left join follow_up_activity fu
        on f.patient_id = fu.patient_id
    where fu.patient_id is null
)

select patient_id
from inactive_patients
