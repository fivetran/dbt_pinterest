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
    'campaign vs advertiser' as comparison
from campaign_report 
join advertiser_report on true
where campaign_report.total_conversions != advertiser_report.total_conversions
    or campaign_report.total_conversions_quantity != advertiser_report.total_conversions_quantity
    or campaign_report.total_conversions_value_in_micro_dollar != advertiser_report.total_conversions_value_in_micro_dollar

union all

select
    'ad group vs campaign' as comparison
from ad_group_report 
join campaign_report on true
where ad_group_report.total_conversions != campaign_report.total_conversions
    or ad_group_report.total_conversions_quantity != campaign_report.total_conversions_quantity
    or ad_group_report.total_conversions_value_in_micro_dollar != campaign_report.total_conversions_value_in_micro_dollar

union all

select
    'ad group vs pin_promotion' as comparison
from ad_group_report 
join pin_promotion_report on true
where ad_group_report.total_conversions != pin_promotion_report.total_conversions
    or ad_group_report.total_conversions_quantity != pin_promotion_report.total_conversions_quantity
    or ad_group_report.total_conversions_value_in_micro_dollar != pin_promotion_report.total_conversions_value_in_micro_dollar