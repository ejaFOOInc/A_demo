{% macro ldts(column_name) -%}
    {%- if var('use_ldts') -%}
        current_timestamp()
    {%- else -%}
        {{ column_name }}
    {%- endif %} as load_datetime
{%- endmacro %}