{{
    config(
        tags=["parcels","tax_roll"]
    )
}}

select *
from {{ source('city_of_madison','tax_roll_xlsx')}}