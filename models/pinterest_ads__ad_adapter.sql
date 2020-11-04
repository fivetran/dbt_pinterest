with report as (

    select *
    from {{ var('pin_promotion_report') }}

), pins as (

    select *
    from {{ ref('int_pinterest_ads__most_recent_pin_promotion') }}

), ad_groups as (

    select *
    from {{ ref('int_pinterest_ads__most_recent_ad_group') }}

), campaigns as (

    select *
    from {{ ref('int_pinterest_ads__most_recent_campaign') }}

), joined as (

    select 
        report.date_day as campaign_date,
        report.ad_group_id,
        report.campaign_id,
        report.spend,
        report.impressions,
        report.clicks,
        campaigns.name as campaign_name,
        ad_groups.name as ad_group_name,
        pins.destination_url,
        pins.base_url,
        pins.url_host,
        pins.url_path,
        pins.utm_source,
        pins.utm_medium,
        pins.utm_campaign,
        pins.utm_content,
        pins.utm_term
    from report 
    left join pins 
        on report.pin_promotion_id = pins.pin_promotion_id
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
    left join campaigns 
        on report.campaign_id = campaigns.campaign_id

), aggregates as (

    select         
        {{ dbt_utils.surrogate_key(
            [
                'campaign_date',
                'campaign_id',
                'ad_group_id',
                'destination_url'
            ]
        ) }} as daily_id,

        campaign_date,
        base_url,
        url_host,
        url_path,
        utm_source,
        utm_medium,
        utm_campaign,
        utm_content,
        utm_term,
        campaign_id,
        campaign_name,
        ad_group_id,
        ad_group_name,
        'pinterest ads' as platform,

        sum(clicks) as clicks,
        sum(impressions) as impressions,
        sum(spend) as spend
    from joined
    {{ dbt_utils.group_by(15) }}
    
)

select * 
from aggregates