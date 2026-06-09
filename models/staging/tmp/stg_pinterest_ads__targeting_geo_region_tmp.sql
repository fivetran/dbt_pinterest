{{ config(enabled=fivetran_utils.enabled_vars(['ad_reporting__pinterest_ads_enabled', 'pinterest__using_targeting_geo_region'])) }}

{% if var('pinterest_ads_union_schemas', []) | length > 0 or var('pinterest_ads_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='targeting_geo_region',
        database_variable='pinterest_ads_database',
        schema_variable='pinterest_ads_schema',
        default_database=target.database,
        default_schema='pinterest',
        default_variable='targeting_geo_region',
        union_schema_variable='pinterest_ads_union_schemas',
        union_database_variable='pinterest_ads_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='pinterest_ads_sources',
        single_source_name='pinterest_ads',
        single_table_name='targeting_geo_region'
    )
}}

{% endif %}
