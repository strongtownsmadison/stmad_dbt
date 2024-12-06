{{
    config(
        tags=['parcels']
    )
}}

select

    parcels.parcel_id,
    parcels.parcel_year,
    geo.name as area_plan,
    ST_Area(ST_Intersection(parcels.geom,geo.geometry)) as intersect_area,
    row_number() over (partition by parcels.parcel_id,parcels.parcel_year order by ST_Area(ST_Intersection(parcels.geom,geo.geometry)) desc) as intersect_rank

from {{ ref('parcels_fix_condos') }} parcels

inner join {{ source('public','geometries') }} geo
    on ST_Intersects(parcels.geom,geo.geometry)
    --Temporary logic to remove duplicate and TOD overlay
    and geo.name <> 'TOD'
    and geo.id <> 3
