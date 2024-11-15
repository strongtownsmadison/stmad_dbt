{{
    config(
        tags=['tax_roll']
    )
}}

with keys as (
select array_agg(key order by key) as key_set,
	load_dttm::date as load_dt
from staging.tax_roll_xlsx,
     jsonb_object_keys(data_json) key
group by id
)

select key_set,
	count(key_set) num_records,
	min(load_dt) first_seen_dt,
	max(load_dt) last_seen_dt
from keys
group by key_set