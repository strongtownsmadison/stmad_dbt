{{
    config(
        tags=['parcels','alder_districts']
    )
}}

{{ apply_overlay_to_parcels('alder_districts_localize_geom','alder_districts','alder_district')}}