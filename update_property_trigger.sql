create or replace trigger UpdatePropertyRecord after update of av_start_date on sys.Property
t varchar2(15);
aid number;
begin
select SYS_CONTEXT('USERENV','SESSION_USER') into t from dual;
select userid into aid from login_cred where user_name like lower(t);
if :old.aadhaarid!=aid
update sys.property set av_start_date=:old.av_start_date where aadhaarid=:old.aadhaarid;
end if;
end;
/
