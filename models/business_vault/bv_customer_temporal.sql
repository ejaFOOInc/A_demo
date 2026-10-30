select
    h.customer_id,
    s.customer_name,
    s.city,
    s.effective_at as effective_from,
    coalesce(lead(s.effective_at) over (
        partition by
            h.hk_customer
        order by
            s.effective_at), '2999-12-31') as effective_to,
    s.load_datetime as valid_from,
    coalesce(lead(s.load_datetime) over (
        partition by
            h.hk_customer
        order by
            s.load_datetime), '2999-12-31') as valid_to
from {{ ref('hub_customer') }} h
inner join {{ ref('sat_customer') }} s
    on h.hk_customer = s.hk_customer
