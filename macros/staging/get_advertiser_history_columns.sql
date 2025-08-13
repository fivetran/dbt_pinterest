{% macro get_advertiser_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "country", "datatype": dbt.type_string()},
    {"name": "created_time", "datatype": dbt.type_timestamp()},
    {"name": "currency", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "owner_user_id", "datatype": dbt.type_string()},
    {"name": "owner_username", "datatype": dbt.type_string()},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "permissions", "datatype": dbt.type_string(), "quote": True,  "alias": "advertiser_permissions"},
    {"name": "updated_time", "datatype": dbt.type_timestamp()}
] %}

{{ return(columns) }}

{% endmacro %}
