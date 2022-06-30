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
        advertisers.advertiser_id,
        advertisers.advertiser_status,
        advertisers.currency_code,
        advertisers.country,
        advertisers.billing_type,
        sum(report.spend) as spend,
        sum(report.clicks) as clicks,
        sum(report.impressions) as impressions

        {% for metric in var('google_ads__advertiser_report_passthrough_metrics', []) %}
        , sum(report.{{ metric }}) as {{ metric }}
        {% endfor %}

    from report
    left join advertisers
        on report.advertiser_id = advertisers.advertiser_id
    {{ dbt_utils.group_by(7) }}
)

select *
from fields