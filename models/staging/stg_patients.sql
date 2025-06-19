with source as (
    select * from {{ ref('raw_patients') }}
),

parsed as (
    select
        case
            when regexp_extract(data, '"patient_id": ([0-9]+)', 1) ~ '^[0-9]+$'
            then cast(regexp_extract(data, '"patient_id": ([0-9]+)', 1) as integer)
        end as patient_id,
        case
            when regexp_extract(data, '"practice_id": ([0-9]+)', 1) ~ '^[0-9]+$'
            then cast(regexp_extract(data, '"practice_id": ([0-9]+)', 1) as integer)
        end as practice_id,
        case
            when regexp_extract(data, '"age": ([0-9]+)', 1) ~ '^[0-9]+$'
            then cast(regexp_extract(data, '"age": ([0-9]+)', 1) as integer)
        end as age,
        regexp_extract(data, '"gender": "([^""]*)"', 1) as gender,
        cast(nullif(regexp_extract(data, '"registration_date": "([^"]+)"', 1), '') as date) as registration_date,
        regexp_extract(data, '"email": "([^"]+)"', 1) as email,
        regexp_extract(data, '"phone": "([^"]+)"', 1) as phone,
        string_split(
            replace(
                regexp_extract(data, '"conditions": \[(.*?)\]', 1),
                '"',
                ''
            ),
            ', '
        ) as conditions
    from source
)

select * from parsed
