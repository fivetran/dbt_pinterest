{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        keyword_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(total_conversions) as total_conversions,
        sum(total_conversions_quantity) as total_conversions_quantity,
        sum(total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar
    from {{ target.schema }}_pinterest_ads_prod.pinterest_ads__keyword_report
    group by 1
),

dev as (
    select
        keyword_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend,
        sum(total_conversions) as total_conversions,
        sum(total_conversions_quantity) as total_conversions_quantity,
        sum(total_conversions_value_in_micro_dollar) as total_conversions_value_in_micro_dollar
    from {{ target.schema }}_pinterest_ads_dev.pinterest_ads__keyword_report
    group by 1
),

final as (
    select 
        prod.keyword_id,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend,
        prod.total_conversions as prod_total_conversions,
        dev.total_conversions as dev_total_conversions,
        prod.total_conversions_quantity as prod_total_conversions_quantity,
        dev.total_conversions_quantity as dev_total_conversions_quantity,
        prod.total_conversions_value_in_micro_dollar as prod_total_conversions_value_in_micro_dollar,
        dev.total_conversions_value_in_micro_dollar as dev_total_conversions_value_in_micro_dollar
    from prod
    full outer join dev 
        on dev.keyword_id = prod.keyword_id
)

select *
from final
where
    abs(prod_clicks - dev_clicks) >= .01
    or abs(prod_impressions - dev_impressions) >= .01
    or abs(prod_spend - dev_spend) >= .01
    or abs(prod_total_conversions - dev_total_conversions) >= .01
    or abs(prod_total_conversions_quantity - dev_total_conversions_quantity) >= .01
    or abs(prod_total_conversions_value_in_micro_dollar - dev_total_conversions_value_in_micro_dollar) >= .01