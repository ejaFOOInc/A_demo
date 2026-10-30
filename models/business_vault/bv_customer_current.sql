select
    h.hk_customer,
    h.customer_id,
    s.customer_name,
    s.city,
    s.effective_at,
    s.load_datetime
from {{ ref('hub_customer') }} h
inner join {{ ref('sat_customer') }} s
    on h.hk_customer = s.hk_customer
qualify
    row_number() over (
        partition by
            h.hk_customer
        order by
            s.load_datetime desc) = 1
