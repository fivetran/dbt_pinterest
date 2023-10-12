{{ config(enabled=var('ad_reporting__pinterest_ads_enabled', True)) }}

with report as (

    select *
    from {{ var('advertiser_report') }}
), 

advertisers as (

    select *
    from {{ var('advertiser_history') }}
    where is_most_recent_record = True
), 

fields as (

    select
        report.source_relation,
        report.date_day,
        advertisers.advertiser_name,
        report.advertiser_id,
        advertisers.currency_code,
        advertisers.country,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='pinterest__advertiser_report_passthrough_metrics', transform = 'sum') }}

    from report
    left join advertisers
        on report.advertiser_id = advertisers.advertiser_id
        and report.source_relation = advertisers.source_relation
    {{ dbt_utils.group_by(6) }}
)

select *
from fields