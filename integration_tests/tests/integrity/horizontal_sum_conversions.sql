{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with advertiser_report as (

    select
        sum(total_conversions) as total_conversions,
        sum(total_conversions_quantity) as total_conversions_quantity,
        sum(total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__advertiser_report') }}
),

campaign_report as (

    select
        sum(total_conversions) as total_conversions,
        sum(total_conversions_quantity) as total_conversions_quantity,
        sum(total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__campaign_report') }}
),

ad_group_report as (

    select
        sum(total_conversions) as total_conversions,
        sum(total_conversions_quantity) as total_conversions_quantity,
        sum(total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__ad_group_report') }}
),

url_report as (

    select
        sum(total_conversions) as total_conversions,
        sum(total_conversions_quantity) as total_conversions_quantity,
        sum(total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__url_report') }}
),

keyword_report as (

    select
        sum(total_conversions) as total_conversions,
        sum(total_conversions_quantity) as total_conversions_quantity,
        sum(total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__keyword_report') }}
),

pin_promotion_report as (

    select
        sum(total_conversions) as total_conversions,
        sum(total_conversions_quantity) as total_conversions_quantity,
        sum(total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__pin_promotion_report') }}
)

select 
    'ad group vs advertiser' as comparison
from ad_group_report 
join advertiser_report on true
where ad_group_report.total_conversions != advertiser_report.total_conversions
    or ad_group_report.total_conversions_quantity != advertiser_report.total_conversions_quantity
    or ad_group_report.total_conversions_value_in_micro_dollar != advertiser_report.total_conversions_value_in_micro_dollar

-- finish