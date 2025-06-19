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

filtered_out as (
    select *
    from deduplicated
    where row_num > 1
       or try_cast(age as integer) not between 0 and 120
)

select * from filtered_out