{% macro apply_overlay_to_streets(overlay_ref,overlay_alias,overlay_name) %}

select
    streets.street_id,
    streets.street_year,
    {{overlay_alias}}.{{overlay_name}},
    ST_Intersection(streets.geom_4326,{{overlay_alias}}.geom_4326) as intersect_geom_4326,
    streets.street_length * (ST_Length(ST_Intersection(streets.geom_4326,{{overlay_alias}}.geom_4326)) / ST_Length(streets.geom_4326)) as intersect_street_length,
    streets.street_width,
    streets.city_maintains,
    streets.speed_limit

from {{ ref('streets_localize_geom') }} streets
inner join {{ ref(overlay_ref) }} as {{overlay_alias}}
    on ST_Intersects(streets.geom_4326,{{overlay_alias}}.geom_4326)

{% endmacro %}