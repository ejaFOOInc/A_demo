with src as (
  select * from {{ source('raw', 'policy_events') }}
  where batch_id = {{ var('batch_num', 1) }}
), prepared as (
  select
    {{ hash_key(['policy_id']) }} as hk_policy,
    {{ hash_key(['customer_id']) }} as hk_customer,
    {{ hash_key(['customer_id', 'policy_id']) }} as hk_customer_policy,
    upper(trim(policy_id)) as policy_id,
    upper(trim(customer_id)) as customer_id,
    trim(policy_type) as policy_type,
    premium::number(12,2) as premium,
    {{ hashdiff(['policy_type', 'premium']) }} as hashdiff,
    source_event_at,
    effective_at,
    {{ ldts('ingested_at') }},
    record_source,
    batch_id
  from src
  where nullif(trim(policy_id), '') is not null and nullif(trim(customer_id), '') is not null
)
select * from prepared
qualify row_number() over (
  partition by
    hk_policy,
    effective_at,
    hashdiff
  order by
    batch_id desc,
    record_source) = 1
