{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

with base as (

    select *
    from {{ ref('stg_pinterest_ads__pin_promotion_history_tmp') }}
), 

fields as (

    select

        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pinterest_ads__pin_promotion_history_tmp')),
                staging_columns=get_pin_promotion_history_columns()
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
        cast(id as {{ dbt.type_string() }}) as pin_promotion_id,
        cast(ad_account_id as {{ dbt.type_string() }}) as advertiser_id,
        cast(ad_group_id as {{ dbt.type_string() }}) as ad_group_id,
        created_time as created_at,
        destination_url,
        {{ dbt.split_part('destination_url', "'?'", 1) }} as base_url,
        {{ dbt_utils.get_url_host('destination_url') }} as url_host,
        '/' || {{ dbt_utils.get_url_path('destination_url') }} as url_path,
        {{ pinterest.pinterest_ads_extract_url_parameter('destination_url', 'utm_source') }} as utm_source,
        {{ pinterest.pinterest_ads_extract_url_parameter('destination_url', 'utm_medium') }} as utm_medium,
        {{ pinterest.pinterest_ads_extract_url_parameter('destination_url', 'utm_campaign') }} as utm_campaign,
        {{ pinterest.pinterest_ads_extract_url_parameter('destination_url', 'utm_content') }} as utm_content,
        {{ pinterest.pinterest_ads_extract_url_parameter('destination_url', 'utm_term') }} as utm_term,
        name as pin_name,
        cast(pin_id as {{ dbt.type_string() }}) as pin_id,
        status as pin_status,
        creative_type,
        _fivetran_synced,
        row_number() over (partition by source_relation, id order by _fivetran_synced desc) = 1 as is_most_recent_record
    from fields
)

select *
from final
