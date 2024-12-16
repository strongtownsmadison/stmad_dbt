{{config(
    tags=['alder_districts']
)}}

select 
    ald_dist as district_id,
    'District ' || ald_dist::varchar(16) as alder_district,
    geom as geom_4326,
    ST_Transform(geom,{{ var('s_wi_srid') }}) as geom_local
from {{ source('city_of_madison','alder_districts_geojson')}}