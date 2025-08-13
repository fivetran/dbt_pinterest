{% docs _fivetran_synced %} Timestamp of when a record was last synced. {% enddocs %}

{% docs is_most_recent_record %} Boolean representing whether the record is the most recent version of the object. {% enddocs %}

{% docs date_day %} The performance date of the record. {% enddocs %}

{% docs ad_group_id %} The ID of the related Ad group. {% enddocs %}

{% docs country_id %} The ID of the targeted country. {% enddocs %}

{% docs region_id %} The ID of the targeted region. {% enddocs %}

{% docs pin_promotion_id %} The ID of the related Pin promotion. {% enddocs %}

{% docs campaign_id %} The ID of the related Campaign. {% enddocs %}

{% docs ad_account_id %} The ID of the related Advertiser. {% enddocs %}

{% docs advertiser_id %} The ID of the related Advertiser. {% enddocs %}

{% docs impressions %} The number of paid and earned impressions that occurred on the day of the record. {% enddocs %}

{% docs clicks %} The number of paid and earned clicks that occurred on the day of the record. {% enddocs %}

{% docs spend %} The amount of spend that occurred on the day of the record. {% enddocs %}

{% docs updated_at %} Timestamp of when a record was last updated. {% enddocs %}

{% docs created_at %} Timestamp of when a record was created. {% enddocs %}

{% docs spend_in_micro_dollar %} The amount of spend in micro dollars that occurred on the day of the record. {% enddocs %}

{% docs clickthrough_1 %} The number of paid pin clicks that occurred on the day of the record. {% enddocs %}

{% docs clickthrough_2 %} The number of earned outbound clicks that occurred on the day of the record. {% enddocs %}

{% docs impression_1 %} The number of paid pin impressions that occurred on the day of the record. {% enddocs %}

{% docs impression_2 %} The number of earned pin impressions that occurred on the day of the record. {% enddocs %}

{% docs source_relation %}The source of the record if the unioning functionality is being used. If not this field will be empty.{% enddocs %}

{% docs total_conversions %}
This is the sum of all website conversions, otherwise known as the number of conversion events. For example, if you track sign-ups and checkouts on your website, it's the sum of all sign-ups and checkouts attributed from clicks, engagements, and views on Pinterest. Example: If a user clicks on a Pinterest ad and completes two different conversion actions (e.g., signs up and checks out), this would be counted as 2 total conversions.
{% enddocs %}

{% docs total_conversions_quantity %}
Refers to the total count of items or units involved in the conversions. This metric is often more granular and relates to the specific quantity of products or services purchased or actions taken. Example: If a single checkout includes three items, the total_conversions_quantity would be 3, even though it counts as one total_conversion.
{% enddocs %}

{% docs total_conversions_value_in_micro_dollar %}
Total conversions order value. The total value of the conversions, calculated by summing up the revenue or order values attributed to conversions. The value is expressed in microdollars, where one microdollar is one-millionth of a US dollar. Example: If the total order value from conversions is $50,000, this would be represented as 50,000,000,000 microdollars.
{% enddocs %}

{% docs total_conversions_value %}
Total conversions order value. The total value of the conversions, calculated by summing up the revenue or order values attributed to conversions. Converted from the source `total_conversions_value_in_micro_dollar` field.
{% enddocs %}
