{{
    config(
        tags=['parcels']
    )
}}

{{ dbt_utils.union_relations(
    relations=[
        ref('parcels_column_rename'),
        ref('parcels_geojson_flatten')
    ]
) }}