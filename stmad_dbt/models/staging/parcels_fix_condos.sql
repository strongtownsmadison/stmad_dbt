{{
    config(
        tags=["parcels"]
    )
}}

{# Set the field names that will be used to group condos together. #}
{% set find_most_common = ['property_class','property_use','area_name','lot_type_1','lot_type_2','zoning_1','neighborhood_primary']}

with 

{#
Loop through the fields that will help us group condos together.
We''ll see this loop happen a few times as we join in the results of find the most common value/grouping by common values.
#}
{% for field in find_most_common %}

{{field}}_most_common as (
    select x_ref_parcel,
        most_common_{{field}}
    from (
        select x_ref_parcel,
            parcel_year,
            {{ field }},
            row_number() over (partition by x_ref_parcel,parcel_year order by count(*) desc) as rn
        from {{ ref('parcels_column_rename') }}
        group by x_ref_parcel,
            parcel_year,
            {{ field }}
    )
    where rn = 1
),
{% enfor %}

final_cte as (

    select 
        parcels.x_ref_parcel as parcel_no,
        parcels.parcel_year,

        {% for field in find_most_common %}
        {{field}}_most_common.{{field}},
        {% endfor %}

        parcels.ward,
        parcels.alder_district,
        parcels.geom,
        min(parcels.parcel_address) as parcel_address,
        sum(parcels.bedrooms) as bedrooms,
        sum(parcels.current_total) as current_total,
        sum(parcels.net_taxes) as net_taxes,
        sum(parcels.total_taxes) as total_taxes,
        max(parcels.lot_size) as lot_size,
        max(parcels.shape_area) as shape_area,
        sum(parcels.total_dwelling_units) as total_dwelling_units

    from {{ ref('parcels_column_rename') }} parcels

    {% for field in find_most_common %}
    left outer join {{field}}_most_common
        using(x_ref_parcel,parcel_year)
    {% endfor %}

    group by parcels.x_ref_parcel,
        parcel_year,
        {% for field in find_most_common %}
        {{field}}_most_common.{{field}},
        {% endfor %}
        ward,
        alder_district,
        geom
)

select
    parcel_no,
    parcel_year,

    {% for field in find_most_common %}
    {% if field <> 'property_use' %} {{field}}, {% endif %}
    {% endfor %}

    --Clean up property uses
    case
        when property_use ilike '%apartment%' 
                or property_use in ('2 Unit','3 To 7 Unit','Condominium -apt')
            then 'Multifamily'
        when property_use ilike any (array['warehouse%','warehse%'])
            then 'Warehouse'
        when property_use ilike 'store%'
            then 'Store'
        when property_use ilike 'station%'
            then 'Station'
        else property_use
        end as property_use,

    ward,
    alder_district,
    geom,
    parcel_address,
    bedrooms,
    current_total,
    net_taxes,
    total_taxes,
    lot_size,
    shape_area,
    total_dwelling_units

from final_cte