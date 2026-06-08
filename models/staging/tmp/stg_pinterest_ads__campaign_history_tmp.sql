{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

{% if var('pinterest_union_schemas', []) | length > 0 or var('pinterest_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='campaign_history', 
        database_variable='pinterest_database', 
        schema_variable='pinterest_schema', 
        default_database=target.database,
        default_schema='pinterest_ads',
        default_variable='campaign_history',
        union_schema_variable='pinterest_union_schemas',
        union_database_variable='pinterest_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='pinterest_sources',
        single_source_name='pinterest',
        single_table_name='campaign_history'
    )
}}

{% endif %}