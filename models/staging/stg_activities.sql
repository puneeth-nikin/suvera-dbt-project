select * 
from {{ ref('raw_activities') }}
limit 100