{{ config(
    tags="fivetran_validations",
    enabled=var('fivetran_validation_tests_enabled', false)
) }}

with prod as (
    select
        pin_promotion_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_pinterest_ads_prod.pinterest_ads__pin_promotion_report
    group by 1
),

dev as (
    select
        pin_promotion_id,
        sum(clicks) as clicks, 
        sum(impressions) as impressions,
        sum(spend) as spend
    from {{ target.schema }}_pinterest_ads_dev.pinterest_ads__pin_promotion_report
    group by 1
),

final as (
    select 
        prod.pin_promotion_id,
        prod.clicks as prod_clicks,
        dev.clicks as dev_clicks,
        prod.impressions as prod_impressions,
        dev.impressions as dev_impressions,
        prod.spend as prod_spend,
        dev.spend as dev_spend
    from prod
    full outer join dev 
        on dev.pin_promotion_id = prod.pin_promotion_id
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