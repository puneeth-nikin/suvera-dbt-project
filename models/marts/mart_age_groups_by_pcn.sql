with patients as (
    select
        patient_id,
        practice_id,
        age,
        case
            when age between 0 and 18 then '0-18'
            when age between 19 and 35 then '19-35'
            when age between 36 and 50 then '36-50'
            when age >= 51 then '51+'
            else 'Unknown'
        end as age_group
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
        pcn.pcn_name,
        p.age_group
    from patients as p
    left join practices pr on p.practice_id = pr.id
    left join pcns pcn on pr.pcn = pcn.id
)

select
    pcn_id,
    pcn_name,
    age_group,
    count(*) as num_patients
from joined
group by pcn_id, pcn_name, age_group
order by pcn_id, age_group
