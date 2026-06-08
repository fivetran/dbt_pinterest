{{ config(enabled=fivetran_utils.enabled_vars(['ad_reporting__pinterest_ads_enabled', 'pinterest__using_targeting_geo_region'])) }}

{% if var('pinterest_union_schemas', []) | length > 0 or var('pinterest_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='targeting_geo_region', 
        database_variable='pinterest_database', 
        schema_variable='pinterest_schema', 
        default_database=target.database,
        default_schema='pinterest',
        default_variable='targeting_geo_region',
        union_schema_variable='pinterest_union_schemas',
        union_database_variable='pinterest_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='pinterest_sources',
        single_source_name='pinterest',
        single_table_name='targeting_geo_region'
    )
}}

{% endif %}