with deduplicated as (
    select *
    from (
        select *,
               row_number() over (
                   partition by patient_id, practice_id
                   order by registration_date desc
               ) as row_num
        from {{ ref('stg_patients') }}
    )
    where row_num = 1
),

filtered as (
    select *
    from deduplicated
    where practice_id between 1 and 4
)

select
    patient_id,
    practice_id,
    case
        when age between 0 and 120 then age
        else null
    end as age,
    gender,
    registration_date,
    email,
    phone,
    conditions
from filtered