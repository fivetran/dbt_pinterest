{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

with base as (

    select *
    from {{ ref('stg_pinterest_ads__campaign_history_tmp') }}
), 

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pinterest_ads__campaign_history_tmp')),
                staging_columns=get_campaign_history_columns()
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
        cast(id as {{ dbt.type_string() }}) as campaign_id,
        name as campaign_name,
        cast(advertiser_id as {{ dbt.type_string() }}) as advertiser_id,
        default_ad_group_budget_in_micro_currency,
        is_automated_campaign,
        is_campaign_budget_optimization,
        is_flexible_daily_budgets,
        status as campaign_status,
        _fivetran_synced,
        created_time as created_at,
        start_time,
        end_time,
        budget_spend_cap,
        lifetime_spend_cap,
        objective_type,
        row_number() over (partition by source_relation, id order by _fivetran_synced desc) = 1 as is_most_recent_record
    from fields
)

select *
from final
