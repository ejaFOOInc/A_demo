select l.hk_policy from {{ ref('link_customer_policy') }} l
left join {{ ref('hub_policy') }} h on l.hk_policy = h.hk_policy
where h.hk_policy is null
