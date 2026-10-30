{{
    config(
        unique_key='hk_customer_policy',
        on_schema_change='fail',
        tags=["raw_vault", "link"]
    )
}}

with keys as (
    select
        hk_customer_policy,
        hk_customer,
        hk_policy,
        load_datetime,
        record_source
    from {{ ref('stg_policies') }}
)

select
    hk_customer_policy,
    hk_customer,
    hk_policy,
    load_datetime,
    record_source
from keys
{% if is_incremental() %}
  where not exists (
    select 1 from {{ this }} lnk
    where lnk.hk_customer_policy = keys.hk_customer_policy
  )
{% endif %}
qualify row_number() over (
    partition by
        hk_customer_policy
    order by
        load_datetime,
        record_source) = 1
