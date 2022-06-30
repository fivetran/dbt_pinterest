with report as (
    select *
    from {{ var('campaign_report') }}
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

fields as (

    select
        report.date_day,
        advertisers.advertiser_name,
        advertisers.advertiser_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        campaigns.campaign_status,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions

        {% for metric in var('google_ads__ad_group_stats_passthrough_metrics', []) %}
        , sum(report.{{ metric }}) as {{ metric }}
        {% endfor %}

    from report
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id
    {{ dbt_utils.group_by(6) }}
)

select *
from fields