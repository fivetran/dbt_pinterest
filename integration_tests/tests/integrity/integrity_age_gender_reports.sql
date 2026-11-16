{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false) and var('pinterest__using_pin_promotion_targeting_report', true)
) }}

{% set metrics = ['spend', 'clicks', 'impressions', 'total_conversions', 'total_conversions_quantity', 'total_conversions_value'] %}

with source_ages as (

    select 
        campaign_id,
        count(*) as row_count
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('stg_pinterest_ads__pin_promotion_targeting_report') }}
    where lower(targeting_type) = 'age_bucket'
    group by 1
),

ages as (

    select 
        campaign_id,
        count(*) as row_count
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('pinterest_ads__campaign_age_report') }}
    group by 1
),

source_genders as (

    select 
        campaign_id,
        count(*) as row_count
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('stg_pinterest_ads__pin_promotion_targeting_report') }}
    where lower(targeting_type) = 'gender'
    group by 1
),

genders as (

    select 
        campaign_id,
        count(*) as row_count
        {% for metric in metrics %}
        , sum({{ metric }}) as {{ metric }}
        {% endfor %}
    from {{ ref('pinterest_ads__campaign_gender_report') }}
    group by 1
),

final as (
    select 
        source_ages.campaign_id

        {% for cte in ['source_ages', 'ages', 'source_genders', 'genders'] %}
            {% for metric in metrics %}
                , {{ cte }}.{{ metric }} as {{ cte }}_{{ metric }}
            {% endfor %}
        {% endfor %}
    from source_ages 
    full outer join ages
        on source_ages.campaign_id = ages.campaign_id
    full outer join source_genders
        on source_ages.campaign_id = source_genders.campaign_id
    full outer join genders
        on source_ages.campaign_id = genders.campaign_id
)

select * 
from final
where 
    {% for metric in metrics %}
        {{ 'or' if not loop.first }} abs(source_ages_{{ metric }} - ages_{{ metric }}) > .0001
        or abs(source_genders_{{ metric }} - genders_{{ metric }}) > .0001
    {% endfor %}