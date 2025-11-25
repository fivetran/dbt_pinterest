# dbt_pinterest v1.1.0

[PR #50](https://github.com/fivetran/dbt_pinterest/pull/50) includes the following updates:

## Features
  - Increases the required dbt version upper limit to v3.0.0

# dbt_pinterest v1.0.1

[PR #49](https://github.com/fivetran/dbt_pinterest/pull/49) includes the following updates:

## Bugfix
- Added configuration option to conditionally enable the `keyword_report` and `keyword_history` sources based on the `ad_reporting__pinterest_ads_enabled` and `pinterest__using_keywords` variables. This allows for better control when the keyword report and keyword history sources are disabled in your project.

## Contributors
- [@valbelova](https://github.com/valbelova) [#49](https://github.com/fivetran/dbt_pinterest/pull/49)

# dbt_pinterest v1.0.0

[PR #43](https://github.com/fivetran/dbt_pinterest/pull/43) includes the following updates:

## Breaking Changes

### Source Package Consolidation
- Removed the dependency on the `fivetran/pinterest_source` package.
  - All functionality from the source package has been merged into this transformation package for improved maintainability and clarity.
  - If you reference `fivetran/pinterest_source` in your `packages.yml`, you must remove this dependency to avoid conflicts.
  - Any source overrides referencing the `fivetran/pinterest_source` package will also need to be removed or updated to reference this package.
  - Update any pinterest_source-scoped variables to be scoped to only under this package. See the [README](https://github.com/fivetran/dbt_pinterest/blob/main/README.md) for how to configure the build schema of staging models.
- As part of the consolidation, vars are no longer used to reference staging models, and only sources are represented by vars. Staging models are now referenced directly with `ref()` in downstream models.

### dbt Fusion Compatibility Updates
- Updated package to maintain compatibility with dbt-core versions both before and after v1.10.6, which introduced a breaking change to multi-argument test syntax (e.g., `unique_combination_of_columns`).
- Temporarily removed unsupported tests to avoid errors and ensure smoother upgrades across different dbt-core versions. These tests will be reintroduced once a safe migration path is available.
  - Removed all `dbt_utils.unique_combination_of_columns` tests.
  - Removed all `accepted_values` tests.
  - Moved `loaded_at_field: _fivetran_synced` under the `config:` block in `src_pinterest.yml`.

### Under the Hood
- Updated conditions in `.github/workflows/auto-release.yml`.
- Added `.github/workflows/generate-docs.yml`.

# dbt_pinterest v0.13.0

[PR #40](https://github.com/fivetran/dbt_pinterest/pull/40) includes the following updates:

## Breaking Change for dbt Core < 1.9.6
> *Note: This is not relevant to Fivetran Quickstart users.*

Migrated `freshness` from a top-level source property to a source `config` in alignment with [recent updates](https://github.com/dbt-labs/dbt-core/issues/11506) from dbt Core ([Source PR #40](https://github.com/fivetran/dbt_pinterest_source/pull/40)). This will resolve the following deprecation warning that users running dbt >= 1.9.6 may have received:

```
[WARNING]: Deprecated functionality
Found `freshness` as a top-level property of `pinterest_ads` in file
`models/src_pinterest_ads.yml`. The `freshness` top-level property should be moved
into the `config` of `pinterest_ads`.
```

**IMPORTANT:** Users running dbt Core < 1.9.6 will not be able to utilize freshness tests in this release or any subsequent releases, as older versions of dbt will not recognize freshness as a source `config` and therefore not run the tests.

If you are using dbt Core < 1.9.6 and want to continue running Pinterest Ads freshness tests, please elect **one** of the following options:
  1. (Recommended) Upgrade to dbt Core >= 1.9.6
  2. Do not upgrade your installed version of the `pinterest` package. Pin your dependency on v0.12.0 in your `packages.yml` file.
  3. Utilize a dbt [override](https://docs.getdbt.com/reference/resource-properties/overrides) to overwrite the package's `pinterest_ads` source and apply freshness via the [old](https://github.com/fivetran/dbt_pinterest_source/blob/v0.12.0/models/src_pinterest_ads.yml#L11-L13) top-level property route. This will require you to copy and paste the entirety of the `src_pinterest_ads.yml` [file](https://github.com/fivetran/dbt_pinterest_source/blob/v0.12.0/models/src_pinterest_ads.yml#L4-L399) and add an `overrides: pinterest_source` property.

## Under the Hood
- Updated the package maintainer PR template.

# dbt_pinterest v0.12.0
[PR #39](https://github.com/fivetran/dbt_pinterest/pull/39) includes the following updates:

## Schema Changes
9 total changes • 0 possible breaking changes

| Data Model                                                  | Change type | Old name | New name | Notes                                           |
|-------------------------------------------------------------|-------------|----------|----------|-------------------------------------------------|
| [`pinterest_ads__campaign_country_report`](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.pinterest_ads__campaign_country_report) | New Transformation Model | | | New table that represents the daily performance of ads at the country and campaign level. |
| [`pinterest_ads__campaign_region_report`](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.pinterest_ads__campaign_region_report) | New Transformation Model | | | New table that represents the daily performance of ads at the region and campaign level. |
| [`stg_pinterest_ads__pin_promotion_targeting_report`](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.stg_pinterest_ads__pin_promotion_targeting_report) | New Staging Model | | | Uses `pin_promotion_targeting_report` source table |
| [`stg_pinterest_ads__targeting_geo_region`](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.stg_pinterest_ads__targeting_geo_region) | New Staging Model | | | Uses `targeting_geo_region` source table       |
| [`stg_pinterest_ads__targeting_geo`](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.stg_pinterest_ads__targeting_geo) | New Staging Model | | | Uses `targeting_geo` source table              |
| [`stg_pinterest_ads__pin_promotion_targeting_report_tmp`](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.stg_pinterest_ads__pin_promotion_targeting_report_tmp) | New Temp Model | | | Uses `pin_promotion_targeting_report` source table |
| [`stg_pinterest_ads__targeting_geo_region_tmp`](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.stg_pinterest_ads__targeting_geo_region_tmp) | New Temp Model | | | Uses `targeting_geo_region` source table       |
| [`stg_pinterest_ads__targeting_geo_tmp`](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.stg_pinterest_ads__targeting_geo_tmp) | New Temp Model | | | Uses `targeting_geo` source table              |
| [`stg_pinterest_ads__campaign_history`](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.stg_pinterest_ads__campaign_history) | New Columns | | `start_time`, `end_time`, `budget_spend_cap`, `lifetime_spend_cap`, `objective_type` | |


## Features
- Added the following vars to enable/disable the new sources. See the [README](https://github.com/fivetran/dbt_pinterest_ads_source/blob/main/README.md#Step-4-Enable-disable-models-and-sources) for more details.
  - `pinterest__using_pin_promotion_targeting_report`
    - Default is true. Will disable `pinterest_ads__campaign_country_report` and `pinterest_ads__campaign_region_report` if false.
  - `pinterest__using_targeting_geo`
    - Default is true. Will disable `pinterest_ads__campaign_country_report` if false.
  - `pinterest__using_targeting_geo_region`
    - Default is true. Will disable `pinterest_ads__campaign_region_report` if false.
- Added the var `pinterest__pin_promotion_targeting_report_passthrough_metrics` to allow bringing additional metrics through to the `pinterest_ads__campaign_country_report` and `pinterest_ads__campaign_region_report` models. Refer to the [README](https://github.com/fivetran/dbt_pinterest_ads/blob/main/README.md#passing-through-additional-metrics) for more details.

## Under the Hood
- Added seed data for testing new sources
- Updated the `consistency_url_report` test to be at the `advertiser_id` grain instead of `keyword_id`.

## Documentation
- Updated dbt documentation to reflect new tables and column additions.
- Added Quickstart model counts to README. ([#38](https://github.com/fivetran/dbt_pinterest/pull/38))
- Corrected references to connectors and connections in the README. ([#38](https://github.com/fivetran/dbt_pinterest/pull/38))

# dbt_pinterest v0.11.0
[PR #34](https://github.com/fivetran/dbt_pinterest/pull/34) includes the following **BREAKING CHANGE** updates:

## Feature Updates: Native Conversion Support
- We have added the following conversion metrics to each `pinterest_ads` end model:
  - `total_conversions`: The sum of all website conversion events.
  - `total_conversions_quantity`: The total count of items or units involved in conversions.
  - `total_conversions_value` (converted from `total_conversions_value_in_micro_dollar`) Total order value associated with conversions.
- In the event that you were already passing the above fields in via our [passthrough columns](https://github.com/fivetran/dbt_pinterest/blob/main/README.md#passing-through-additional-metrics), the package will dynamically avoid "duplicate column" errors.

> The above new field additions are **breaking changes** for users who were not already bringing in conversion fields via passthrough columns.

## Documentation
- Added more information about the difference in grains and their relationships in the [DECISIONLOG](https://github.com/fivetran/dbt_pinterest/blob/main/DECISIONLOG.md#pinterest-ads-grains).

## Under the hood
- Created `pinterest_ads_persist_pass_through_columns` macro to ensure that the new conversion fields are backwards compatible with users who have already included them via passthrough fields.
- Added integrity and consistency validation tests within `integration_tests` folder for the transformation models (to be used by maintainers only).
- Updated seed data to represent an e-commerce customer scenario.
- Coalesces `spend` with 0 to ensure proper downstream aggregations.

## Contributors
- [Seer Interactive](https://www.seerinteractive.com/?utm_campaign=Fivetran%20%7C%20Models&utm_source=Fivetran&utm_medium=Fivetran%20Documentation)

# dbt_pinterest v0.10.0
[PR #30](https://github.com/fivetran/dbt_pinterest/pull/30) includes the following updates:

## Breaking changes
- Updated the following identifiers for consistency with the source name and compatibility with the union schema feature:

| current  | previous |
|----------|----------|
| pinterest_ads_ad_group_history_identifier | pinterest_ad_group_history_identifier |
| pinterest_ads_campaign_history_identifier | pinterest_campaign_history_identifier |
| pinterest_ads_pin_promotion_report_identifier | pinterest_pin_promotion_report_identifier |
| pinterest_ads_keyword_history_identifier | pinterest_keyword_history_identifier |
| pinterest_ads_keyword_report_identifier | pinterest_keyword_report_identifier |
| pinterest_ads_ad_group_report_identifier | pinterest_ad_group_report_identifier |
| pinterest_ads_campaign_report_identifier | pinterest_campaign_report_identifier |
| pinterest_ads_advertiser_history_identifier | pinterest_advertiser_history_identifier |
| pinterest_ads_advertiser_report_identifier | pinterest_advertiser_report_identifier |

- If you are using the previous identifier, be sure to update to the current version!

## Feature update 🎉
- Unioning capability! This adds the ability to union source data from multiple pinterest connectors. Refer to the [Union Multiple Connectors README section](https://github.com/fivetran/dbt_pinterest/blob/main/README.md#union-multiple-connectors) for more details.

## Under the hood 🚘
- In the source package, updated tmp models to union source data using the `fivetran_utils.union_data` macro. 
- To distinguish which source each field comes from, added `source_relation` column in each staging and downstream model and applied the `fivetran_utils.source_relation` macro.
  - The `source_relation` column is included in all joins in the transform package. 
- Updated tests to account for the new `source_relation` column.

# dbt_pinterest v0.9.0

# Pinterest Ads v5 Upgrade
## 🚨 Breaking Changes 🚨:
[PR #26](https://github.com/fivetran/dbt_pinterest/pull/26) introduces the following changes:

- Following Pinterest Ads deprecating the v4 API on June 30, 2023 in place of v5, the Pinterest Ads Fivetran connector now leverages the Pinterest v5 API. The following fields have been deprecated/introduced:

| **Model** | **Removed**  | **New**   |
|---|---|---|
|  [pinterest_ads__advertiser_report](https://fivetran.github.io/dbt_pinterest/#!/model/model.pinterest.pinterest_ads__advertiser_report) | `billing_type`, `status`  |   |

## Under the Hood:
- Following the v5 upgrade, `ad_account_id` is a net new field within `ad_group_history` and `pin_promotion_history` source tables synced via the connector. However, to keep these fields standard across the package, we have renamed them as `advertiser_id` within the respective staging models.
- Seed data were updated with new/removed fields following the v5 upgrade


# dbt_pinterest v0.8.0
- This was an accidental release

# dbt_pinterest v0.7.1
## Features
- Addition of the `pinterest__using_keywords` (default=`true`) variable that allows users to disable the relevant keyword reports in the downstream Pinterest models if they are not used. ([#25](https://github.com/fivetran/dbt_pinterest/pull/25))

## Under the Hood:
- Incorporated the new `fivetran_utils.drop_schemas_automation` macro into the end of each Buildkite integration test job. ([PR #24](https://github.com/fivetran/dbt_pinterest/pull/24))
- Updated the pull request [templates](/.github). ([PR #24](https://github.com/fivetran/dbt_pinterest/pull/24))

# dbt_pinterest v0.7.0

## 🚨 Breaking Changes 🚨:
[PR #22](https://github.com/fivetran/dbt_pinterest/pull/22) includes the following breaking changes:
- Dispatch update for dbt-utils to dbt-core cross-db macros migration. Specifically `{{ dbt_utils.<macro> }}` have been updated to `{{ dbt.<macro> }}` for the below macros:
    - `any_value`
    - `bool_or`
    - `cast_bool_to_text`
    - `concat`
    - `date_trunc`
    - `dateadd`
    - `datediff`
    - `escape_single_quotes`
    - `except`
    - `hash`
    - `intersect`
    - `last_day`
    - `length`
    - `listagg`
    - `position`
    - `replace`
    - `right`
    - `safe_cast`
    - `split_part`
    - `string_literal`
    - `type_bigint`
    - `type_float`
    - `type_int`
    - `type_numeric`
    - `type_string`
    - `type_timestamp`
    - `array_append`
    - `array_concat`
    - `array_construct`
- For `current_timestamp` and `current_timestamp_in_utc` macros, the dispatch AND the macro names have been updated to the below, respectively:
    - `dbt.current_timestamp_backcompat`
    - `dbt.current_timestamp_in_utc_backcompat`
- Dependencies on `fivetran/fivetran_utils` have been upgraded, previously `[">=0.3.0", "<0.4.0"]` now `[">=0.4.0", "<0.5.0"]`.

## 🎉 Features 🎉
- For use in the [dbt_ad_reporting package](https://github.com/fivetran/dbt_ad_reporting), users can now allow records having nulls in url fields to be included in the `ad_reporting__url_report` model. See the [dbt_ad_reporting README](https://github.com/fivetran/dbt_ad_reporting) for more details ([#23](https://github.com/fivetran/dbt_pinterest/pull/23)).
## 🚘 Under the Hood 🚘
- Disabled the `not_null` test for `pinterest_ads__url_report` when null urls are allowed ([#23](https://github.com/fivetran/dbt_pinterest/pull/23)).


# dbt_pinterest v0.6.0
PR [#21](https://github.com/fivetran/dbt_pinterest/pull/21) includes the following changes:
## 🚨 Breaking Changes 🚨
- The `pin_promotion_report_pass_through_metric` variable has been renamed to `pinterest__pin_promotion_report_passthrough_metrics`.
- The declaration of passthrough variables within your root `dbt_project.yml` has changed. To allow for more flexibility and better tracking of passthrough columns, you will now want to define passthrough metrics in the following format:
> This applies to all passthrough metrics within the `dbt_pinterest` package and not just the `pinterest__pin_promotion_report_passthrough_metrics` example.
```yml
vars:
  pinterest__pin_promotion_report_passthrough_metrics:
    - name: "my_field_to_include" # Required: Name of the field within the source.
      alias: "field_alias" # Optional: If you wish to alias the field within the staging model.
```
- The `pinterest_ads__ad_adapter` has been renamed to `pinterest_ads__url_report`.
- The `pinterest_ads__ad_group_ad_report` has been renamed to `pinterest_ads__ad_group_report`.
- The `pinterest_ads__campaign_ad_report` has been renamed to `pinterest_ads__campaign_report`.
## 🎉 Feature Enhancements 🎉
- Addition of the following new end models: 
  - `pinterest_ads__pin_promotion_report`
    - Each record in this table represents the daily performance at the pin level.
  - `pinterest_ads__advertiser_report`
    - Each record in this table represents the daily performance at the advertiser level.
  - `pinterest_ads__keyword_report`
    - Each record in this table represents the daily performance at the ad group level for keywords.

- Inclusion of additional passthrough metrics: 
  - `pinterest__ad_group_report_passthrough_metrics`
  - `pinterest__campaign_report_passthrough_metrics`
  - `pinterest__advertiser_report_passthrough_metrics`
  - `pinterest__keyword_report_passthrough_metrics`

- README updates for easier navigation and use of the package. 
- Included grain uniqueness tests for each end model. 

## Contributors
- [@bnealdefero](https://github.com/bnealdefero) [#21](https://github.com/fivetran/dbt_pinterest/pull/21)
# dbt_pinterest v0.5.0
🎉 dbt v1.0.0 Compatibility 🎉
## 🚨 Breaking Changes 🚨
- Adjusts the `require-dbt-version` to now be within the range [">=1.0.0", "<2.0.0"]. Additionally, the package has been updated for dbt v1.0.0 compatibility. If you are using a dbt version <1.0.0, you will need to upgrade in order to leverage the latest version of the package.
  - For help upgrading your package, I recommend reviewing this GitHub repo's Release Notes on what changes have been implemented since your last upgrade.
  - For help upgrading your dbt project to dbt v1.0.0, I recommend reviewing dbt-labs [upgrading to 1.0.0 docs](https://docs.getdbt.com/docs/guides/migration-guide/upgrading-to-1-0-0) for more details on what changes must be made.
- Upgrades the package dependency to refer to the latest `dbt_pinterest_source`. Additionally, the latest `dbt_pinterest_source` package has a dependency on the latest `dbt_fivetran_utils`. Further, the latest `dbt_fivetran_utils` package also has a dependency on `dbt_utils` [">=0.8.0", "<0.9.0"].
  - Please note, if you are installing a version of `dbt_utils` in your `packages.yml` that is not in the range above then you will encounter a package dependency error.

# dbt_pinterest v0.1.0 -> v0.4.0
Refer to the relevant release notes on the Github repository for specific details for the previous releases. Thank you!
