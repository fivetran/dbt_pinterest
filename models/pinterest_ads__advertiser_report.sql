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
        report.date_day,
        advertisers.advertiser_name,
        report.advertiser_id,
        advertisers.advertiser_status,
        advertisers.currency_code,
        advertisers.country,
        advertisers.billing_type,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions

        {{ fivetran_utils.persist_pass_through_columns(pass_through_variable='pinterest__advertiser_report_passthrough_metrics', transform = 'sum') }}

    from report
    left join advertisers
        on report.advertiser_id = advertisers.advertiser_id
    {{ dbt_utils.group_by(7) }}
)

select *
from fields