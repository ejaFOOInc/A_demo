with src as (
  select * from {{ source('raw', 'customer_events') }}
  where batch_id = {{ var('batch_num', 1) }}
), prepared as (
  select
    {{ hash_key(['customer_id']) }} as hk_customer,
    upper(trim(customer_id)) as customer_id,
    trim(customer_name) as customer_name,
    trim(city) as city,
    {{ hashdiff(['customer_name', 'city']) }} as hashdiff,
    source_event_at,
    effective_at,
    {{ ldts('ingested_at') }},
    record_source,
    batch_id
  from src where nullif(trim(customer_id), '') is not null
)
select * from prepared
qualify row_number() over (
  partition by
    hk_customer,
    effective_at,
    hashdiff
  order
    by batch_id desc,
    record_source) = 1
