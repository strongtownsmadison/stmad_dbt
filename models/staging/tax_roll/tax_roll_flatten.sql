{{
    config(
        tags=['tax_roll']
    )
}}

select 
    coalesce(data_json->>'Parcel', data_json->>'PROP ID')::varchar(32) as parcel_id,
    coalesce(data_json->>'Tax Year', data_json->>'TAX YEAR')::int as tax_year,
    coalesce(data_json->>'Prop Location', data_json->>'PROP LOCATION')::varchar(64) as parcel_address,
    coalesce(data_json->>'Assessed Value Land', data_json->>'LAND ASSESSMENT')::numeric(18,2) as assessed_value_land,
    coalesce(data_json->>'Assessed Value Improvement', data_json->>'IMPR ASSESSMENT')::numeric(18,2) as assessed_value_improvement,
    coalesce(data_json->>'Total Assessed Value', data_json->>'TOTAL ASSESSMENT')::numeric(18,2) as total_assessed_value,
    coalesce(data_json->>'Est. Fair Mkt. Land', data_json->>'EST FMV LAND')::numeric(18,2) as est_fair_mkt_land,
    coalesce(data_json->>'Est. Fair Mkt. Improvement', data_json->>'EST FMV IMPR')::numeric(18,2) as est_fair_mkt_improvement,
    coalesce(data_json->>'Total Estimated Fair Market', data_json->>'EST FMV TOTAL')::numeric(18,2) as total_estimated_fair_market,
    coalesce(data_json->>'Current County Net Tax', data_json->>'COUNTY TAX')::numeric(18,2) as current_county_net_tax,
    coalesce(data_json->>'Current City Net Tax', data_json->>'CITY TAX')::numeric(18,2) as current_city_net_tax,
    coalesce(data_json->>'Current School Net Tax', data_json->>'SCHOOL TAX')::numeric(18,2) as current_school_net_tax,
    coalesce(data_json->>'Current MATC Net Tax', data_json->>'MATC TAX')::numeric(18,2) as current_matc_net_tax,
    coalesce(data_json->>'Total Current  Net Tax', data_json->>'NET TAX')::numeric(18,2) as total_current_net_tax,
    coalesce(data_json->>'Total Current Tax', data_json->>'GROSS TAX')::numeric(18,2) as total_current_tax
FROM {{ source('city_of_madison','tax_roll_xlsx') }}