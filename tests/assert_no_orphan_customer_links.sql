select l.hk_customer from {{ ref('link_customer_policy') }} l
left join {{ ref('hub_customer') }} h on l.hk_customer = h.hk_customer
where h.hk_customer is null
