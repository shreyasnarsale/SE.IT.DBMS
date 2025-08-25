//MySQL Function for Salary Normalization:-

DELIMITER $$

CREATE FUNCTION normalize_salary(
    salary DECIMAL(10,2), 
    min_salary DECIMAL(10,2), 
    max_salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,4)
DETERMINISTIC
BEGIN
    DECLARE norm DECIMAL(10,4);

    IF max_salary = min_salary THEN
        SET norm = 0; -- avoid division by zero
    ELSE
        SET norm = (salary - min_salary) / (max_salary - min_salary);
    END IF;

    RETURN norm;
END$$

DELIMITER ;
             


//First get the min and max salary:-

SELECT MIN(salary) AS min_sal, MAX(salary) AS max_sal FROM employees;


//Apply Normalization

SELECT emp_id, emp_name, salary,
       normalize_salary(salary, 
                        (SELECT MIN(salary) FROM employees),
                        (SELECT MAX(salary) FROM employees)) AS normalized_salary
FROM employees;



//Compute stats (min, max, avg, etc.)

SELECT 
    MIN(salary)   AS min_salary,
    MAX(salary)   AS max_salary,
    AVG(salary)   AS avg_salary,
    STDDEV(salary) AS stddev_salary,
    VARIANCE(salary) AS var_salary
FROM employees;


//Normalization Function (as before)

DELIMITER $$

CREATE FUNCTION normalize_salary(
    salary DECIMAL(10,2), 
    min_salary DECIMAL(10,2), 
    max_salary DECIMAL(10,2)
)
RETURNS DECIMAL(10,4)
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

//Salary Categorization Function:-

DELIMITER $$

CREATE FUNCTION salary_category(norm DECIMAL(10,4))
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE category VARCHAR(20);

    IF norm < 0.33 THEN
        SET category = 'Low';
    ELSEIF norm < 0.66 THEN
        SET category = 'Medium';
    ELSE
        SET category = 'High';
    END IF;

    RETURN category;
END$$

DELIMITER ;

//ALL Query

SELECT 
    e.emp_id, 
    e.emp_name, 
    e.salary,
    (SELECT MIN(salary) FROM employees) AS min_salary,
    (SELECT MAX(salary) FROM employees) AS max_salary,
    (SELECT AVG(salary) FROM employees) AS avg_salary,
    normalize_salary(
        e.salary, 
        (SELECT MIN(salary) FROM employees),
        (SELECT MAX(salary) FROM employees)
    ) AS normalized_salary,
    salary_category(
        normalize_salary(
            e.salary, 
            (SELECT MIN(salary) FROM employees),
            (SELECT MAX(salary) FROM employees)
        )
    ) AS category
FROM employees e;
                                                                                                                                                                                                                                                                                                                                                                                                                           