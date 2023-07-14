{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('ad_group_report') }}
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

fields as (

    select
        report.date_day,
        advertisers.advertiser_name,
        ad_groups.advertiser_id,
        campaigns.campaign_name,
        campaigns.campaign_status,
        campaigns.campaign_id,
        ad_groups.ad_group_name,
        report.ad_group_id,
        ad_groups.created_at,
        ad_groups.start_time,
        ad_groups.end_time,
        ad_groups.ad_group_status,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='pinterest__ad_group_report_passthrough_metrics', transform = 'sum') }}

    from report
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id
    {{ dbt_utils.group_by(12) }}
)

select *
from fields