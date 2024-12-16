{{
    config(
        tags=['streets','area_plans']
    )
}}

{{ apply_overlay_to_streets('area_plans_localize_geom','area_plans','area_plan')}}


/*
select
    streets.street_id,
    streets.street_year,
    area_plans.area_plan,
    ST_Intersection(streets.geom_4326,area_plans.geom_4326) as intersect_geom_4326,
    streets.street_length * (ST_Length(ST_Intersection(streets.geom_4326,area_plans.geom_4326)) / ST_Length(streets.geom_4326)) as intersect_street_length,
    streets.street_width,
    city_maintains,
    speed_limit

from {{ ref('streets_localize_geom') }} streets
inner join {{ ref('area_plans_localize_geom') }} as area_plans
    on ST_Intersects(streets.geom_4326,area_plans.geom_4326)
*/