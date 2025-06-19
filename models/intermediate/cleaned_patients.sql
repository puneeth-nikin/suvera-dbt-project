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
    where cast(age as integer) between 0 and 120
)

select
    patient_id,
    practice_id,
    cast(age as integer) as age,
    gender,
    registration_date,
    email,
    phone,
    conditions
from filtered