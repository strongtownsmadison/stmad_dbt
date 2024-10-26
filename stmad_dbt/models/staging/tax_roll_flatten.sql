{{
    config(
        tags=["parcels","tax_roll"]
    )
}}

select 
from {{ source('staging','tax_roll_xlsx')}}