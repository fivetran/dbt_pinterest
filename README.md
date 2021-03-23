# Pinterest Ads ([docs](https://fivetran-dbt-pinterest.netlify.app/#!/overview))

This package models Pinterest Ads data from [Fivetran's connector](https://fivetran.com/docs/applications/pinterest-ads). It uses data in the format described by [this ERD](https://fivetran.com/docs/applications/pinterest-ads#schemainformation).

This package transforms the core ad object tables into analytics-ready models, including an 'ad adapter' model that can be easily unioned in to other ad platform packages to get a single view.

> The Pinterest Ads dbt package is compatible with BigQuery, Redshift, and Snowflake.

## Models

This package contains transformation models, designed to work simultaneously with our [Pinterest Ads source package](https://github.com/fivetran/dbt_pinterest_source). A dependency on the source package is declared in this package's `packages.yml` file, so it will automatically download when you run `dbt deps`. The primary outputs of this package are described below.

| **model**                         | **description**                                                                                                        |
| --------------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| pinterest_ads__ad_adapter         | Each record represents the daily ad performance of each pin promotion, including information about its UTM parameters. |
| pinterest_ads__ad_group_ad_report | Each record represents the daily ad performance of each add group.                                                     |
| pinterest_ads__campaign_ad_report | Each record represents the daily ad performance of each campaign.                                                      |

## Installation Instructions
Check [dbt Hub](https://hub.getdbt.com/) for the latest installation instructions, or [read the dbt docs](https://docs.getdbt.com/docs/package-management) for more information on installing packages.

## Configuration
By default, this package will look for your Pinterest Ads data in the `pinterest_ads` schema of your [target database](https://docs.getdbt.com/docs/running-a-dbt-project/using-the-command-line-interface/configure-your-profile). If this is not where your Pinterest Ads data is, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
config-version: 2

vars:
    pinterest_database: your_database_name
    pinterest_schema: your_schema_name 
```

For additional source model configurations, see our [Pinterest Ads source package](https://github.com/fivetran/dbt_pinterest_source).

### Changing the Build Schema
By default this package will build the Pinterest Ads staging models within a schema titled (<target_schema> + `_stg_pinterest`) and the Pinterest Ads final models with a schema titled (<target_schema> + `_pinterest`) in your target database. If this is not where you would like your modeled Pinterest Ads data to be written to, add the following configuration to your `dbt_project.yml` file:

```yml
# dbt_project.yml

...
models:
  pinterest:
    +schema: my_new_schema_name # leave blank for just the target_schema
  pinterest_source:
    +schema: my_new_schema_name # leave blank for just the target_schema
```

## Contributions

Additional contributions to this package are very welcome! Please create issues
or open PRs against `master`. Check out 
[this post](https://discourse.getdbt.com/t/contributing-to-a-dbt-package/657) 
on the best workflow for contributing to a package.

## Resources:
- Find all of Fivetran's pre-built dbt packages in our [dbt hub](https://hub.getdbt.com/fivetran/)
- Provide [feedback](https://www.surveymonkey.com/r/DQ7K7WW) on our existing dbt packages or what you'd like to see next
- Learn more about Fivetran [here](https://fivetran.com/docs)
- Check out [Fivetran's blog](https://fivetran.com/blog)
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [chat](http://slack.getdbt.com/) on Slack for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
