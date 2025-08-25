-- ==============================================================
--          MYSQL PRACTICE SCRIPT WITH OUTPUTS
-- ==============================================================

-- 1) CREATE DATABASE & USE IT
CREATE DATABASE companyDB;
USE companyDB;

-- ==============================================================
-- 2) CREATE TABLES
-- ==============================================================

CREATE TABLE departments (
    dept_id INT PRIMARY KEY AUTO_INCREMENT,
    dept_name VARCHAR(50) UNIQUE NOT NULL,
    location VARCHAR(50) DEFAULT 'Not Assigned'
);

CREATE TABLE employees (
    emp_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    department_id INT,
    salary DECIMAL(10,2),
    hire_date DATE NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    notes TEXT,
    FOREIGN KEY (department_id) REFERENCES departments(dept_id)
);

CREATE TABLE salary_audit (
    audit_id INT PRIMARY KEY AUTO_INCREMENT,
    emp_id INT,
    old_salary DECIMAL(10,2),
    new_salary DECIMAL(10,2),
    changed_on TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- ==============================================================
-- 3) SHOW STRUCTURE
-- ==============================================================

DESC departments;
-- +---------+-------------+------+-----+-------------+----------------+
-- | Field   | Type        | Null | Key | Default     | Extra          |
-- +---------+-------------+------+-----+-------------+----------------+
-- | dept_id | int         | NO   | PRI | NULL        | auto_increment |
-- | dept_name | varchar(50) | NO | UNI | NULL        |                |
-- | location | varchar(50) | YES |     | Not Assigned|                |
-- +---------+-------------+------+-----+-------------+----------------+

DESC employees;
-- +-------------+--------------+------+-----+---------+----------------+
-- | Field       | Type         | Null | Key | Default | Extra          |
-- +-------------+--------------+------+-----+---------+----------------+
-- | emp_id      | int          | NO   | PRI | NULL    | auto_increment |
-- | emp_name    | varchar(100) | NO   |     | NULL    |                |
-- | email       | varchar(100) | YES  | UNI | NULL    |                |
-- | department_id| int         | YES  | MUL | NULL    |                |
-- | salary      | decimal(10,2)| YES  |     | NULL    |                |
-- | hire_date   | date         | NO   |     | NULL    |                |
-- | is_active   | tinyint(1)   | YES  |     | 1       |                |
-- | notes       | text         | YES  |     | NULL    |                |
-- +-------------+--------------+------+-----+---------+----------------+

DESC salary_audit;
-- +-----------+--------------+------+-----+-------------------+----------------+
-- | Field     | Type         | Null | Key | Default           | Extra          |
-- +-----------+--------------+------+-----+-------------------+----------------+
-- | audit_id  | int          | NO   | PRI | NULL              | auto_increment |
-- | emp_id    | int          | YES  |     | NULL              |                |
-- | old_salary| decimal(10,2)| YES  |     | NULL              |                |
-- | new_salary| decimal(10,2)| YES  |     | NULL              |                |
-- | changed_on| timestamp    | YES  |     | CURRENT_TIMESTAMP |                |
-- +-----------+--------------+------+-----+-------------------+----------------+

-- ==============================================================
-- 4) INSERT SAMPLE DATA
-- ==============================================================

INSERT INTO departments (dept_name, location) VALUES
('HR', 'Delhi'),
('Finance', 'Mumbai'),
('IT', 'Bangalore'),
('Marketing', 'Chennai');

INSERT INTO employees (emp_name, email, department_id, salary, hire_date, notes) VALUES
('John', 'john@example.com', 1, 20000, '2020-01-10', 'Joined as fresher'),
('Meera', 'meera@example.com', 2, 50000, '2019-07-23', 'Promoted in 2021'),
('Raj', 'raj@example.com', 3, 100000, '2018-03-15', 'Senior Manager'),
('Sita', 'sita@example.com', 2, 75000, '2021-11-01', NULL),
('Amit', 'amit@example.com', 1, 30000, '2022-04-18', 'New hire');

-- ==============================================================
-- 5) BASIC SELECTS
-- ==============================================================

SELECT * FROM employees;
-- +-------+--------+------------------+---------------+----------+------------+-----------+--------------------+
-- | emp_id| emp_name | email           | department_id | salary   | hire_date  | is_active | notes              |
-- +-------+--------+------------------+---------------+----------+------------+-----------+--------------------+
-- | 1     | John    | john@example.com| 1             | 20000.00 | 2020-01-10 | 1         | Joined as fresher  |
-- | 2     | Meera   | meera@example.com| 2            | 50000.00 | 2019-07-23 | 1         | Promoted in 2021   |
-- | 3     | Raj     | raj@example.com | 3             |100000.00 | 2018-03-15 | 1         | Senior Manager     |
-- | 4     | Sita    | sita@example.com| 2             | 75000.00 | 2021-11-01 | 1         | NULL               |
-- | 5     | Amit    | amit@example.com| 1             | 30000.00 | 2022-04-18 | 1         | New hire           |
-- +-------+--------+------------------+---------------+----------+------------+-----------+--------------------+

SELECT emp_name, salary FROM employees;
-- +----------+----------+
-- | emp_name | salary   |
-- +----------+----------+
-- | John     | 20000.00 |
-- | Meera    | 50000.00 |
-- | Raj      |100000.00 |
-- | Sita     | 75000.00 |
-- | Amit     | 30000.00 |
-- +----------+----------+

-- ==============================================================
-- 6) UPDATE DATA
-- ==============================================================

UPDATE employees SET salary = salary + 5000 WHERE emp_name = 'Amit';
SELECT emp_name, salary FROM employees WHERE emp_name = 'Amit';
-- +----------+----------+
-- | emp_name | salary   |
-- +----------+----------+
-- | Amit     | 35000.00 |
-- +----------+----------+

-- ==============================================================
-- 7) DELETE DATA
-- ==============================================================

DELETE FROM employees WHERE emp_name = 'John';
SELECT * FROM employees;
-- John is removed from table

-- ==============================================================
-- 8) JOINS
-- ==============================================================

SELECT e.emp_name, d.dept_name, e.salary
FROM employees e
JOIN departments d ON e.department_id = d.dept_id;
-- +----------+-----------+----------+
-- | emp_name | dept_name | salary   |
-- +----------+-----------+----------+
-- | Meera    | Finance   | 50000.00 |
-- | Raj      | IT        |100000.00 |
-- | Sita     | Finance   | 75000.00 |
-- | Amit     | HR        | 35000.00 |
-- +----------+-----------+----------+

-- ==============================================================
-- 9) AGGREGATE FUNCTIONS
-- ==============================================================

SELECT MIN(salary) AS min_salary,
       MAX(salary) AS max_salary,
       AVG(salary) AS avg_salary,
       SUM(salary) AS total_salary,
       COUNT(*) AS total_employees
FROM employees;
-- +-----------+-----------+-----------+--------------+----------------+
-- | min_salary| max_salary| avg_salary| total_salary | total_employees|
-- +-----------+-----------+-----------+--------------+----------------+
-- | 35000.00  |100000.00  | 65000.00  | 260000.00    | 4              |
-- +-----------+-----------+-----------+--------------+----------------+

-- ==============================================================
-- 10) GROUP BY & HAVING
-- ==============================================================

SELECT d.dept_name, COUNT(e.emp_id) AS total_employees, AVG(e.salary) AS avg_salary
FROM employees e
JOIN departments d ON e.department_id = d.dept_id
GROUP BY d.dept_name
HAVING avg_salary > 40000;
-- +-----------+----------------+-----------+
-- | dept_name | total_employees| avg_salary|
-- +-----------+----------------+-----------+
-- | Finance   | 2              | 62500.00  |
-- | IT        | 1              |100000.00  |
-- +-----------+----------------+-----------+

-- ==============================================================
-- 11) FUNCTIONS & NORMALIZATION
-- ==============================================================

DELIMITER $$
CREATE FUNCTION normalize_salary(
    salary DECIMAL(10,2), 
    min_salary DECIMAL(10,2), 
    max_salary DECIMAL(10,2)
) RETURNS DECIMAL(10,4)
DETERMINISTIC
BEGIN
    DECLARE norm DECIMAL(10,4);
    IF max_salary = min_salary THEN
        SET norm = 0;
    ELSE
        SET norm = (salary - min_salary) / (max_salary - min_salary);
    END IF;
    RETURN norm;
END$$
DELIMITER ;

SELECT emp_id, emp_name, salary,
       normalize_salary(
         salary, 
         (SELECT MIN(salary) FROM employees), 
         (SELECT MAX(salary) FROM employees)
       ) AS normalized_salary
FROM employees;
-- +-------+----------+----------+------------------+
-- | emp_id| emp_name | salary   | normalized_salary|
-- +-------+----------+----------+------------------+
-- | 2     | Meera    | 50000.00 | 0.2308           |
-- | 3     | Raj      |100000.00 | 1.0000           |
-- | 4     | Sita     | 75000.00 | 0.6154           |
-- | 5     | Amit     | 35000.00 | 0.0000           |
-- +-------+----------+----------+------------------+

-- ==============================================================
-- 12) WINDOW FUNCTIONS
-- ==============================================================

SELECT emp_name, salary,
       RANK() OVER (ORDER BY salary DESC) AS salary_rank,
       DENSE_RANK() OVER (ORDER BY salary DESC) AS salary_dense_rank,
       ROW_NUMBER() OVER (ORDER BY salary DESC) AS row_num
FROM employees;
-- +----------+----------+-------------+-------------------+---------+
-- | emp_name | salary   | salary_rank | salary_dense_rank | row_num |
-- +----------+----------+-------------+-------------------+---------+
-- | Raj      |100000.00 | 1           | 1                 | 1       |
-- | Sita     | 75000.00 | 2           | 2                 | 2       |
-- | Meera    | 50000.00 | 3           | 3                 | 3       |
-- | Amit     | 35000.00 | 4           | 4                 | 4       |
-- +----------+----------+-------------+-------------------+---------+

-- ==============================================================
-- 13) TRIGGERS DEMO
-- ==============================================================

DELIMITER $$
CREATE TRIGGER salary_update_trigger
BEFORE UPDATE ON employees
FOR EACH ROW
BEGIN
    INSERT INTO salary_audit(emp_id, old_salary, new_salary)
    VALUES (OLD.emp_id, OLD.salary, NEW.salary);
END$$
DELIMITER ;

UPDATE employees SET salary = 80000 WHERE emp_name = 'Meera';
SELECT * FROM salary_audit;
-- +---------+--------+------------+-----------+---------------------+
-- | audit_id| emp_id | old_salary | new_salary| changed_on          |
-- +---------+--------+------------+-----------+---------------------+
-- | 1       | 2      | 50000.00   | 80000.00  | 2025-08-25 16:20:00 |
-- +---------+--------+------------+-----------+---------------------+

-- ==============================================================
-- 14) PRACTICE QUESTIONS (WITH OUTPUTS)
-- ==============================================================

-- Q1: List employees with salary above 50k
SELECT emp_name, salary FROM employees WHERE salary > 50000;
-- +----------+----------+
-- | emp_name | salary   |
-- +----------+----------+
-- | Raj      |100000.00 |
-- | Sita     | 75000.00 |
-- | Meera    | 80000.00 |
-- +----------+----------+

-- Q2: Find total salary department-wise
SELECT d.dept_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d ON e.department_id = d.dept_id
GROUP BY d.dept_name;
-- +-----------+--------------+
-- | dept_name | total_salary |
-- +-----------+--------------+
-- | Finance   |155000.00     |
-- | IT        |100000.00     |
-- | HR        | 35000.00     |
-- +-----------+--------------+

-- Q3: Show highest paid employee
SELECT emp_name, salary FROM employees ORDER BY salary DESC LIMIT 1;
-- +----------+----------+
-- | emp_name | salary   |
-- +----------+----------+
-- | Raj      |100000.00 |
-- +----------+----------+

-- Q4: Find employees hired after 2020
SELECT emp_name, hire_date FROM employees WHERE hire_date > '2020-01-01';
-- +----------+------------+
-- | emp_name | hire_date  |
-- +----------+------------+
-- | Sita     | 2021-11-01 |
-- | Amit     | 2022-04-18 |
-- +----------+------------+

-- Q5: Show employees with normalized salary > 0.5
SELECT emp_name, salary,
       normalize_salary(salary, 
                        (SELECT MIN(salary) FROM employees),
                        (SELECT MAX(salary) FROM employees)) AS norm
FROM employees
HAVING norm > 0.5;
-- +----------+----------+--------+
-- | emp_name | salary   | norm   |
-- +----------+----------+--------+
-- | Raj      |100000.00 | 1.0000 |
-- | Sita     | 75000.00 | 0.6154 |
-- | Meera    | 80000.00 | 0.6923 |
-- +----------+----------+--------+

-- ==============================================================
--                             END
-- ==============================================================

