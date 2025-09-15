{% macro clean_dev_schema(object_types='tables,views') %}
  {% if target.name != 'dev' %}
    {{ log("This macro should only be run against the dev target!", info=true) }}
    {{ return('') }}
  {% endif %}

  {% set schema_name = target.schema %}
  {% set types_list = object_types.split(',') %}
  
  {% if execute %}
    {% for object_type in types_list %}
      {% set object_type = object_type.strip() %}
      
      {% if object_type == 'tables' %}
        {% set get_objects_query %}
          SELECT table_name, 'TABLE' as object_type
          FROM information_schema.tables 
          WHERE table_schema = '{{ schema_name }}'
          AND table_type = 'BASE TABLE'
        {% endset %}
      {% elif object_type == 'views' %}
        {% set get_objects_query %}
          SELECT table_name, 'VIEW' as object_type
          FROM information_schema.views 
          WHERE table_schema = '{{ schema_name }}'
        {% endset %}
      {% endif %}

      {% set results = run_query(get_objects_query) %}
      {% if results.columns|length > 0 %}
        {% set objects = results.columns[0].values() %}
        {% set object_types_result = results.columns[1].values() %}
        
        {% if objects %}
          {{ log("Found " ~ objects|length ~ " " ~ object_type ~ " to drop in schema " ~ schema_name, info=true) }}
          
          {% for i in range(objects|length) %}
            {% set object_name = objects[i] %}
            {% set obj_type = object_types_result[i] %}
            {% set drop_query %}
              DROP {{ obj_type }} IF EXISTS "{{ schema_name }}"."{{ object_name }}" CASCADE;
            {% endset %}
            
            {{ log("Dropping " ~ obj_type.lower() ~ ": " ~ object_name, info=true) }}
            {% do run_query(drop_query) %}
          {% endfor %}
        {% else %}
          {{ log("No " ~ object_type ~ " found in schema " ~ schema_name, info=true) }}
        {% endif %}
      {% endif %}
    {% endfor %}
    
    {{ log("Successfully cleaned dev schema!", info=true) }}
  {% endif %}

{% endmacro %}