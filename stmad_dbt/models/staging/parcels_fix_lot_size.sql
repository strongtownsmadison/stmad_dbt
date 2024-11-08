select

    parcel_no,
    parcel_year,
    geom,
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
    current_total,
    net_taxes,
    total_taxes,
    total_dwelling_units,
    shape_area,

    case
        when lot_size in (0, 0.01, 1, 6)
            then ST_Area(ST_Transform(geom, 5070)) * 10.7639
        else lot_size
        end as lot_size
        
from {{ ref('parcels_fix_condos') }}