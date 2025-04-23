{{ config(enabled=fivetran_utils.enabled_vars(['ad_reporting__pinterest_ads_enabled','pinterest_ads_pin_promotion_targeting_report_enabled', 'pinterest_ads_targeting_geo_region_enabled'])) }}

with report as (
    select *
    from {{ var('pin_promotion_targeting_report') }}
    where lower(targeting_type) = 'country'
),

countries as (
    select *
    from {{ var('targeting_geo') }}
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
        report.source_relation,
        report.date_day,
        countries.country_name,
        countries.country_id,
        report.campaign_id,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions,
        sum(report.total_conversions) as total_conversions,
        sum(report.total_conversions_quantity) as total_conversions_quantity,
        sum(report.total_conversions_value) as total_conversions_value

        {{ pinterest_ads_persist_pass_through_columns(pass_through_variable='pinterest__pin_promotion_targeting_report_passthrough_metrics', identifier='report', transform='sum', coalesce_with=0) }}

    from report
    left join countries
        on report.targeting_value = countries.country_id
        and report.source_relation = countries.source_relation

    {{ dbt_utils.group_by(5) }}
),

final as (
    select
        fields.*,
        advertisers.advertiser_name,
        advertisers.advertiser_id,
        campaigns.campaign_name,
        campaigns.campaign_status,
        campaigns.budget_spend_cap,
        campaigns.lifetime_spend_cap,
        campaigns.created_at,
        campaigns.default_ad_group_budget_in_micro_currency,
        campaigns.end_time,
        campaigns.is_campaign_budget_optimization,
        campaigns.is_flexible_daily_budgets,
        campaigns.objective_type,
        campaigns.start_time
    from fields
    left join campaigns
        on fields.campaign_id = campaigns.campaign_id
        and fields.source_relation = campaigns.source_relation
    left join advertisers
        on campaigns.advertiser_id = advertisers.advertiser_id
        and campaigns.source_relation = advertisers.source_relation
)

select *
from final