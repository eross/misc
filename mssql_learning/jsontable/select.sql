
select 
    json_value(JsonData, '$.id') as id,
    json_value(JsonData, '$.fields.summary') as summary,
    json_value(JsonData, '$.key') as keyx
from IssueList
order by id;
