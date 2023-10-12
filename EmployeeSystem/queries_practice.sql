/* 
Write an SQL query to find the names of employees
with salary higher than the average salary.
*/
SELECT e.name
FROM Employee e
WHERE e.salary > (SELECT AVG(salary) FROM Employee);

/*
Write an SQL query to find the second 
highest distinct salary in the Employee table.
*/
-- helpful to visualize/confirm answer
SELECT 
	e.name, e.salary,
	DENSE_RANK() OVER(ORDER BY e.salary DESC) as salary_rank
FROM Employee e
ORDER BY e.salary DESC

SELECT salary
FROM
(
	SELECT 
		e.*,
		DENSE_RANK() OVER(ORDER BY e.salary DESC) as salary_rank
	FROM Employee e
) as emp_w_ranks
WHERE emp_w_ranks.salary_rank = 2;

-- alternative solution
SELECT max(e.salary)
FROM Employee e
WHERE e.salary < (SELECT max(salary) FROM Employee)

/*
What index would you create to improve
the performance of the above query and why?
*/
CREATE INDEX idx_salary ON Employee(salary);

/*
Why:
The index on salary would speed up the look-up for both the outer and inner queries which are based on the salary.
For both the inner and outer queries, operations are being performed based on the salary column.
Without the index, for each of these operations, the database would have to scan the entire table. 
With the index:
- The inner subquery can quickly identify the maximum salary without scanning every row.
- The outer query can efficiently filter out the employees having the maximum salary and then identify the second maximum salary.
*/

/*
Write an SQL query to find all
duplicate emails in the Employee table.
*/
SELECT email
FROM
(
	SELECT count(*) as cnt_emails, e.email
	FROM Employee e
	GROUP BY e.email
	HAVING count(*) > 1
) as dupe_emails;


/*
Write an SQL query to find the employees
who earn more than their managers.
*/
SELECT
	e1.name as emp_name, e1.salary as emp_salary,
	e2.name as mngr_name, e2.salary as mngr_salary
FROM Employee e1, Employee e2
WHERE e1.managerId = e2.id
AND e1.salary > e2.salary

/*
Write an SQL query that reports the average
experience years of all the employees for each project.
*/
SELECT p.project_id, AVG(e.experience_years) as avg_exp
FROM Employee e, Project p
WHERE e.id = p.employee_id
GROUP BY p.project_id;

/*
Write an SQL query to list employee names,
their manager names and the number of projects
the employees are associated with.
*/
SELECT e1.name as emp_name, e2.name as mngr_name, count(p.project_id) as num_projects
FROM Employee e1, Employee e2, Project p
WHERE e1.managerId = e2.id
AND e1.id = p.employee_id
GROUP BY e1.name, e2.name;

/*
Write an SQL query that lists the names
of managers of employees who are working
on projects under more than 1 department.
*/

-- helpful query to verify answer
SELECT e.name, dp.project_id, dp.department_id
FROM Employee e, Project p, DepartmentProjects dp
WHERE e.id = p.employee_id
AND p.project_id = dp.project_id

-- employees working on projects in multiple departments
SELECT e.id, e.name, e.managerId, count(distinct dp.department_id) as cnt_dpt
FROM Employee e, Project p, DepartmentProjects dp
WHERE e.id = p.employee_id
AND p.project_id = dp.project_id
GROUP BY e.id, e.name, e.managerId

WITH emp_cnt_dpt as (
	SELECT e.id, e.name, e.managerId, count(distinct dp.department_id) as cnt_dpt
	FROM Employee e, Project p, DepartmentProjects dp
	WHERE e.id = p.employee_id
	AND p.project_id = dp.project_id
	GROUP BY e.id, e.name, e.managerId
)

SELECT e2.name as mngr_name
FROM emp_cnt_dpt e1, Employee e2
WHERE e1.cnt_dpt > 1
AND e1.managerId = e2.id

/*
Based on the departments table, create an SQL table
called employeeDepts that matches employees to departments.
Assume (and enforce) that an employee can work in
a single department. Don’t forget to add the right primary and foreign keys.
*/
-- first update employee table to have primary key
ALTER TABLE employee ADD CONSTRAINT pk_employee PRIMARY KEY(id);

CREATE TABLE employeeDepts (
	employee_id INTEGER,
	department_id INTEGER,
	CONSTRAINT pk_employeeDepts PRIMARY KEY (employee_id), -- emp can work only in single department
	FOREIGN KEY (employee_id) REFERENCES Employee(id),
	FOREIGN KEY (department_id) REFERENCES departments(department_id)
)

/*
Show SQL code to create a table to import the csv
data in https://drive.google.com/file/d/1Uwpit1sCWyw0rKCYWepMy1wE1U_-lovN/

Import the csv data in the previous problem into your database. Show your code.
*/

CREATE TABLE ConsumerComplaints (
	DateReceived DATE,
	ProductName VARCHAR(255),
	Issue VARCHAR(255),
	Company VARCHAR(200),
	StateName CHAR(2),
	ZipCode VARCHAR(5),
	SubmittedVia VARCHAR(100),
	DateSentToCompany DATE,
	CompanyResponseToConsumer VARCHAR(100),
	TimelyResponse VARCHAR(3),
	ConsumerDisputed VARCHAR(3),
	ComplaintID INTEGER
)

COPY ConsumerComplaints
FROM '/Users/Tarek/Documents/UCI_MDS_Coding/cs224P/HW/1-Assignment/ConsumerComplaints.csv'
DELIMITER ',' CSV HEADER;

/*
Write SQL query to show for each type of product name
the average number of days between the date when a complaint
is received and the date it is sent to the company, sorted
by decreasing difference.
*/

-- practice query to understand DATE_PART fn
SELECT 
	DateReceived, DateSentToCompany, DateSentToCompany - DateReceived as NumOfDaysToProcess
FROM ConsumerComplaints
WHERE ComplaintID = 468882;
