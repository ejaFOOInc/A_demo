{% macro hash_key(columns) -%}
    SHA2(CONCAT_WS('||',
    {%- for column in columns %}
      COALESCE(NULLIF(UPPER(TRIM(TO_VARCHAR({{ column }}))), ''), '^^'){% if not loop.last %}, {% endif %}
    {%- endfor %}
    ), 256)
{%- endmacro %}
