{{
    config(
        tags=['streets']
    )
}}

with current_and_history as (
    select * from {{ source('city_of_madison','streets_geojson') }}
    --union all
    --select * from {{ source('city_of_madison','streets_geojson_history') }}
)

-- Flatten GeoJSON structure into columns matching legacy schema
select 
    -- Extract properties from JSONB
    (feature_data->'properties'->>'OBJECTID')::int as objectid,
    (feature_data->'properties'->>'speed_limit')::int as speed_limit,
    (feature_data->'properties'->>'surface_width')::numeric as surface_width,
    (feature_data->'properties'->>'lanes')::int as lanes,
    (feature_data->'properties'->>'ShapeSTLength')::numeric as shapestlength,
    feature_data->'properties'->>'truck_route' as truck_route,
    feature_data->'properties'->>'sidewalk' as sidewalk,
    (feature_data->'properties'->>'median_width')::numeric as median_width,
    (feature_data->'properties'->>'oneway')::int as oneway,
    feature_data->'properties'->>'city_maintains' as city_maintains,
    feature_data->'properties'->>'maintained_by' as maintained_by,
    feature_data->'properties'->>'ald_dist' as ald_dist,
    
    -- Convert GeoJSON geometry to PostGIS geometry
    ST_GeomFromGeoJSON(feature_data->'geometry') as geom,
    
    -- Add timestamp from source table
    load_dttm
    
from current_and_history
where feature_data is not null