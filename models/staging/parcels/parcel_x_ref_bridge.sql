{{
    config(
        tags=['parcels']
    )
}}

select distinct
    parcel_id,
    x_ref_parcel,
    parcel_year
from {{ ref('parcels_column_rename') }}