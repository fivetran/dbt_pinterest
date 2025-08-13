{% macro get_pin_promotion_history_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "ad_group_id", "datatype": dbt.type_string()},
    {"name": "ad_account_id", "datatype": dbt.type_string()},
    {"name": "android_deep_link", "datatype": dbt.type_string()},
    {"name": "click_tracking_url", "datatype": dbt.type_string()},
    {"name": "created_time", "datatype": dbt.type_timestamp()},
    {"name": "creative_type", "datatype": dbt.type_string()},
    {"name": "destination_url", "datatype": dbt.type_string()},
    {"name": "id", "datatype": dbt.type_string()},
    {"name": "ios_deep_link", "datatype": dbt.type_string()},
    {"name": "is_pin_deleted", "datatype": "boolean"},
    {"name": "is_removable", "datatype": "boolean"},
    {"name": "name", "datatype": dbt.type_string()},
    {"name": "pin_id", "datatype": dbt.type_string()},
    {"name": "review_status", "datatype": dbt.type_string()},
    {"name": "status", "datatype": dbt.type_string()},
    {"name": "updated_time", "datatype": dbt.type_timestamp()},
    {"name": "view_tracking_url", "datatype": dbt.type_string()}
] %}

{{ return(columns) }}

{% endmacro %}
