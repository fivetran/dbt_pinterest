{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_pinterest_ads__advertiser_history_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pinterest_ads__advertiser_history_tmp')),
                staging_columns=get_advertiser_history_columns()
            )
        }}
    
        {{ fivetran_utils.source_relation(
            union_schema_variable='pinterest_ads_union_schemas', 
            union_database_variable='pinterest_ads_union_databases') 
        }}

    from base
),

final as (

    select
        source_relation, 
        cast(id as {{ dbt.type_string() }}) as advertiser_id,
        name as advertiser_name,
        country,
        created_time as created_at,
        currency as currency_code,
        owner_user_id,
        owner_username,
        advertiser_permissions, -- permissions was renamed in macro
        updated_time as updated_at,
        row_number() over (partition by source_relation, id order by updated_time desc) = 1 as is_most_recent_record
    from fields
)

select *
from final
