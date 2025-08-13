{{ config(enabled=fivetran_utils.enabled_vars(['ad_reporting__pinterest_ads_enabled','pinterest__using_keywords'])) }}

with report as (

    select *
    from {{ ref('stg_pinterest_ads__keyword_report') }}
), 

advertisers as (

    select *
    from {{ ref('stg_pinterest_ads__advertiser_history') }}
    where is_most_recent_record = True
),

campaigns as (

    select *
    from {{ ref('stg_pinterest_ads__campaign_history') }}
    where is_most_recent_record = True
), 

ad_groups as (

    select *
    from {{ ref('stg_pinterest_ads__ad_group_history') }}
    where is_most_recent_record = True
), 

keywords as (

    select *
    from {{ ref('stg_pinterest_ads__keyword_history') }}
    where is_most_recent_record = True
), 

fields as (

    select
        report.source_relation,
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
        sum(report.impressions) as impressions,
        sum(report.total_conversions) as total_conversions,
        sum(report.total_conversions_quantity) as total_conversions_quantity,
        sum(report.total_conversions_value) as total_conversions_value

        {{ pinterest_ads_persist_pass_through_columns(pass_through_variable='pinterest__keyword_report_passthrough_metrics', identifier='report', transform='sum', coalesce_with=0, exclude_fields=['total_conversions','total_conversions_quantity','total_conversions_value']) }}

    from report
    left join keywords
        on report.keyword_id = keywords.keyword_id
        and report.source_relation = keywords.source_relation
    left join ad_groups
        on keywords.ad_group_id = ad_groups.ad_group_id
        and keywords.source_relation = ad_groups.source_relation
    left join campaigns
        on ad_groups.campaign_id = campaigns.campaign_id
        and ad_groups.source_relation = campaigns.source_relation
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id
        and campaigns.source_relation = advertisers.source_relation
    {{ dbt_utils.group_by(12) }}
)

select *
from fields