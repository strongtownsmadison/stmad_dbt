{{
    config(
        tags=['parcels']
    )
}}

select

    parcel_id,
    parcel_year,
    geom_4326,
    property_use,
    property_class,
    area_name,
    lot_type_1,
    lot_type_2,
    zoning_1,
    neighborhood_primary,
    ward,
    alder_district,
    parcel_address,
    bedrooms,
    current_land_value,
    current_improvement_value,
    current_total_value,
    net_taxes,
    total_taxes,
    total_dwelling_units,
    shape_area,

    case
        when lot_size in (0, 0.01, 1, 6)
            then ST_Area(ST_Transform(geom_4326, 5070)) * 10.7639
        else lot_size
        end as lot_size,

    load_dttm
        
from {{ ref('parcels_fix_condos') }}