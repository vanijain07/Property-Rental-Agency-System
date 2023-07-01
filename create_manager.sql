create user c##m3 identified by password;
exec CreateNewUser(123458,'password','M','c##m3',NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL);
grant connect to c##m3;
grant create session to c##m3;
grant select,insert,delete on property to c##m3;
grant select,insert,delete on rents to c##m3;
grant select,insert,delete on commercial to c##m3;
grant select,insert,delete on residential to c##m3;
grant execute on GetPropertyRecord to c##m3;
grant execute on GetTenantDetails to c##m3;
grant execute on GetRentHistory to c##m3;

