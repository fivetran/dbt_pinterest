with base as (

    select *
    from {{ var('advertiser_history') }}

), row_num as (

    select 
        *,
        row_number() over (partition by advertiser_id order by updated_timestamp desc) as rn
    from base

), filtered as (

    select *
    from row_num
    where rn = 1
    
)

select *
from filtered