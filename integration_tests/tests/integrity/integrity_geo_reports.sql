{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

{% set metrics = ['spend', 'clicks', 'impressions', 'total_conversions', 'total_conversions_quantity', 'total_conversions_value'] %}

with source_countries as (

    select 
        campaign_id,
        count(*) as row_count
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('stg_pinterest_ads__pin_promotion_targeting_report') }}
    where lower(targeting_type) = 'country'
    group by 1
),

countries as (

    select 
        campaign_id,
        count(*) as row_count
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('pinterest_ads__campaign_country_report') }}
    group by 1
),

source_regions as (

    select 
        campaign_id,
        count(*) as row_count
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('stg_pinterest_ads__pin_promotion_targeting_report') }}
    where lower(targeting_type) = 'region'
    group by 1
),

regions as (

    select 
        campaign_id,
        count(*) as row_count
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('pinterest_ads__campaign_region_report') }}
    group by 1
),

final as (
    select 
        source_countries.campaign_id

        {% for cte in ['source_countries', 'countries', 'source_regions', 'regions'] %}
            {% for metric in metrics %}
                , {{ cte }}.{{ metric }} as {{ cte }}_{{ metric }}
            {% endfor %}
        {% endfor %}
    from source_countries 
    full outer join countries
        on source_countries.campaign_id = countries.campaign_id
    full outer join source_regions
        on source_countries.campaign_id = source_regions.campaign_id
    full outer join regions
        on source_countries.campaign_id = regions.campaign_id
)

select * 
from final
where 
    {% for metric in metrics %}
        {{ 'or' if not loop.first }} abs(source_countries_{{ metric }} - countries_{{ metric }}) > .0001
        or abs(source_regions_{{ metric }} - regions_{{ metric }}) > .0001
    {% endfor %}