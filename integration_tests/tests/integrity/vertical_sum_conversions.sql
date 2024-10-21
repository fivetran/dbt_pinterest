{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with advertiser_source as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ source('pinterest_ads', 'advertiser_report') }}
),

advertiser_model as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__advertiser_report') }}
),

ad_group_source as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ source('pinterest_ads', 'ad_group_report') }}
),

ad_group_model as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__ad_group_report') }}
),

campaign_source as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ source('pinterest_ads', 'campaign_report') }}
),

campaign_model as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__campaign_report') }}
),

url_source as (

    select 
        sum(coalesce(pin_promotion_report.total_conversions, 0)) as total_conversions,
        sum(coalesce(pin_promotion_report.total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(pin_promotion_report.total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ source('pinterest_ads', 'pin_promotion_report') }} pin_promotion_report
    left join (
        select * from {{ ref('stg_pinterest_ads__pin_promotion_history') }} 
        where is_most_recent_record = True
        ) as pin_promotion_history
    on pin_promotion_report.pin_promotion_id = pin_promotion_history.pin_promotion_id
),

url_model as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__url_report') }}
),

keyword_source as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ source('pinterest_ads', 'keyword_report') }}
),

keyword_model as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__keyword_report') }}
),

pin_promotion_source as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ source('pinterest_ads', 'pin_promotion_report') }}
),

pin_promotion_model as (

    select
        sum(coalesce(total_conversions, 0)) as total_conversions,
        sum(coalesce(total_conversions_quantity, 0)) as total_conversions_quantity,
        sum(coalesce(total_conversions_value_in_micro_dollar, 0)) as total_conversions_value_in_micro_dollar
    from {{ ref('pinterest_ads__pin_promotion_report') }}
)

select 
    'ad_groups' as comparison
from ad_group_model 
join ad_group_source on true
where abs(ad_group_model.total_conversions - ad_group_source.total_conversions) >= .01
    or abs(ad_group_model.total_conversions_quantity - ad_group_source.total_conversions_quantity) >= .01
    or abs(ad_group_model.total_conversions_value_in_micro_dollar - ad_group_source.total_conversions_value_in_micro_dollar) >= .01
    
union all 

select 
    'advertiser' as comparison
from advertiser_model 
join advertiser_source on true
where abs(advertiser_model.total_conversions - advertiser_source.total_conversions) >= .01
    or abs(advertiser_model.total_conversions_quantity - advertiser_source.total_conversions_quantity) >= .01
    or abs(advertiser_model.total_conversions_value_in_micro_dollar - advertiser_source.total_conversions_value_in_micro_dollar) >= .01

union all 

select 
    'campaigns' as comparison
from campaign_model 
join campaign_source on true
where abs(campaign_model.total_conversions - campaign_source.total_conversions) >= .01
    or abs(campaign_model.total_conversions_quantity - campaign_source.total_conversions_quantity) >= .01
    or abs(campaign_model.total_conversions_value_in_micro_dollar - campaign_source.total_conversions_value_in_micro_dollar) >= .01

union all 

select 
    'keywords' as comparison
from keyword_model 
join keyword_source on true
where abs(keyword_model.total_conversions - keyword_source.total_conversions) >= .01
    or abs(keyword_model.total_conversions_quantity - keyword_source.total_conversions_quantity) >= .01
    or abs(keyword_model.total_conversions_value_in_micro_dollar - keyword_source.total_conversions_value_in_micro_dollar) >= .01

union all 

select 
    'urls' as comparison
from url_model 
join url_source on true
where abs(url_model.total_conversions - url_source.total_conversions) >= .01
    or abs(url_model.total_conversions_quantity - url_source.total_conversions_quantity) >= .01
    or abs(url_model.total_conversions_value_in_micro_dollar - url_source.total_conversions_value_in_micro_dollar) >= .01

union all 

select 
    'pin_promotion' as comparison
from pin_promotion_model 
join pin_promotion_source on true
where abs(pin_promotion_model.total_conversions - pin_promotion_source.total_conversions) >= .01
    or abs(pin_promotion_model.total_conversions_quantity - pin_promotion_source.total_conversions_quantity) >= .01
    or abs(pin_promotion_model.total_conversions_value_in_micro_dollar - pin_promotion_source.total_conversions_value_in_micro_dollar) >= .01