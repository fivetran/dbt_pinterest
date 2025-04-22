{{ config(enabled=fivetran_utils.enabled_vars(['ad_reporting__pinterest_ads_enabled','pinterest_ads_pin_promotion_targeting_report_enabled', 'pinterest_ads_targeting_geo_enabled'])) }}

with report as (
    select *
    from {{ var('pin_promotion_targeting_report') }}
    where lower(targeting_type) = 'geo'
),

campaigns as (

    select *
    from {{ var('campaign_history') }}
    where is_most_recent_record = True
),

regions as (
    select *
    from {{ var('targeting_geo_region') }}
),

fields as (

    select
        report.source_relation,
        report.date_day,
        regions.region_name,
        regions.region_id,
        regions.country_id,
        campaigns.campaign_name,
        report.campaign_id,
        campaigns.campaign_status,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.total_conversions) as total_conversions,
        sum(report.total_conversions_quantity) as total_conversions_quantity,
        sum(report.total_conversions_value) as total_conversions_value

        {{ pinterest_ads_persist_pass_through_columns(pass_through_variable='pinterest__pin_promotion_targeting_report_passthrough_metrics', identifier='report', transform='sum', coalesce_with=0, exclude_fields=['total_conversions','total_conversions_quantity','total_conversions_value']) }}

    from report
    left join campaigns
        on report.campaign_id = campaigns.campaign_id
        and report.source_relation = campaigns.source_relation
    left join regions
        on report.targeting_value = regions.region_id
        and report.source_relation = regions.source_relation
    {{ dbt_utils.group_by(8) }}
)

select *
from fields