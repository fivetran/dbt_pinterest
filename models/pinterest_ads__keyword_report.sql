with report as (

    select *
    from {{ var('keyword_report') }}
), 

advertisers as (

    select *
    from {{ var('advertiser_history') }}
    where is_most_recent_record = True
),

campaigns as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record = True
), 

ad_groups as (

    select *
    from {{ var('ad_group_history') }}
    where is_most_recent_record = True
), 

keywords as (

    select *
    from {{ var('keyword_history') }}
    where is_most_recent_record = True
), 

fields as (

    select
        report.date_day,
        advertisers.advertiser_name,
        advertisers.advertiser_id,
        campaigns.campaign_name,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        ad_groups.ad_group_id,
        report.keyword_id,
        keywords.match_type,
        keywords.parent_type,
        keywords.keyword_value,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions

        {% for metric in var('google_ads__keyword_report_passthrough_metrics', []) %}
        , sum(report.{{ metric }}) as {{ metric }}
        {% endfor %}

    from report
    left join keywords
        on report.keyword_id = keywords.keyword_id
    left join ad_groups
        on keywords.ad_group_id = ad_groups.ad_group_id
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id
    {{ dbt_utils.group_by(11) }}
)

select *
from fields