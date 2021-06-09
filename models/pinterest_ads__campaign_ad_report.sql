with adapter as (

    select *
    from {{ ref('pinterest_ads__ad_adapter') }}

), grouped as (

    select 
        campaign_date,
        campaign_id,
        campaign_name,
        sum(spend) as spend,
        sum(clicks) as clicks, 
        sum(impressions) as impressions
        {% for metric in var('pin_promotion_report_pass_through_metric') %}
            , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from adapter
    {{ dbt_utils.group_by(3) }}

)

select *
from grouped