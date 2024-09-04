# Decision Log
## UTM Report Filtering
This package contains a `pinterest_ads__url_report` which provides daily metrics for your utm compatible ads. It is important to note that not all Ads within Pinterest's `pin_promotion_report` source table leverage utm parameters. Therefore, this package takes an opinionated approach to filter out any records that do not contain utm parameters or leverage a url within the promoted pin.

If you would like to leverage a report that contains all promoted pins and their daily metrics, we would suggest you leverage the `pinterest_ads__ad_report` which does not apply any filtering.

## Pinterest Ads Grains

When working with Pinterest Ads data, here’s how the grains relate to each other and what you can expect in terms of aggregate matching:

#### Advertiser Report:

Grain: This is the highest level of aggregation, representing the overall performance metrics for the entire account under a single advertiser.
Expected Aggregation: Aggregate values should match the sums across all campaigns, ad groups, pin promotions, keywords, and URLs under that advertiser.

#### Campaign Report:

Grain: This is a mid-level aggregation that focuses on individual campaigns under an advertiser. Each campaign aggregates data from multiple ad groups.
Expected Aggregation: Aggregate values within a campaign should match the sums across all ad groups, pin promotions, keywords, and URLs that belong to that campaign. Campaigns under the same advertiser should aggregate up to match the advertiser report.

#### Ad Group Report:

Grain: This is a finer level of aggregation, representing specific ad groups within a campaign. Each ad group aggregates data from multiple pin promotions and keywords.
Expected Aggregation: Aggregate values within an ad group should match the sums across all pin promotions and keywords under that ad group. Ad groups under the same campaign should aggregate up to match the campaign report.

#### Pin Promotion Report:

Grain: This grain is at the level of individual pin promotions within an ad group.
Expected Aggregation: Aggregate values for a pin promotion should aggregate to match the corresponding ad group report. Multiple pin promotions under the same ad group should sum up to match the ad group totals.

#### Keyword Report:

Grain: This is at the level of individual keywords used within ad groups.
Expected Aggregation: Aggregate values for keywords should generally aggregate to match the corresponding ad group report. However, due to how keywords might overlap across ad groups and pin promotions, there might be slight discrepancies.

#### URL Report:

Grain: This focuses on specific URLs that are promoted within ad groups.
Expected Aggregation: Aggregate values should align with the ad group report for the URLs promoted within that ad group.

#### Matching Aggregates:
Advertiser vs. Campaign: Should match up, as campaigns are rolled up to the advertiser level.
Campaign vs. Ad Group: Should match up, as ad groups are rolled up to the campaign level.
Ad Group vs. Pin Promotion: Should match up, as pin promotions are rolled up to the ad group level.
Ad Group vs. Keyword: May not match perfectly due to keyword overlap and variations in tracking methods.
Ad Group vs. URL: Should match up, as URLs within the ad group should aggregate to the ad group total.

Summary:
Higher-level grains (Advertiser, Campaign) should aggregate data from lower levels (Ad Group, Pin Promotion, Keyword, URL) and generally match in totals.
Keyword report can introduce slight discrepancies due to its more granular tracking and the potential for overlap across multiple ads or ad groups.
Pin Promotion and URL reports should typically align with ad group totals, given that they represent specific components within an ad group.
This structure helps ensure that the data is consistent and accurate as it aggregates from the most granular level to the highest level in the advertising funnel.

#### More information on the Keyword Grain:
It's not expected for the `keyword` table values to match up 100% to the `ad_group` table. The `keyword` table typically provides more granular data, focusing on the performance metrics at the keyword level within an ad group. Since multiple keywords can belong to a single ad group, the metrics in the `keyword` table often aggregate differently than those in the `ad group` table.

Here's why the numbers might differ:

The `keyword` table breaks down the performance of individual keywords within an ad group, whereas the `ad group` table aggregates the overall performance metrics for the entire ad group. Multiple keywords can trigger the same impression or click within an ad group, leading to overlap. The `ad group` table would report the aggregate metrics, while the `keyword` table may report them for each keyword, potentially leading to different totals when not aggregated.

Partial Contributions: A keyword might contribute partially to certain metrics within an ad group. For example, the spend associated with a keyword might not be the same as the total spend reported at the ad group level due to allocation or prorated costs across multiple keywords.

Data Allocation: Sometimes, the way costs or conversions are allocated to keywords can differ from how they are allocated at the ad group level, especially if there are shared budgets or complex attribution models in place.