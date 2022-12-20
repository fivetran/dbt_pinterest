{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('pin_promotion_report') }}
), 

pins as (

    select *
    from {{ var('pin_promotion_history') }}
    where is_most_recent_record = True
), 

ad_groups as (

    select *
    from {{ var('ad_group_history') }}
    where is_most_recent_record = True
), 

campaigns as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record = True
),

advertisers as (

    select *
    from {{ var('advertiser_history') }}
    where is_most_recent_record = True
), 

joined as (

    select
        report.date_day,
        campaigns.advertiser_id,
        advertisers.advertiser_name,
        report.campaign_id,
        campaigns.campaign_name,
        campaigns.campaign_status,
        report.ad_group_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_status,
        pins.destination_url,
        pins.creative_type,
        report.pin_promotion_id,
        pins.pin_name,
        pins.pin_status,
        pins.base_url,
        pins.url_host,
        pins.url_path,
        pins.utm_source,
        pins.utm_medium,
        pins.utm_campaign,
        pins.utm_content,
        pins.utm_term,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='pinterest__pin_promotion_report_passthrough_metrics', transform = 'sum') }}

    from report 
    left join pins 
        on report.pin_promotion_id = pins.pin_promotion_id
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
    left join campaigns 
        on report.campaign_id = campaigns.campaign_id
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id

    {% if var('ad_reporting__url_report__using_null_filter', True) %}
    where pins.destination_url is not null
    {% endif %}

    {{ dbt_utils.group_by(22) }}
)

select * 
from joined