{{
    config(
        tags=['area_plans']
    )
}}

{{ generate_fact_overlay('area_plans_localize_geom','area_plans','area_plan') }}