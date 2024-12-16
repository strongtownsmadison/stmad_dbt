{{
    config(
        tags=['tax_roll']
    )
}}

select
    parcel_id,
    tax_year,
    coalesce(parcel_address,
        first_value(parcel_address) over (partition by parcel_id order by tax_year desc rows between unbounded preceding and current row)
        )
        as parcel_address,
    assessed_value_land,
    assessed_value_improvement,
    total_assessed_value,
    est_fair_mkt_land,
    est_fair_mkt_improvement,
    total_estimated_fair_market,
    current_county_net_tax,
    current_city_net_tax,
    current_school_net_tax,
    current_matc_net_tax,
    total_current_net_tax,
    total_current_tax
from {{ ref('tax_roll_flatten') }}