create database student_info;
show databases;
use student_info;

-- create  a table course 
create table course(
course_id int auto_increment primary key,
course_name varchar(120) unique,
duration int);

insert into course(course_name,duration) 
values("CDS",30),("CDA",45),("PYF",20);

-- Retrieve all rows and columns
select * from course;

-- check the course id for "CDA" course name
select course_id,course_name
from course
where course_name="CDA";

-- find course name with duration for more than 40 days
-- find the total number of course 

select count(course_name) as total_course
from course;

select * 
from course
order by course_name desc;

update course 
set course_name="web developement"
where course_id=3;

select * from course;

-- Retrive course  name starts with "C"

select * 
from course
where course_name like "%cDA%";

-- WHICH COURSE HAS MAXIMUM DURATION
select max(duration) 
from course;

select course_name
from course
where duration =(select max(duration) 
                 from course);
                 

create table department(
dept_id int primary key,
dept_name varchar(120) unique,
dept_head varchar(120));

create table student(
student_id int auto_increment primary key,
student_roll varchar(50) unique,
student_name varchar(120),
email varchar(120) unique,
dept_id int,
foreign key (dept_id) references department(dept_id));



insert into department(dept_id,dept_name,dept_head)values
(1,"computer science","Amit kumar"),
(2,"Electronis","Balchandra"),
(3,"telecom","charan reddy"),
(4,"mathematics","dhanraj");
select * from student;
select * from department;
insert into student(student_roll,student_name,email,dept_id) values
("cs01","akarsh","abc@gmail.com",1);
insert into student(student_roll,student_name,email,dept_id) values
("cs02","bhavya","bhavya@gmail.com",1);
insert into student(student_roll,student_name,email,dept_id) values
("ELO1","tarun","ac@gmail.com",2);
insert into student(student_roll,student_name,email,dept_id) values
("MO1","MAHESH","asd@gmail.com",3);
insert into student(student_roll,student_name,email,dept_id) values
("TLO1","DIVYA","aswd@gmail.com",4);

select dept_head
from department as d
join student as s
on d.dept_id=s.dept_id
where student_name="MAHESH";

SELECT count(student_name)
from department as d
join student as s
on d.dept_id=s.dept_id
WHERE dept_name="computer science";


SELECT d.dept_name,count(student_name) as total_students
from department as d
join student as s
on d.dept_id=s.dept_id
group by d.dept_id;




Select s.*,d.dept_name
from student as s 
join department as d
on s.dept_id=d.dept_id
where d.dept_name="computer science";

-- method 1--by using GUI Workbench
call get_student_details();

-- method 2 by creating separate procedure.sql filee
call get_student_info1();

-- method 3 on same script file
DELIMITER //

CREATE PROCEDURE get_department_info()
BEGIN
    SELECT * FROM department;
END //

DELIMITER ;

DELIMITER //

CREATE PROCEDURE total_student()
BEGIN
    SELECT count(student.student_name) FROM student;
END //

DELIMITER ;


call total_student();

DELIMITER //

-- Example 2 : with IN parameter-passing a value to the procedure
-- depid is new variable
DELIMITER //

CREATE PROCEDURE get_all_students_cs(IN depid int)
BEGIN
	Select s.student_name,d.dept_name
    from student as s 
    join department as d
    on s.dept_id=d.dept_id
    where s.dept_id=depid;
END //

call get_all_students_cs(1);

DELIMITER //
CREATE PROCEDURE AddStudent (
    IN p_Roll VARCHAR(10),
    IN p_Name VARCHAR(100),
    IN p_Email VARCHAR(100),
    IN p_DeptId INT
)
BEGIN
    INSERT INTO student (student_roll, student_name, email, dept_id)
    VALUES (p_Roll, p_Name, p_Email, p_DeptId);
END //

call AddStudent("EL008","DHANUSH","DD@gmail.com",2);
call get_student_info1();









DELIMITER ;

DELIMITER //

CREATE PROCEDURE GetTotalStudents(
    OUT total INT
)
BEGIN
    SELECT COUNT(*) INTO total FROM student;
END //

DELIMITER ;

-- Declare a variable to hold the OUT value
SET @total = 0;
-- Call the procedure
CALL GetTotalStudents(@total);
select @total;











DELIMITER //

CREATE PROCEDURE GetStudentEmail (
    IN roll VARCHAR(10),
    OUT student_email VARCHAR(100)
)
BEGIN
    SELECT email INTO student_email
    FROM student
    WHERE student_roll = roll;
END //

call GetStudentEmail('CS01',@email);
select @email;

DELIMITER;
DELIMITER //

CREATE PROCEDURE UpdateDept (
    INOUT roll VARCHAR(10),
    IN new_dept INT
)
BEGIN
    UPDATE student SET dept_id = new_dept
    WHERE student_roll = roll;
END //

DELIMITER ;
select * from student;
SET @roll = 'cs02';
CALL UpdateDept(@roll, 4);
select * from student;

-- EXAMPLE 5: INOUT Parameter

DELIMITER //

CREATE PROCEDURE count_students_inout(
    INOUT total INT
)
BEGIN
    DECLARE temp INT;
    SELECT COUNT(*) INTO temp FROM student;
    SET total = total + temp;
END //

DELIMITER ;
-- INOUT Example
-- before procedure call variable total=10(@start) and output of procedure call,the total=17
SET @start = 10;
CALL count_students_inout(@start);
SELECT @start;  -- Will be 10 + number of students

-- ========================================================================
--        				Triggers
-- =========================================================================

CREATE TABLE studentLog (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_roll VARCHAR(20),
    action_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    action_type VARCHAR(10)
);
-- Automatic logging of students record via  trigger
DELIMITER $$
CREATE TRIGGER after_student_insert
AFTER INSERT ON student
FOR EACH ROW
BEGIN
    INSERT INTO studentLog (student_roll, action_type)
    VALUES (NEW.student_roll, 'INSERT');
END;
$$ 
DELIMITER ;
-- INSERT THE VALUES INTO STUDENT DATABASE USING INSERT COMMAND OR BY STORED PROCEDURE METHOD
call AddStudent("DS003","RAMYA","RAMYA@gmail.com",3);
select * from studentLog;
select * from student;

-- Example 2:
DELIMITER $$
CREATE TRIGGER before_student_insert
BEFORE INSERT ON student
FOR EACH ROW
BEGIN
    IF NEW.email NOT LIKE '%@%.%' THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Invalid email format.';
    END IF;
END;
$$
DELIMITER ;
call AddStudent("CV001","chitra@gmail.com","chitra",7);
select * from student;






-- Example 3: dept_name to uppercase before insert

DELIMITER $$

CREATE TRIGGER before_department_insert
BEFORE INSERT ON Department
FOR EACH ROW
BEGIN
    SET NEW.dept_name = UPPER(NEW.dept_name);
END $$

DELIMITER ;

INSERT INTO Department (dept_id, dept_name,dept_head) VALUES
(6, 'electrical Engg','Santhosh Kumar');

INSERT INTO Department (dept_id, dept_name, dept_head)
VALUES (7, 'civil engineering', 'Dr. Ravi');


















