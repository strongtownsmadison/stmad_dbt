{{
    config(
        tags=['area_plans']
    )
}}
/*
with parcel_info as (
    select 
        area_plans.area_plan,
        area_plans.geom_4326,
        parcels.parcel_year,

        count(parcels.parcel_id) as total_parcels,
        sum(parcels.bedrooms) as total_bedrooms,
        sum(parcels.current_land_value) as total_land_value,
        sum(parcels.current_improvement_value) as total_improvement_value,
        sum(parcels.current_total_value) as total_value,
        sum(parcels.net_taxes) as total_net_taxes,
        sum(parcels.total_taxes) as total_taxes,
        sum(parcels.total_dwelling_units) as total_dwelling_units,
        sum(parcels.lot_size) as total_area,
        sum(parcels.total_taxes) / sum(parcels.lot_size) as avg_taxes_per_sqft

    from {{ ref('area_plans_localize_geom') }} area_plans
    left outer join {{ ref('fact_parcels') }} parcels
        on area_plans.area_plan = parcels.area_plan
    group by area_plans.id,
        area_plans.area_plan,
        area_plans.geom_4326,
        parcels.parcel_year
),

street_info as (
    select
        area_plans.area_plan,
        area_plans.geom_4326,
        streets.street_year,
        
        sum(streets.street_width * streets.intersect_street_length) as total_street_sqft,
        sum(streets.city_maintains * streets.street_width * streets.intersect_street_length) as total_city_maint_street_sqft,
        sum(streets.intersect_street_length * streets.speed_limit) / sum(streets.intersect_street_length) as avg_speed_limit,
        ST_Union(streets.intersect_geom_4326) as streets_geom_4326,
        ST_Union(case when city_maintains = 1 then streets.intersect_geom_4326 else null end) as city_maint_streets_geom_4326

    from {{ ref('area_plans_localize_geom') }} area_plans
    left outer join {{ ref('streets_join_area_plans' )}} streets
        on area_plans.area_plan = streets.area_plan
    group by area_plans.area_plan,
        area_plans.geom_4326,
        streets.street_year
)

select
    parcel_info.area_plan,
    parcel_info.parcel_year as year_number,
    parcel_info.geom_4326,
    parcel_info.total_parcels,
    parcel_info.total_bedrooms,
    parcel_info.total_land_value,
    parcel_info.total_improvement_value,
    parcel_info.total_value,
    parcel_info.total_net_taxes,
    parcel_info.total_taxes,
    parcel_info.total_dwelling_units,
    parcel_info.total_area,
    parcel_info.avg_taxes_per_sqft,

    street_info.total_street_sqft,
    street_info.total_city_maint_street_sqft,
    street_info.avg_speed_limit,
    street_info.streets_geom_4326,
    street_info.city_maint_streets_geom_4326,

    parcel_info.total_taxes / street_info.total_city_maint_street_sqft as taxes_per_city_maint_street_sqft

from parcel_info
left outer join street_info
    on parcel_info.area_plan = street_info.area_plan
    and parcel_info.parcel_year = street_info.street_year
*/

{{ generate_fact_overlay('area_plans_localize_geom','area_plans','area_plan') }}