set pages 500
set MARKUP HTML ON
spool rent_history.html
select * from rents where pid=3;
spool off
