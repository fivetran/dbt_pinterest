{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

with base as (

    select * 
    from {{ ref('stg_pinterest_ads__campaign_report_tmp') }}
),

fields as (

    select
        {{
            fivetran_utils.fill_staging_columns(
                source_columns=adapter.get_columns_in_relation(ref('stg_pinterest_ads__campaign_report_tmp')),
                staging_columns=get_campaign_report_columns()
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
        {{ dbt.date_trunc('day', 'date') }} as date_day,
        cast(campaign_id as {{ dbt.type_string() }}) as campaign_id,
        campaign_name,
        campaign_status,
        cast(advertiser_id as {{ dbt.type_string() }}) as advertiser_id,
        coalesce(impression_1,0) + coalesce(impression_2,0) as impressions,
        coalesce(clickthrough_1,0) + coalesce(clickthrough_2,0) as clicks,
        coalesce(spend_in_micro_dollar, 0) / 1000000.0 as spend,
        coalesce(total_conversions, 0) as total_conversions,
        coalesce(total_conversions_quantity, 0) as total_conversions_quantity,
        coalesce(total_conversions_value_in_micro_dollar, 0) / 1000000.0 as total_conversions_value

        {{ pinterest_ads_fill_pass_through_columns(pass_through_fields=var('pinterest__campaign_report_passthrough_metrics'), except=['total_conversions','total_conversions_quantity','total_conversions_value']) }}

    from fields
)

select *
from final
