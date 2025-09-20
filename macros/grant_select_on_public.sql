{% macro grant_select_on_public() %}
grant select on all tables in schema public to housing_writer;
{% endmacro %}