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




-- ==========================================================
use student_info;

create user 'manoj' identified by "pass@123";
create role "department_role";
grant select,insert,update on student_info.department to "department_role";
grant select,update on student_info.student to "department_role";
grant "department_role" to "manoj";
-- GRANT ALL PRIVILEGES ON student_info.* TO 'ajay';

FLUSH PRIVILEGES;

SHOW GRANTS FOR 'manoj';
GRANT USAGE ON student_info.* TO 'department_role';
GRANT SHOW DATABASES ON *.* TO 'department_role';
