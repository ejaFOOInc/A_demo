select hk_customer, load_datetime, hashdiff, count(*) as n
from {{ ref('sat_customer') }}
group by 1,2,3 having count(*) > 1
