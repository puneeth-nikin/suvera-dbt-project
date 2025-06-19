with patients as (
    select
        patient_id,
        practice_id,
        age
    from {{ ref('cleaned_patients') }}
),

aggregated as (
    select
        practice_id,
        avg(age) as avg_age,
        count(*) as num_patients
    from patients
    group by practice_id
)

select * from aggregated
order by avg_age desc
