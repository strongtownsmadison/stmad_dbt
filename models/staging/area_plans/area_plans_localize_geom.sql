{{
    config(
        tags=['area_plans']
    )
}}

select
    id,
    name as area_plan,
    geometry as geom_4326,
    ST_Transform(geometry,{{ var('s_wi_srid') }}) as geom_local

from {{ source('public','geometries') }}
where name <> 'TOD'