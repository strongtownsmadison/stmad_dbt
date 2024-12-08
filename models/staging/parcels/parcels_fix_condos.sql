{{
    config(
        tags=['parcels']
    )
}}

with 
agg_cte as (

    select 
        parcels.x_ref_parcel as parcel_id,
        parcels.parcel_year,

        mode() within group (order by parcels.property_class) as property_class,
        mode() within group (order by parcels.property_use) as property_use,
        mode() within group (order by parcels.area_name) as area_name,
        mode() within group (order by parcels.lot_type_1) as lot_type_1,
        mode() within group (order by parcels.lot_type_2) as lot_type_2,
        mode() within group (order by parcels.zoning_1) as zoning_1,
        mode() within group (order by parcels.neighborhood_primary) as neighborhood_primary,
        parcels.ward,
        parcels.alder_district,
        parcels.geom_4326,
        min(parcels.parcel_address) as parcel_address,
        sum(parcels.bedrooms) as bedrooms,
        sum(parcels.current_land) as current_land_value,
        sum(parcels.current_impr) as current_improvement_value,
        sum(parcels.current_total) as current_total_value,
        sum(parcels.net_taxes) as net_taxes,
        sum(parcels.total_taxes) as total_taxes,
        max(parcels.lot_size) as lot_size,
        max(parcels.shape_area) as shape_area,
        sum(parcels.total_dwelling_units) as total_dwelling_units

    from {{ ref('parcels_column_rename') }} parcels

    group by x_ref_parcel,
        parcel_year,
        ward,
        alder_district,
        geom_4326
)

select
    parcel_id,
    parcel_year,

    property_class,
    area_name,
    lot_type_1,
    lot_type_2,
    zoning_1,
    neighborhood_primary,
    
    --Clean up property uses
    case
        when property_use ilike '%apartment%' 
                or property_use in ('2 Unit','3 To 7 Unit','Condominium -apt')
            then 'Multifamily'
        when property_use ilike any (array['warehouse%','warehse%'])
            then 'Warehouse'
        when property_use ilike 'store%'
            then 'Store'
        when property_use ilike 'station%'
            then 'Station'
        else property_use
        end as property_use,

    ward,
    alder_district,
    geom_4326,
    parcel_address,
    bedrooms,
    current_land_value,
    current_improvement_value,
    current_total_value,
    net_taxes,
    total_taxes,
    lot_size,
    shape_area,
    total_dwelling_units

from agg_cte