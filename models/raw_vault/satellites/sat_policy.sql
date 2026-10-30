{{
  config(
    on_schema_change='fail',
    tags=["raw_vault", "sat"]
  )
}}

with stg as (
  select
    hk_policy,
    policy_type,
    premium, hashdiff,
    effective_at,
    load_datetime,
    record_source,
    lag(hashdiff) over (
      partition by
        hk_policy
        order by
          load_datetime,
          record_source,
          hashdiff
        ) as prior_hashdiff
  from {{ ref('stg_policies') }}
),
stg_deltas as (
  select
    hk_policy,
    policy_type,
    premium,
    hashdiff,
    effective_at,
    load_datetime,
    record_source
  from
    stg
  where
    prior_hashdiff is null
    or hashdiff <> prior_hashdiff
),
delta_set as (
{% if is_incremental() %}
select false as is_stg, * from {{ this }}
union
{% endif %}
select true as is_stg,
  hk_policy,
  policy_type,
  premium,
  hashdiff,
  effective_at,
  load_datetime,
  record_source
from stg
)

select
  hk_policy,
  policy_type,
  premium,
  hashdiff,
  effective_at,
  load_datetime,
  record_source
from delta_set
{% if is_incremental() %}
qualify
  is_stg
  and coalesce(lag(hashdiff) over (
      partition by
        hk_policy
      order by
        load_datetime
      ), '') <> hashdiff
{% endif %}
