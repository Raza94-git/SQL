create database revision_case_study_2
use revision_case_study_2

CREATE TABLE LOCATION(
LOCATION_ID INT PRIMARY KEY,
CITY VARCHAR(30)
)

CREATE TABLE DEPARTMENT (
DEPARTMENT_ID INT PRIMARY KEY,
NAME VARCHAR(30),
LOCATION_ID INT FOREIGN KEY REFERENCES LOCATION(LOCATION_ID)
)

CREATE TABLE JOB (
JOB_ID INT PRIMARY KEY,
DESIGNATION VARCHAR(30)
)

SELECT * FROM LOCATION
SELECT * FROM DEPARTMENT
SELECT * FROM JOB

CREATE TABLE EMPLOYEE (
EMPLOYEE_ID INT,
LAST_NAME VARCHAR(20),
FIRST_NAME VARCHAR(20),
MIDDLE_NAME VARCHAR(20),
JOB_ID INT FOREIGN KEY REFERENCES JOB(JOB_ID),
HIRE_DATE DATE,
SALARY INT,
COMM INT,
DEPARTMENT_ID INT FOREIGN KEY REFERENCES DEPARTMENT(DEPARTMENT_ID)
)

INSERT INTO LOCATION(LOCATION_ID, CITY) VALUES
(122, 'NEW YORK'),
(123, 'DALLAS'),
(124, 'CHICAGO'),
(167, 'BOSTON');

INSERT INTO DEPARTMENT(DEPARTMENT_ID, NAME, LOCATION_ID) VALUES
(10, 'ACCOUNTING', 122),
(20, 'SALES', 124),
(30, 'RESEARCH', 123),
(40, 'OPERATIONS', 167);

INSERT INTO JOB(JOB_ID, DESIGNATION) VALUES
(667, 'CLEKR'),
(668, 'STAFF'),
(669, 'ANALYST'),
(670, 'SALES PERSON'),
(671, 'MANAGER'),
(672, 'PRESIDENT');

INSERT INTO EMPLOYEE(EMPLOYEE_ID, LAST_NAME, FIRST_NAME, MIDDLE_NAME, JOB_ID, HIRE_DATE, SALARY, COMM, DEPARTMENT_ID) VALUES
(7369, 'SMITH', 'JOHN', 'Q', 667, '1984-12-17', 800, NULL, 20),
(7499, 'ALLEN', 'KEVIN', 'J', 670, '1985-02-20', 1600, 300, 30),
(755, 'DOYLE', 'JEAN', 'K', 671, '1985-04-04', 2850, NULL, 30),
(756, 'DENNIS', 'LEAN', 'S', 671, '1985-05-15', 2750, NULL, 30),
(757, 'BAKER', 'LESLIE', 'D', 671, '1985-06-10', 2200, NULL, 40),
(7521, 'WARK', 'CYNTHIA', 'D', 670, '1985-02-22', 1250, 50, 30)


SELECT * FROM LOCATION
SELECT * FROM DEPARTMENT
SELECT * FROM JOB
SELECT * FROM EMPLOYEE

-- SIMPLE QUERIES --

--1. LIST ALL THE EMPLOYEE DETAILS

SELECT * FROM EMPLOYEE

-- 2. LIST ALL THE DEPARTMENT DETAILS

SELECT * FROM DEPARTMENT

-- 3. LIST ALL JOB DETAILS

SELECT * FROM JOB

-- 4. LIST ALL THE LOCATIONS

SELECT CITY FROM LOCATION

-- 5. Listout theFirstName,LastName,Salary,CommissionforallEmployees.

SELECT FIRST_NAME, LAST_NAME, SALARY, COMM FROM EMPLOYEE;

/* 6.  Listout theEmployeeID,LastName,Department IDforallemployeesand
 alias
 EmployeeIDas"IDof theEmployee",LastNameas"Nameof the
 Employee",Department IDas"Dep_id". */

 SELECT EMPLOYEE_ID AS ID_OF_THE_EMPLOYEE, LAST_NAME AS NAME_OF_THE_EMPLOYEE, DEPARTMENT_ID AS DEP_ID FROM EMPLOYEE;

 -- 7.  Listout theannualsalaryof theemployeeswiththeirnamesonly.

 SELECT LAST_NAME, SALARY FROM EMPLOYEE

 --- WHERE CONDITION ---

 -- 1. LIST THE DETAILS ABOUT 'SMITH'

 SELECT * FROM EMPLOYEE WHERE LAST_NAME='SMITH';

 -- 2. LIST OUT THE EMPLOYEES WHO ARE WORKING IN DEPARTMENT 20

 SELECT LAST_NAME FROM EMPLOYEE WHERE DEPARTMENT_ID=20

 -- 3. Listout the employees who are earning salaries between 3000 and 4500.

 SELECT LAST_NAME FROM EMPLOYEE WHERE SALARY BETWEEN 3001 AND 4499;

 --  4. List out the employees who are working in department 10 or 20.

 SELECT LAST_NAME FROM EMPLOYEE WHERE DEPARTMENT_ID=10 OR DEPARTMENT_ID=20

 -- 5. Find out the employees who are not working in department 10 or 30.

 SELECT LAST_NAME FROM EMPLOYEE WHERE NOT(DEPARTMENT_ID=30 OR DEPARTMENT_ID=10);

 -- 6. List out the employees whose name StartS with 'S'.

 SELECT LAST_NAME FROM EMPLOYEE WHERE LAST_NAME LIKE 'S%'

 -- 7. List out the employees whose name starts with 'S' and ends with'H'.

 SELECT LAST_NAME FROM EMPLOYEE WHERE LAST_NAME LIKE 'S%H';

 --8. List out the employees whose name length is 4 and start with'S'.

 SELECT LAST_NAME FROM EMPLOYEE WHERE LEN(LAST_NAME)=4 AND LAST_NAME LIKE 'S%';

 --  9. List out employees who are working in department 10 and draw salariesmore than 3500.

 SELECT LAST_NAME FROM EMPLOYEE WHERE DEPARTMENT_ID=10 AND SALARY>3500;

 -- 10.List out the employees who are not receiving commission.

 SELECT LAST_NAME FROM EMPLOYEE WHERE COMM IS NULL;

 -- ORDER BY CLAUSE --

 -- 1. List out the Employee ID and Last Name in ascending order based onthe Employee ID.

 SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEE ORDER BY EMPLOYEE_ID;

 -- 2. List out the Employee ID and Name in descending order based onsalary.

 SELECT EMPLOYEE_ID, LAST_NAME FROM EMPLOYEE ORDER BY SALARY DESC;

 -- 3. List out the employee details according to their Last Name in ascending-order.

 SELECT * FROM EMPLOYEE ORDER BY LAST_NAME;

 /* 4. List out the employee details according to their Last Name inascending
 order and then Department ID in descending order. */

 SELECT * FROM EMPLOYEE ORDER BY LAST_NAME, DEPARTMENT_ID desc;

 -- GROUP BY AND HAVING CLUASE --

 -- 1. Howmany employees are in different departments in theorganization?

 SELECT DEPARTMENT_ID, COUNT(EMPLOYEE_ID) AS CT_EMP FROM EMPLOYEE GROUP BY DEPARTMENT_ID;

 -- 2. List out the department wise maximum salary, minimum salaryand average salary of the employees.

 SELECT DEPARTMENT_ID,
 MAX(SALARY) AS MAX_SALARY, 
 MIN(SALARY) AS MIN_SALARY, 
 AVG(SALARY) AS AVG_SALARY
 FROM EMPLOYEE
 GROUP BY DEPARTMENT_ID


 /*  3. List out the job wise maximum salary, minimum salary andaverage
 salary of the employees.*/

 SELECT JOB_ID, 
 MAX(SALARY) AS MAX_SALARY, 
 MIN(SALARY) AS MIN_SALARY,
 AVG(SALARY) AS AVG_SALARY
 FROM EMPLOYEE
 GROUP BY JOB_ID;

 /* 4. List out the number of employees who joined each month in ascendingorder.*/

 SELECT DATENAME(MM, HIRE_DATE) AS MONTH_OF_JOINING, 
 COUNT(EMPLOYEE_ID) AS CT 
 FROM EMPLOYEE 
 GROUP BY DATENAME(MM, HIRE_DATE);

 /* 5. List out the number of employees for each month and yearin
 ascending order based on the year and month.*/

 SELECT YEAR(HIRE_DATE) AS YEAR_OF_JOINING, MONTH(HIRE_DATE) AS MONTH_OF_JOINING,COUNT(EMPLOYEE_ID) AS CT
 FROM EMPLOYEE 
 GROUP BY YEAR(HIRE_DATE), MONTH(HIRE_DATE)
 ORDER BY YEAR(HIRE_DATE), MONTH(HIRE_DATE)

 /*  6. List out the Department ID having at least four employees. */

 SELECT DEPARTMENT_ID, COUNT(DEPARTMENT_ID) FROM EMPLOYEE GROUP BY DEPARTMENT_ID HAVING COUNT(DEPARTMENT_ID)>=4;

 /* 7. Howmany employees joined in the month of January? */

 SELECT COUNT(EMPLOYEE_ID) AS CT FROM EMPLOYEE GROUP BY DATENAME(MM, HIRE_DATE) HAVING DATENAME(MM, HIRE_DATE)='JANUARY';

 -- ABOVE QUERY CAN ALSO BE SOLVED USING THE FOLLOWING QUERY:
SELECT COUNT(EMPLOYEE_ID) FROM EMPLOYEE WHERE DATENAME(MM,HIRE_DATE)='JANUARY';

/* 8. Howmany employees joined in the month of January orSeptember? */

SELECT DATENAME(MM, HIRE_DATE) AS MONTH_OF_JOINING, COUNT(EMPLOYEE_ID) AS CT FROM EMPLOYEE 
GROUP BY DATENAME(MM, HIRE_DATE) 
HAVING DATENAME(MM,HIRE_DATE)='JANUARY' OR DATENAME(MM, HIRE_DATE)='SEPTEMBER'

-- ABOVE QUERY CAN ALSO BE SOLVED IN THE FOLLOWING WAY:
SELECT COUNT(EMPLOYEE_ID) AS CT FROM EMPLOYEE
WHERE DATENAME(MM, HIRE_DATE)= 'JANUARY' OR DATENAME(MM, HIRE_DATE)= 'SEPTEMBER'


/* 9.  9. Howmany employees joined in 1985? */

SELECT COUNT(EMPLOYEE_ID) AS CT FROM EMPLOYEE 
GROUP BY YEAR(HIRE_DATE) 
HAVING YEAR(HIRE_DATE)=1985;

-- ABOVE QUERY CAN ALSO BE SOLVED IN THE FOLLOWING MANNER:
SELECT COUNT(EMPLOYEE_ID) AS CT FROM EMPLOYEE WHERE YEAR(HIRE_DATE)=1985;

/* 10. How many employees joined each month in 1985? */

SELECT YEAR(HIRE_DATE) AS YR,  MONTH(HIRE_DATE) AS MNTH, COUNT(EMPLOYEE_ID) AS CT 
FROM EMPLOYEE 
GROUP BY YEAR(HIRE_DATE), MONTH(HIRE_DATE) 
HAVING YEAR(HIRE_DATE)=1985;

/* 11. 11. How many employees joined in March 1985? */

SELECT YEAR(HIRE_DATE) AS YR, MONTH(HIRE_DATE) AS MNTH, COUNT(EMPLOYEE_ID) AS CT FROM EMPLOYEE
GROUP BY YEAR(HIRE_DATE), MONTH(HIRE_DATE)
HAVING YEAR(HIRE_DATE)=1985 AND MONTH(HIRE_DATE)=3

-- THE QUERY CAN BE SOLVED WITH THE FOLLOWING: 
SELECT COUNT(EMPLOYEE_ID) AS CT FROM EMPLOYEE
WHERE YEAR(HIRE_DATE)=1985 AND MONTH(HIRE_DATE)=3;


/* 12. Which is the Department ID having greater than or equal to 3employees
 joining in April 1985? */

SELECT COUNT(DEPARTMENT_ID) AS CT, DEPARTMENT_ID FROM EMPLOYEE
GROUP BY DEPARTMENT_ID, YEAR(HIRE_DATE), MONTH(HIRE_DATE)
HAVING YEAR(HIRE_DATE)=1985 AND MONTH(HIRE_DATE)=4 AND COUNT(DEPARTMENT_ID)>=3; 

--- JOIINS ---

SELECT * FROM EMPLOYEE
SELECT * FROM DEPARTMENT
SELECT * FROM JOB
SELECT * FROM LOCATION


-- 1.  List out employees with their department names.

SELECT LAST_NAME, NAME
FROM EMPLOYEE AS E
INNER JOIN
DEPARTMENT AS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID

-- 2. Display employees with their designations.

SELECT LAST_NAME, DESIGNATION
FROM EMPLOYEE AS E
INNER JOIN
JOB AS J
ON E.JOB_ID=J.JOB_ID

--  3. Display the employees with their department names and regionalgroups.

SELECT LAST_NAME, NAME, CITY
FROM EMPLOYEE AS E
INNER JOIN
DEPARTMENT AS D
ON E.DEPARTMENT_ID = D.DEPARTMENT_ID
INNER JOIN
LOCATION AS L
ON D.LOCATION_ID=L.LOCATION_ID


--  4. How many employees are working in different departments? Display with department names.

SELECT NAME, COUNT(EMPLOYEE_ID) AS CT FROM
EMPLOYEE AS E
RIGHT JOIN
DEPARTMENT AS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY NAME

-- 5. How many employees are working in the sales department?

SELECT COUNT(EMPLOYEE_ID) AS CT, NAME
FROM EMPLOYEE AS E
INNER JOIN
DEPARTMENT AS D
ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
GROUP BY NAME
HAVING NAME='SALES';
 

 --  6. Which is the department having greater than or equal to 5 employees? Display the department names in ascending order.

 SELECT COUNT(EMPLOYEE_ID) AS CT, NAME
 FROM
 EMPLOYEE AS E
 INNER JOIN
 DEPARTMENT AS D
 ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
 GROUP BY NAME
 HAVING COUNT(EMPLOYEE_ID)>=5;

 -- 7. How many jobs are there in the organization? Display with designations.

 SELECT COUNT(EMPLOYEE_ID) AS CT, DESIGNATION
 FROM EMPLOYEE AS E
 INNER JOIN
 JOB AS J
 ON E.JOB_ID=J.JOB_ID
 GROUP BY DESIGNATION

 --  8. How many employees are working in "New York"?

 SELECT COUNT(EMPLOYEE_ID) CT, CITY
 FROM EMPLOYEE AS E
 INNER JOIN
 DEPARTMENT AS D
 ON E.DEPARTMENT_ID=D.DEPARTMENT_ID
 INNER JOIN
 LOCATION AS L
 ON D.LOCATION_ID=L.LOCATION_ID
 GROUP BY CITY
 HAVING CITY='NEW YORK'

 --  9. Display the employee details with salary grades. Use conditional statement to create a grade column

 SELECT LAST_NAME, SALARY,
 CASE
 WHEN SALARY<1000 THEN 'D'
 WHEN SALARY BETWEEN 1000 AND 1999 THEN 'C'
 WHEN SALARY BETWEEN 2000 AND 2499 THEN 'B'
 ELSE 'A'
 END
 AS SALARY_GRADE
 FROM EMPLOYEE
 ORDER BY SALARY DESC;

 -- 10. List out the number of employees grade wise. Use conditional statement to create a grade column

 WITH SALARY_GRADE AS
 (
 SELECT *,
 CASE
 WHEN SALARY<1000 THEN 'D'
 WHEN SALARY BETWEEN 1000 AND 1999 THEN 'C'
 WHEN SALARY BETWEEN 2000 AND 2499 THEN 'B'
 ELSE 'A'
 END
 AS GRADE_SALARY 
 FROM EMPLOYEE
 )
 SELECT COUNT(*) AS CT, GRADE_SALARY
 FROM SALARY_GRADE 
 GROUP BY GRADE_SALARY

 -- 11.Display the employee salary grades and the number ofemployees between 2000 to 5000 range of salary.

 WITH SALARY_GRADE AS
 (
 SELECT *,
 CASE
 WHEN SALARY<1000 THEN 'D'
 WHEN SALARY BETWEEN 1000 AND 1999 THEN 'C'
 WHEN SALARY BETWEEN 2000 AND 2499 THEN 'B'
 ELSE 'A'
 END
 AS GRADE_SALARY 
 FROM EMPLOYEE
 )
 SELECT COUNT(*) AS CT, GRADE_SALARY
 FROM SALARY_GRADE
 WHERE GRADE_SALARY='B' OR GRADE_SALARY='A'
 GROUP BY GRADE_SALARY


 --- SET OPERATORS ----

-- 1. List out the distinct jobs in sales and accounting departments.

SELECT * FROM LOCATION
SELECT * FROM EMPLOYEE
SELECT * FROM DEPARTMENT
SELECT * FROM JOB

SELECT DISTINCT NAME, DESIGNATION, J.JOB_ID FROM JOB AS J
INNER JOIN
EMPLOYEE AS E
ON J.JOB_ID=E.JOB_ID
INNER JOIN
DEPARTMENT AS D
ON D.DEPARTMENT_ID=E.DEPARTMENT_ID
WHERE NAME='SALES' OR NAME='RESEARCH' 

-- 2. List out all the jobs in sales and accounting departments.

SELECT NAME, DESIGNATION, J.JOB_ID FROM JOB AS J
INNER JOIN
EMPLOYEE AS E
ON J.JOB_ID=E.JOB_ID
INNER JOIN
DEPARTMENT AS D
ON D.DEPARTMENT_ID=E.DEPARTMENT_ID
WHERE NAME='SALES' OR NAME='ACCOUNTING' 

--  3. List out the common jobs in research and accounting departments in ascending order.

select job_id from EMPLOYEE where DEPARTMENT_ID=10
INTERSECT
select job_id from EMPLOYEE where DEPARTMENT_ID=30

---- sub quereis ----

select * from employee
select * from department
select * from job
select * from location

-- 1. Display the employees list who got the maximum salary

select last_name from employee where salary = (select max(salary) from employee);

--  2. Display the employees who are working in the salesdepartment.

select last_name from employee where department_id = (select department_id from department where name='sales');

--  3. Display the employees who are working as 'Clerk'.

select last_name from employee where job_id = (select job_id from job where designation='clerk');

--  4. Display the list of employees who are living in "New York".

select last_name from EMPLOYEE where 
DEPARTMENT_ID = (select DEPARTMENT_ID from DEPARTMENT where
LOCATION_ID = (select LOCATION_ID from LOCATION where CITY='new york'));

--- Alternatively it can be executed as follows: ----
select last_name from EMPLOYEE as e
inner join
DEPARTMENT as d
on e.DEPARTMENT_ID=d.DEPARTMENT_ID
inner join
LOCATION as l
on d.LOCATION_ID=l.LOCATION_ID
where l.LOCATION_ID = (select LOCATION_ID from LOCATION where CITY='New York');

--  5. Find out the number of employees working in the salesdepartment

select count(last_name) as ct from EMPLOYEE where DEPARTMENT_ID = (select DEPARTMENT_ID from DEPARTMENT where name='sales');

--  6. Update the salaries of employees who are working as clerks on the basis of 10%

select * from EMPLOYEE
select * from DEPARTMENT
select * from JOB

-- In the designation column in job table, clerk is spelled wrongly as 'clerk'
-- Let us first correct our spelling mistake

update job
set DESIGNATION='CLERK' WHERE JOB_ID=667;

update EMPLOYEE
set SALARY=salary*1.10
where JOB_ID = (select JOB_ID from job where DESIGNATION='clerk');

-- 7. Delete the employees who are working in the accounting department

DELETE FROM EMPLOYEE WHERE DEPARTMENT_ID = (SELECT DEPARTMENT_ID FROM DEPARTMENT WHERE NAME='ACCOUNTING');

-- 8. Display the second highest salary drawing employee details

select * from (
select *, DENSE_RANK() over(order by salary desc) as rnk
from EMPLOYEE) as rnk_salary
where rnk=2;

--  9. Display the nth highest salary drawing employee details.

declare @n int;
set @n=3;

select * from (
select *, DENSE_RANK() over(order by salary desc) as rnk
from EMPLOYEE) as rnk_salary
where rnk=@n;

-- Here, we are declaring the variable n and making it dynamic
-- We are also initializin the variable with int=3,
-- If, we do not intialize the variable, and use it in the query, it will return an error, as the variable is null by default 

-- We can use the above query and change the value of set @n = n to retrieve the nth highest salary
-- In the above code we have retrieved the salary for the 3rd highest salary

--  10. List out the employees who earn more than every employee in department30.

select * from (
select *, DENSE_RANK() over(order by salary desc) as rnk from employee where DEPARTMENT_ID=30) 
as rnk_dep30
where rnk=1

-- 11. List out the employees who earn more than the lowest salary in department.

select e.DEPARTMENT_ID, last_name, salary from employee as e
inner join
(select department_id, min(salary) as min_salary from employee group by DEPARTMENT_ID) as min_dep_sal
on e.DEPARTMENT_ID=min_dep_sal.DEPARTMENT_ID
where e.SALARY>min_salary;

-- We can also solve the above query using CTE

with min_salary as
(
select department_id, min(salary) as min_salary from EMPLOYEE group by DEPARTMENT_ID
)
select * from min_salary
inner join
(select department_id, last_name, salary from EMPLOYEE) as e
on min_salary.DEPARTMENT_ID=e.DEPARTMENT_ID
where e.SALARY>min_salary

--12. Find out whose department has no employees.

select name, d.DEPARTMENT_ID, EMPLOYEE_ID from DEPARTMENT as d
left join
EMPLOYEE as e
on d.DEPARTMENT_ID=e.DEPARTMENT_ID
where EMPLOYEE_ID is null;

-- 13. Find out the employees who earn greater than the average salary for their department

with avg_sal
as
(
select department_id, avg(salary) as avg_salary from EMPLOYEE group by DEPARTMENT_ID
)
select * from avg_sal
inner join
(select last_name, SALARY, DEPARTMENT_ID from EMPLOYEE) as e
on avg_sal.DEPARTMENT_ID=e.department_id
where SALARY>avg_salary
