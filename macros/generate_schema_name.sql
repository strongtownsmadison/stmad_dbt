{% macro generate_schema_name(custom_schema_name, node) %}

    {%- set default_schema = target.schema -%}

    {% if custom_schema_name is none %}
        {{ log("Using default schema: " ~ default_schema, info=True) }}
        {{ default_schema }}
    {% else %}
        {{ log("Using custom schema: " ~ custom_schema_name, info=True) }}
        {{ custom_schema_name | trim }}
    {% endif %}

{% endmacro %}