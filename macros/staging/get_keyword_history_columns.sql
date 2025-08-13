{% macro get_keyword_history_columns() %}

{% set columns = [
    {"name": "_fivetran_id", "datatype": dbt.type_string()},
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "ad_group_id", "datatype": dbt.type_string()},
    {"name": "advertiser_id", "datatype": dbt.type_string()},
    {"name": "archived", "datatype": "boolean"},
    {"name": "bid", "datatype": dbt.type_int()},
    {"name": "campaign_id", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "match_type", "datatype": dbt.type_string()},
    {"name": "parent_type", "datatype": dbt.type_string()},
    {"name": "value", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
