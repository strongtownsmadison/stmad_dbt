{{
    config(
        tags=['streets','alder_districts']
    )
}}

{{ apply_overlay_to_streets('alder_districts_localize_geom','alder_districts','alder_district') }}