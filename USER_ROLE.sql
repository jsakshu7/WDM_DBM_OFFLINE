-- select the database
use student_info;

-- basic checks
show databases;
show tables;

-- create a new user and password
create user 'ajay' identified by "pass@123";

-- Assign the user to the role
create role "admin_role";

-- permission to access specified database
GRANT ALL PRIVILEGES ON student_info.* TO 'ajay';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'ajay';




