{{ config(enabled=(var('ad_reporting__pinterest_ads_enabled', true) and var('pinterest__using_targeting_geo', true))) }}

{% if var('pinterest_ads_union_schemas', []) | length > 0 or var('pinterest_ads_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='targeting_geo',
        database_variable='pinterest_database',
        schema_variable='pinterest_schema',
        default_database=target.database,
        default_schema='pinterest_ads',
        default_variable='targeting_geo',
        union_schema_variable='pinterest_ads_union_schemas',
        union_database_variable='pinterest_ads_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='pinterest_ads_sources',
        single_source_name='pinterest_ads',
        single_table_name='targeting_geo'
    )
}}

{% endif %}
