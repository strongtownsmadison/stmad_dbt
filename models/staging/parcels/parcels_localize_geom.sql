{{
    config(
        materialized='table',
        tags=['parcels']
    )
}}

select distinct 
    x_ref_parcel as parcel_id,
    parcel_year,
    ST_Transform(geom_4326,{{ var('s_wi_srid') }}) as local_geom
from {{ ref('parcels_column_rename') }}