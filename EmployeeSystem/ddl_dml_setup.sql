CREATE DATABASE "EmployeeSystem"
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    LC_COLLATE = 'en_US.UTF-8'
    LC_CTYPE = 'en_US.UTF-8'
    TABLESPACE = pg_default
    CONNECTION LIMIT = -1
    IS_TEMPLATE = False;

-----------------------------------------------------------------
SET search_path TO public;

CREATE TABLE Employee (
    id INTEGER,
    name VARCHAR(255),
    email VARCHAR(255),
    salary INTEGER,
    managerId INTEGER, -- note that managerid is the id of a record (a manager) in the Employee table
    experience_years INTEGER,
    CONSTRAINT pk_Employee PRIMARY KEY (id)
);
      
INSERT INTO Employee (id, name, email, salary, managerId,
experience_years) values (1, 'Tom', 'a@b.com', 70000, 3, 3);
INSERT INTO Employee (id, name, email, salary, managerId,
experience_years) values (2, 'John', 'c@d.com', 80000, 4, 2);
INSERT INTO Employee (id, name,email, salary, managerId,
experience_years) values (3, 'Katrina', 'a@b.com', 98000, NULL, 1);
INSERT INTO Employee (id, name,email, salary, managerId,
experience_years) values (4, 'Namy', 't@b.com', 90000, NULL, 2);
INSERT INTO Employee (id, name, email, salary, managerId,
experience_years) values (5, 'Jim', 'j@d.com', 100000, 4, 15);

-----------------------------------------------------------------
CREATE TABLE Project (
    project_id INTEGER,
    employee_id INTEGER,
    CONSTRAINT pk_Project PRIMARY KEY (project_id, employee_id),
    FOREIGN KEY (employee_id) REFERENCES Employee(id)
);

INSERT INTO Project (project_id, employee_id) values (1, 1);
INSERT INTO Project (project_id, employee_id) values (1, 2);
INSERT INTO Project (project_id, employee_id) values (1, 3);
INSERT INTO Project (project_id, employee_id) values (2, 1);
INSERT INTO Project (project_id, employee_id) values (2, 4);
      
-----------------------------------------------------------------
CREATE TABLE departments(
    department_id INTEGER NOT NULL,
    department_name CHAR(50) NOT NULL,
    CONSTRAINT pk_departments PRIMARY KEY (department_id)
);

INSERT INTO departments(department_id,department_name) VALUES(10, 'sales');
INSERT INTO departments(department_id,department_name) VALUES(20, 'marketing');
INSERT INTO departments(department_id,department_name) VALUES(30, 'accounting');

-----------------------------------------------------------------
CREATE TABLE DepartmentProjects (
    department_id INTEGER,
    project_id INTEGER,
    CONSTRAINT pk_DepartmentProjects PRIMARY KEY (department_id, project_id),
    FOREIGN KEY (department_id) REFERENCES departments(department_id),
    FOREIGN KEY (project_id) REFERENCES Project(project_id)
);
INSERT INTO DepartmentProjects (department_id, project_id) VALUES (10,1);
INSERT INTO DepartmentProjects (department_id, project_id) VALUES (20,2);