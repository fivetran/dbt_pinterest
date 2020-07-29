with base as (

    select *
    from {{ ref('stg_pinterest_ads__pin_promotion_history') }}

), row_num as (

    select 
        *,
        row_number() over (partition by pin_promotion_id order by _fivetran_synced desc) as rn
    from base

), filtered as (

    select *
    from row_num
    where rn = 1
    
)

select *
from filtered