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
