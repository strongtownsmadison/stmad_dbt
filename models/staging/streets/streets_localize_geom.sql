{{
    config(
        tags=['streets']
    )
}}

select 
    objectid as street_id,
    date_part('year',load_dttm) as street_year,
    geom as geom_4326,
    speed_limit,
    surface_width as street_width,
    lanes as street_lanes,
    shapestlength as street_length,
    truck_route as is_truck_route,
    case when sidewalk in ('1','2','3') then 1 else 0 end as has_sidewalk,
    median_width,
    case when oneway::int > 0 then 1 else 0 end as is_oneway,
    case when city_maintains = 'Yes' then 1
         when maintained_by = 'MAD-C' then 1
         else 0 end city_maintains,
    ald_dist as alder_district,
    ST_Transform(geom,{{ var('s_wi_srid') }}) as local_geom

from {{ source('city_of_madison','streets_geojson') }}