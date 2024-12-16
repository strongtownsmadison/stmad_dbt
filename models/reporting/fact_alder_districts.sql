{{
    config(
        tags=['alder_districts']
    )
}}

{{ generate_fact_overlay('alder_districts_localize_geom','alder_districts','alder_district') }}