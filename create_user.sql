create user c##u15 identified by password;
exec CreateNewUser(123108,'password','C','c##u15','Krish',28,3,'SG Road','Panaji','Goa',390239,7790788067);
grant connect to c##u15;
grant create session to c##u15;
grant insert on sys.property to c##u15;
grant execute on sys.InsertPropertyRecord to c##u15;
grant execute on sys.GetPropertyRecord to c##u15;
grant execute on sys.GetTenantDetails to c##u15;
grant execute on sys.SearchPropertyForRentOnCity to c##u15;
grant execute on sys.SearchPropertyForRentOnLocality to c##u15;
grant execute on sys.GetRentHistory to c##u15;
grant execute on sys.AddPhoneNo to c##u15; 
grant execute on sys.DeletePropertyRecord to c##u15;
grant execute on sys.UpdatePropertyStart to c##u15;
grant execute on sys.UpdatePropertyEnd to c##u15;
grant execute on sys.UpdatePropertyRent to c##u15;
grant execute on sys.UpdatePropertyHike to c##u15;






