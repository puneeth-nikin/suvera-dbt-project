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
    where age between 0 and 120 and practice_id between 1 and 4 and age != 999
)

select
    patient_id,
    practice_id,
    age,
    gender,
    registration_date,
    email,
    phone,
    conditions
from filtered