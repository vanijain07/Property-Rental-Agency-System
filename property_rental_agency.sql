

create or replace procedure InsertPropertyRecord(new_pid in number,new_add in varchar2,new_city in varchar2,new_locality in varchar2,new_sd in date,new_ed in date,new_no in number,new_rent in number,new_hike in number,new_yoc in date,new_ta in number,new_pa in number,p_type in varchar2,shop_flag in varchar2,warehouse_flag in varchar2,no_of_bedrooms in number,indep_house_flag in varchar2,flat_flag in varchar2) is
t varchar2(15);
aid number;
begin
select SYS_CONTEXT('USERENV','SESSION_USER') into t from dual;
select userid into aid from login_cred where user_name like lower(t);
insert into sys.property values(new_pid,new_add,new_city,new_locality,new_sd,new_ed,new_no,new_rent,new_hike,new_yoc,new_ta,new_pa,aid);
if p_type='commercial' then
insert into sys.commercial values(new_pid,shop_flag,warehouse_flag);
else
insert into sys.residential values(new_pid,no_of_bedrooms,indep_house_flag,flat_flag);
end if;
end;
/



create or replace procedure GetPropertyRecord(owner_aid in number) is
new_pid number;
new_add varchar2(30);
new_city varchar2(30);
new_locality varchar2(30);
new_sd date;
new_ed date;
new_sssno number;
new_rent number;
new_hike number;
new_yoc date;
new_ta number;
new_pa number;
rc number;
new_shop varchar2(1);
new_warehouse varchar2(1);
new_noOfBed number;
new_ih varchar2(1);
new_flat varchar2(1);
cursor record_cursor is 
select pid,address,city,locality,av_start_date,av_end_date,no_of_floors,offered_rent_pm,yearly_hike,year_of_construction,total_area,plinth_area from sys.property where owner_aid=owner_aadhaar;
begin
open record_cursor;
loop
fetch record_cursor into new_pid , new_add ,new_city , new_locality ,new_sd ,new_ed,new_sssno , new_rent,new_hike,new_yoc,new_ta,new_pa;
exit when record_cursor%notfound;
select count(*) into rc from sys.residential where pid=new_pid;
if rc=0 then
select shop,warehouse into new_shop,new_warehouse from sys.commercial where pid=new_pid;
dbms_output.put_line('pid:'||new_pid||' address:'||new_add||' city:'||new_city||' locality:'||new_locality||' av_start_date:'||new_sd||' av_end_date:'||new_ed||' no_of_floors:'||new_sssno||' offered_rent_pm:'||new_rent||' yearly_hike:'||new_hike||' year_of_construction:'||new_yoc||' total_area:'||new_ta||' plinth_area:'||new_pa||' type:commercial '||' shop flag: '||new_shop||' warehouse flag:'||new_warehouse);
else
select no_of_bedrooms,independent_house,flat into new_noOfBed,new_ih,new_flat from sys.residential where pid=new_pid;
dbms_output.put_line('pid:'||new_pid||' address:'||new_add||' city:'||new_city||' locality:'||new_locality||' av_start_date:'||new_sd||' av_end_date:'||new_ed||' no_of_floors:'||new_sssno||' offered_rent_pm:'||new_rent||' yearly_hike:'||new_hike||' year_of_construction:'||new_yoc||' total_area:'||new_ta||' plinth_area:'||new_pa||' type:residential '||' no of bedrooms:'||new_noOfBed||' independent house flag:'||new_ih||' flat flag:'||new_flat);
end if;
end loop;
close record_cursor;
end;
/


create or replace procedure GetTenantDetails(given_pid in number,given_date in date) is
tenant_aid number;
t_name varchar2(30);
t_age number;
t_door_no number;
t_street varchar2(30);
t_city varchar2(30);
t_state varchar2(10);
t_pincode number;
pno number;
begin
select tenant_aadhaar into tenant_aid from sys.rents where pid = given_pid AND (start_date <=given_date AND end_date>=given_date);
select name,age,door_no,street,city,state,pincode into t_name,t_age,t_door_no,t_street,t_city,t_state,t_pincode from sys.customer where aadhaarid = tenant_aid;
dbms_output.put_line('aadhaarid: '||tenant_aid||' name: '||t_name||' age: '||t_age||' door_no: '||t_door_no||' street: '||t_street||' city: '||t_city||' state: '||t_state||' pincode: '||t_pincode);
dbms_output.put_line('phone numbers: ');
declare
cursor get_phoneno_cursor is
select phone_no from customer_phone where aadhaarid=tenant_aid;
begin
open get_phoneno_cursor;
loop
fetch get_phoneno_cursor into pno;
exit when get_phoneno_cursor%notfound;
dbms_output.put_line(pno);
end loop;
close get_phoneno_cursor;
end;
end;
/

create or replace procedure CreateNewUser(new_aid in number,new_password in varchar2,new_utype in varchar2,new_uname in varchar2,new_name in varchar2,new_age in number,new_door_no in number,new_street in varchar2 ,new_city in varchar2 ,new_state in varchar2,new_pincode in number,phone in number) is
begin
insert into sys.login_cred values(new_aid,new_password,new_utype,new_uname);
if new_utype='C' then
insert into sys.customer values(new_aid,new_name,new_age,new_door_no,new_street,new_city,new_state,new_pincode);
insert into sys.customer_phone values(new_aid,phone);
end if;
end;
/


create or replace procedure SearchPropertyForRentOnCity(given_city in varchar2) is
new_pid number;
new_add varchar2(30);
new_locality varchar2(30);
new_sd date;
new_ed date;
new_sssno number;
new_rent number;
new_hike number;
new_yoc date;
new_ta number;
new_pa number;
rc number;
new_shop varchar2(1);
new_warehouse varchar2(1);
new_noOfBed number;
new_ih varchar2(1);
new_flat varchar2(1);
cursor search_property_cursor is 
select pid,address,locality,av_start_date,av_end_date,no_of_floors,offered_rent_pm,yearly_hike,year_of_construction,total_area,plinth_area from sys.property where city=given_city AND pid not in (select pid from sys.rents where start_date <=(select current_date from dual) AND end_date>=(select current_date from dual));
begin
open search_property_cursor;
loop
fetch search_property_cursor into new_pid , new_add, new_locality ,new_sd ,new_ed,new_sssno , new_rent,new_hike,new_yoc,new_ta,new_pa;
exit when search_property_cursor%notfound;
select count(*) into rc from sys.residential where pid=new_pid;
if rc=0 then
select shop,warehouse into new_shop,new_warehouse from sys.commercial where pid=new_pid;
dbms_output.put_line('pid:'||new_pid||' address:'||new_add||' locality:'||new_locality||' av_start_date:'||new_sd||' av_end_date:'||new_ed||' no_of_floors:'||new_sssno||' offered_rent_pm:'||new_rent||' yearly_hike:'||new_hike||' year_of_construction:'||new_yoc||' total_area:'||new_ta||' plinth_area:'||new_pa||' type:commercial '||' shop flag:'||new_shop||' warehouse flag:'||new_warehouse);
else
select no_of_bedrooms,independent_house,flat into new_noOfBed,new_ih,new_flat from sys.residential where pid=new_pid;
dbms_output.put_line('pid:'||new_pid||' address:'||new_add||' locality:'||new_locality||' av_start_date:'||new_sd||' av_end_date:'||new_ed||' no_of_floors:'||new_sssno||' offered_rent_pm:'||new_rent||' yearly_hike:'||new_hike||' year_of_construction:'||new_yoc||' total_area:'||new_ta||' plinth_area:'||new_pa||' type:residential '||' no of bedrooms:'||new_noOfBed||' independent house flag:'||new_ih||' flat flag:'||new_flat);
end if;
end loop;
close search_property_cursor;
end;
/

create or replace procedure SearchPropertyForRentOnLocality(given_locality in varchar2) is
new_pid number;
new_add varchar2(30);
new_city varchar2(30);
new_sd date;
new_ed date;
new_sssno number;
new_rent number;
new_hike number;
new_yoc date;
new_ta number;
new_pa number;
rc number;
new_shop varchar2(1);
new_warehouse varchar2(1);
new_noOfBed number;
new_ih varchar2(1);
new_flat varchar2(1);
cursor search_property_cursor is 
select pid,address,city,av_start_date,av_end_date,no_of_floors,offered_rent_pm,yearly_hike,year_of_construction,total_area,plinth_area from sys.property where locality=given_locality AND pid not in (select pid from sys.rents where start_date <=(select current_date from dual) AND end_date>=(select current_date from dual));
begin
open search_property_cursor;
loop
fetch search_property_cursor into new_pid , new_add, new_city ,new_sd ,new_ed,new_sssno , new_rent,new_hike,new_yoc,new_ta,new_pa;
exit when search_property_cursor%notfound;
select count(*) into rc from sys.residential where pid=new_pid;
if rc=0 then
select shop,warehouse into new_shop,new_warehouse from sys.commercial where pid=new_pid;
dbms_output.put_line('pid:'||new_pid||' address:'||new_add||' city:'||new_city||' av_start_date:'||new_sd||' av_end_date:'||new_ed||' no_of_floors:'||new_sssno||' offered_rent_pm:'||new_rent||' yearly_hike:'||new_hike||' year_of_construction:'||new_yoc||' total_area:'||new_ta||' plinth_area:'||new_pa||' type:commercial '||' shop flag:'||new_shop||' warehouse flag:'||new_warehouse);
else
select no_of_bedrooms,independent_house,flat into new_noOfBed,new_ih,new_flat from sys.residential where pid=new_pid;
dbms_output.put_line('pid:'||new_pid||' address:'||new_add||' city:'||new_city||' av_start_date:'||new_sd||' av_end_date:'||new_ed||' no_of_floors:'||new_sssno||' offered_rent_pm:'||new_rent||' yearly_hike:'||new_hike||' year_of_construction:'||new_yoc||' total_area:'||new_ta||' plinth_area:'||new_pa||' type:residential '||'no of bedrooms:'||new_noOfBed||' independent house flag:'||new_ih||' flat flag:'||new_flat);
end if;
end loop;
close search_property_cursor;
end;
/

create or replace procedure GetRentHistory(given_pid in number) is
sd date;
ed date;
rent number;
hike number;
agency_commission number;
t_aid number;
cursor rent_history_cursor is 
select start_date,end_date,actual_rent_pm,actual_yearly_hike,agency_com,tenant_aadhaar from sys.rents where pid=given_pid;
begin
open rent_history_cursor;
loop
fetch rent_history_cursor into sd, ed, rent, hike, agency_commission, t_aid;
exit when rent_history_cursor%notfound;
dbms_output.put_line('pid: '||given_pid||' start_date: '||sd||' end_date: '||ed||' actual_rent_pm: '||rent||' actual_yearly_hike: '||hike||' agency_commission: '||agency_commission||' tenant_aadhaar: '||t_aid);
end loop;
close rent_history_cursor;
end;
/



create or replace procedure AddPhoneNo(phone in number) is
t varchar2(15);
aid number;
begin
select SYS_CONTEXT('USERENV','SESSION_USER') into t from dual;
select userid into aid from login_cred where user_name like lower(t);
insert into sys.customer_phone values(aid,phone);
end;
/

create or replace procedure DeletePropertyRecord(new_pid in number,p_type in varchar2) is
t varchar2(15);
aid number;
begin
select SYS_CONTEXT('USERENV','SESSION_USER') into t from dual;
select userid into aid from login_cred where user_name like lower(t);
if p_type='commercial' then
delete from sys.commercial where pid=new_pid;
else
delete from sys.residential where pid=new_pid;
end if;
delete from sys.rents where pid=new_pid;
delete from sys.property where pid=new_pid;
end;
/

create or replace procedure UpdatePropertyStart(new_pid in number,new_start in date) is
t varchar2(15);
aid number;
begin
select SYS_CONTEXT('USERENV','SESSION_USER') into t from dual;
select userid into aid from login_cred where user_name like lower(t);
update sys.property set av_start_date=new_start where pid=new_pid and owner_aadhaar=aid;
end;
/

create or replace procedure UpdatePropertyEnd(new_pid in number,new_end in date) is
t varchar2(15);
aid number;
begin
select SYS_CONTEXT('USERENV','SESSION_USER') into t from dual;
select userid into aid from login_cred where user_name like lower(t);
update sys.property set av_end_date=new_end where pid=new_pid and owner_aadhaar=aid;
end;
/

create or replace procedure UpdatePropertyRent(new_pid in number,new_rent in number) is
t varchar2(15);
aid number;
begin
select SYS_CONTEXT('USERENV','SESSION_USER') into t from dual;
select userid into aid from login_cred where user_name like lower(t);
update sys.property set offered_rent_pm=new_rent where pid=new_pid and owner_aadhaar=aid;
end;
/

create or replace procedure UpdatePropertyHike(new_pid in number,new_hike in number) is
t varchar2(15);
aid number;
begin
select SYS_CONTEXT('USERENV','SESSION_USER') into t from dual;
select userid into aid from login_cred where user_name like lower(t);
update sys.property set yearly_hike=new_hike where pid=new_pid and owner_aadhaar=aid;
end;
/









exec sys.InsertPropertyRecord(24,'Nagar society','Mathura','Old Padra','22-OCT-2023','22-DEC-2025',2,30000,6,'1-FEB-1993',2000,2500,'residential',NULL,NULL,3,'0','1');






