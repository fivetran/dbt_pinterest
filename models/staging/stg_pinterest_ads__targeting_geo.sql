{{ config(enabled=fivetran_utils.enabled_vars(['ad_reporting__pinterest_ads_enabled', 'pinterest__using_targeting_geo'])) }}

with base as (

    select *
    from {{ ref('stg_pinterest_ads__targeting_geo_tmp') }}

), fields as (

    select
        {{ fivetran_utils.fill_staging_columns(
            source_columns=adapter.get_columns_in_relation(ref('stg_pinterest_ads__targeting_geo_tmp')),
            staging_columns=get_targeting_geo_columns()
        ) }}

        {{ fivetran_utils.source_relation(
            union_schema_variable='pinterest_ads_union_schemas', 
            union_database_variable='pinterest_ads_union_databases'
        ) }}
    
    from base

), final as (
    select
        source_relation,
        cast(_fivetran_synced as {{ dbt.type_timestamp() }}) as _fivetran_synced,
        cast(country_id as {{ dbt.type_string() }}) as country_id,
        country_name
    from fields
)

select *
from final
