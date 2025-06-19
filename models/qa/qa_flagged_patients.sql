with source as (
    select *
    from {{ ref('stg_patients') }}
),

deduplicated as (
    select *
    from (
        select *,
               row_number() over (
                   partition by patient_id, practice_id
                   order by registration_date desc
               ) as row_num
        from source
    )
),

flagged as (
    select *,
        case
            when row_num > 1 then 'duplicate registration for patient + practice'
            when age not between 0 and 120 then 'invalid age'
            when practice_id is null then 'missing practice_id'
            when practice_id = 999 then 'dummy practice_id (999)'
        end as reason_flagged
    from deduplicated
    where
        row_num > 1
        or age not between 0 and 120
        or practice_id is null
        or practice_id = 999
)

select *
from flagged
