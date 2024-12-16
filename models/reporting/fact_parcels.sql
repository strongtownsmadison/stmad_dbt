{{
    config(
        tags=['parcels'],
        index={'columns':['parcel_id','parcel_year'],'unique': True}
    )
}}

select
    parcels.parcel_id,
    parcels.parcel_year,
    parcels.geom_4326,
    parcels.property_use,
    parcels.property_class,
    parcels.area_name,
    parcels.lot_type_1,
    parcels.lot_type_2,
    parcels.zoning_1,
    parcels.neighborhood_primary,
    parcels.ward,
    --parcels.alder_district,
    parcels.parcel_address,
    parcels.bedrooms,
    parcels.current_land_value,
    parcels.current_improvement_value,
    parcels.current_total_value,
    parcels.net_taxes,
    parcels.total_taxes,
    parcels.total_dwelling_units,
    parcels.shape_area,
    parcels.lot_size,
    parcels.total_taxes / parcels.lot_size as taxes_per_sqft,
    area_plans.area_plan,
    alder_districts.alder_district
from {{ ref('parcels_fix_lot_size') }} parcels
left outer join {{ ref('parcels_join_area_plans') }} area_plans
    on parcels.parcel_id = area_plans.parcel_id
    and parcels.parcel_year = area_plans.parcel_year
    and area_plans.intersect_rank = 1
left outer join {{ ref('parcels_join_alder_districts') }} alder_districts
    on parcels.parcel_id = alder_districts.parcel_id
    and parcels.parcel_year = alder_districts.parcel_year
    and alder_districts.intersect_rank = 1


