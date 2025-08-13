{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

{{
    fivetran_utils.union_data(
        table_identifier='ad_group_report', 
        database_variable='pinterest_database', 
        schema_variable='pinterest_schema', 
        default_database=target.database,
        default_schema='pinterest_ads',
        default_variable='ad_group_report',
        union_schema_variable='pinterest_ads_union_schemas',
        union_database_variable='pinterest_ads_union_databases'
    )
}}