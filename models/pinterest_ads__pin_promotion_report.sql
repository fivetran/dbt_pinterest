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
        pins.creative_type,
        pins.pin_promotion_id,
        pins.pin_name,
        pins.pin_status,
        pins.destination_url,
        pins.base_url,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.spend) as spend

        {% for metric in var('pinterest__pin_promotion_report_passthrough_metrics',[]) %}
        , sum({{ report.metric }}) as {{ metric }}
        {% endfor %}

    from report 
    left join pins 
        on report.pin_promotion_id = pins.pin_promotion_id
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
    left join campaigns 
        on report.campaign_id = campaigns.campaign_id
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id

    {{ dbt_utils.group_by(15) }}
)

select * 
from joined