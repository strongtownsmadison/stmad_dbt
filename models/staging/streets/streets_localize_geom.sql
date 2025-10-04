{{
    config(
        tags=['streets']
    )
}}

-- Union the flattened GeoJSON with legacy source
with union_streets as (
    select 
        objectid,
        load_dttm,
        geom,
        speed_limit,
        surface_width,
        lanes,
        shapestlength,
        truck_route,
        sidewalk,
        median_width,
        oneway,
        city_maintains,
        maintained_by,
        ald_dist
    from {{ ref('streets_geojson_flatten') }}
    
    union all
    
    select 
        objectid,
        load_dttm,
        geom,
        speed_limit,
        surface_width,
        lanes,
        shapestlength,
        truck_route,
        sidewalk,
        median_width,
        oneway,
        city_maintains,
        maintained_by,
        ald_dist
    from {{ source('city_of_madison','streets_geojson_legacy') }}
)

-- Apply transformations to unified dataset
select 
    objectid as street_id,
    date_part('year', load_dttm) as street_year,
    geom as geom_4326,
    speed_limit,
    surface_width as street_width,
    lanes as street_lanes,
    shapestlength as street_length,
    truck_route as is_truck_route,
    
    -- Sidewalk logic: check if value is '1', '2', or '3'
    case 
        when sidewalk in ('1','2','3') then 1 
        else 0 
    end as has_sidewalk,
    
    median_width,
    
    -- One-way logic: check if oneway > 0
    case 
        when oneway::int > 0 then 1 
        else 0 
    end as is_oneway,
    
    -- City maintenance logic: check city_maintains or maintained_by
    case 
        when city_maintains = 'Yes' then 1
        when maintained_by = 'MAD-C' then 1
        else 0 
    end as city_maintains,
    
    ald_dist as alder_district,
    
    -- Transform to local coordinate system
    ST_Transform(geom, {{ var('s_wi_srid') }}) as local_geom

from union_streets