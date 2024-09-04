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
        sum(report.impressions) as impressions,
        sum(report.total_conversions) as total_conversions,
        sum(report.total_conversions_quantity) as total_conversions_quantity,
        sum(report.total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar

        {{ pinterest_ads_persist_pass_through_columns(pass_through_variable='pinterest__advertiser_report_passthrough_metrics', identifier='stats', transform='sum', coalesce_with=0, exclude_fields=['total_conversions','total_conversions_quantity','total_conversions_value_in_micro_dollar']) }}

    from report
    left join advertisers
        on cast(report.advertiser_id as {{ dbt.type_string() }}) = cast(advertisers.advertiser_id as {{ dbt.type_string() }})
        and report.source_relation = advertisers.source_relation
    {{ dbt_utils.group_by(6) }}
)

select *
from fields