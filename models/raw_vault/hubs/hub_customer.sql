{{ 
  config(
    unique_key='hk_customer',
    on_schema_change='fail',
    tags=["raw_vault", "hub"]
  )
}}

with keys as (
  select
    hk_customer,
    customer_id,
    load_datetime,
    record_source 
  from {{ ref('stg_customers') }}
  union all
  select
    hk_customer,
    customer_id,
    load_datetime,
    record_source
  from {{ ref('stg_policies') }}
)

select
  hk_customer,
  customer_id,
  load_datetime,
  record_source
from keys
{% if is_incremental() %}
  where not exists (
    select 1 from {{ this }} hub
    where hub.hk_customer = keys.hk_customer
  )
{% endif %}
qualify row_number() over (
  partition by
    hk_customer
  order by
    load_datetime,
    record_source) = 1
