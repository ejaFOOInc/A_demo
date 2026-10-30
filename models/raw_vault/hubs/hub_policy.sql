{{
    config(
        unique_key='hk_policy',
        on_schema_change='fail',
        tags=["raw_vault", "hub"]
    )
}}

with keys as (
select
    hk_policy,
    policy_id,
    load_datetime,
    record_source
from {{ ref('stg_policies') }}
)

select
    hk_policy,
    policy_id,
    load_datetime,
    record_source
from keys
{% if is_incremental() %}
  where not exists (
    select 1 from {{ this }} hub
    where hub.hk_policy = keys.hk_policy
  )
{% endif %}
qualify row_number() over (
    partition
        by hk_policy
    order by
        load_datetime,
        record_source) = 1
