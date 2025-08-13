{% macro get_pin_promotion_report_columns() %}

{% set columns = [
    {"name": "_fivetran_synced", "datatype": dbt.type_timestamp()},
    {"name": "ad_group_id", "datatype": dbt.type_string()},
    {"name": "advertiser_id", "datatype": dbt.type_string()},
    {"name": "campaign_id", "datatype": dbt.type_string()},
    {"name": "clickthrough_1", "datatype": dbt.type_numeric()},
    {"name": "clickthrough_2", "datatype": dbt.type_numeric()},
    {"name": "date", "datatype": dbt.type_timestamp()},
    {"name": "impression_1", "datatype": dbt.type_numeric()},
    {"name": "impression_2", "datatype": dbt.type_numeric()},
    {"name": "pin_promotion_id", "datatype": dbt.type_string()},
    {"name": "spend_in_micro_dollar", "datatype": dbt.type_numeric()},
    {"name": "total_conversions", "datatype": dbt.type_int()},
    {"name": "total_conversions_quantity", "datatype": dbt.type_int()},
    {"name": "total_conversions_value_in_micro_dollar", "datatype": dbt.type_int()}
] %}

{# Make backwards compatible in case users were bringing in conversion metrics via passthrough columns prior to us adding them by default #}
{{ pinterest_ads_add_passthrough_columns(base_columns=columns, pass_through_fields=var('pinterest__pin_promotion_report_passthrough_metrics'), except_fields=['total_conversions', "total_conversions_quantity", "total_conversions_value_in_micro_dollar"]) }}

{{ return(columns) }}

{% endmacro %}
