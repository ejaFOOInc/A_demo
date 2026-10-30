with snapshots (snapshot_date) as (
select '2026-01-01'
union
select '2026-01-16'
)

select
    snapshots.snapshot_date,
    s.hk_customer,
    s.load_datetime
from ALLIANZ_DEMO.RAW_VAULT.HUB_CUSTOMER as h
inner join ALLIANZ_DEMO.BUSINESS_VAULT.BV_CUSTOMER_TEMPORAL as t
    on h.hk_customer = t.hk_customer
inner join ALLIANZ_DEMO.RAW_VAULT.SAT_CUSTOMER s
    on t.hk_customer = s.hk_customer
    and t.valid_from = s.load_datetime
inner join snapshots
    on snapshots.snapshot_date between t.effective_from and t.effective_to
