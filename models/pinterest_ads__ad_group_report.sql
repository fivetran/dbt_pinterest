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
        report.source_relation,
        report.date_day,
        advertisers.advertiser_name,
        advertisers.advertiser_id,
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
        sum(report.impressions) as impressions,
        sum(report.total_conversions) as total_conversions,
        sum(report.total_conversions_quantity) as total_conversions_quantity,
        sum(report.total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar

        {{ pinterest_ads_persist_pass_through_columns(pass_through_variable='pinterest__ad_group_report_passthrough_metrics', identifier='report', transform='sum', coalesce_with=0, exclude_fields=['total_conversions','total_conversions_quantity','total_conversions_value_in_micro_dollar']) }}

    from report
    left join ad_groups
        on report.ad_group_id = ad_groups.ad_group_id
        and report.source_relation = ad_groups.source_relation
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id
        and ad_groups.source_relation = campaigns.source_relation
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id
        and campaigns.source_relation = advertisers.source_relation
    {{ dbt_utils.group_by(13) }}
)

select *
from fields