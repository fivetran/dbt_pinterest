# Decision Log
## UTM Report Filtering
This package contains a `pinterest_ads__url_report` which provides daily metrics for your utm compatible ads. It is important to note that not all Ads within Pinterest's `pin_promotion_report` source table leverage utm parameters. Therefore, this package takes an opinionated approach to filter out any records that do not contain utm parameters or leverage a url within the promoted pin.

If you would like to leverage a report that contains all promoted pins and their daily metrics, we would suggest you leverage the `pinterest_ads__ad_report` which does not apply any filtering.

## Why don't metrics add up across different grains (Ex. ad level vs campaign level)?
When aggregating metrics like clicks and spend across different grains, discrepancies can arise due to differences in how data is captured, grouped, or attributed at each grain. For example, certain actions or costs might be attributed differently at the ad, campaign, or ad group level, leading to inconsistencies when rolled up. Additionally, for example, at the keyword grain, where a keyword can belong to multiple ad groups, aggregations can lead to over counting. Conversely, some ads may only be represented at the ad group level, rather than individual ad levels, leading to under counting at the ad grain.

This is a reason why we have broken out the ad reporting packages into separate hierarchical end models (Ad, Ad Group, Campaign, and more). Because if we only used ad-level reports, we could be missing data.