{{
    config(
        tags=['area_plans']
    )
}}

select 
    area_plans.id,
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