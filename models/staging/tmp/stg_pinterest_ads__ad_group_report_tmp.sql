{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

{% if var('pinterest_ads_union_schemas', []) | length > 0 or var('pinterest_ads_union_databases', []) | length > 0 %}

{{
    fivetran_utils.union_data(
        table_identifier='ad_group_report',
        database_variable='pinterest_ads_database',
        schema_variable='pinterest_ads_schema',
        default_database=target.database,
        default_schema='pinterest',
        default_variable='ad_group_report',
        union_schema_variable='pinterest_ads_union_schemas',
        union_database_variable='pinterest_ads_union_databases'
    )
}}

{% else %}

{{
    fivetran_utils.union_connections(
        connection_dictionary='pinterest_ads_sources',
        single_source_name='pinterest_ads',
        single_table_name='ad_group_report'
    )
}}

{% endif %}
