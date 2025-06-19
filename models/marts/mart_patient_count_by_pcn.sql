with patients as (
    select *
    from {{ ref('cleaned_patients') }}
),

practices as (
    select *
    from {{ ref('stg_practices') }}
),

pcns as (
    select *
    from {{ ref('stg_pcns') }}
),

joined as (
    select
        pcn.id as pcn_id,
        pcn.pcn_name pcn_name,
        patient.patient_id
    from patients as patient
    left join practices as practice
        on patient.practice_id = practice.id
    left join pcns as pcn
        on practice.pcn = pcn.id
)

select
    pcn_id,
    pcn_name,
    count(distinct patient_id) as num_patients
from joined
group by 1, 2
order by num_patients desc
