{% macro hashdiff(columns) -%}
    {{ hash_key(columns) }}
{%- endmacro %}
