{{
    config(
        tags=['parcels','area_plans']
    )
}}


{{ apply_overlay_to_parcels('area_plans_localize_geom','area_plans','area_plan')}}
