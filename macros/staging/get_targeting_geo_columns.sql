{% macro get_targeting_geo_columns() %}

{% set columns = [
    {"name": "country_id", "datatype": dbt.type_string()},
    {"name": "country_name", "datatype": dbt.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
