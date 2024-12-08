{{
    config(
        tags=['parcels','area_plans']
    )
}}

select

    parcels.parcel_id,
    parcels.parcel_year,
    area_plans.area_plan,
    ST_Area(ST_Intersection(parcels.geom_4326,area_plans.geom_4326)) as intersect_area,
    row_number() over (partition by parcels.parcel_id,parcels.parcel_year order by ST_Area(ST_Intersection(parcels.geom_4326,area_plans.geom_4326)) desc) as intersect_rank
    
from {{ ref('parcels_fix_condos') }} parcels

inner join {{ ref('area_plans_localize_geom') }} area_plans
    on ST_Intersects(parcels.geom_4326,area_plans.geom_4326)
