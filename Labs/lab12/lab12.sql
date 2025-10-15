DROP TABLE IF EXISTS Employees CASCADE;
CREATE TABLE Employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    email VARCHAR(100)
);

INSERT INTO Employees (name, department, salary, email) VALUES
('Aibek', 'Engineering', 95000, 'aibek@company.com'),
('Ainura', 'Engineering', 72000, 'ainura@company.com'),
('Bakyt', 'Sales', 68000, 'bakyt@company.com'),
('Meerim', 'HR', 52000, 'meerim@company.com'),
('Tilek', 'Sales', 88000, 'tilek@company.com'),
('Anna', 'Engineering', 110000, 'anna@gmail.com'),
('Boris', 'Marketing', 60000, 'boris@yahoo.com'),
('Arslan', 'Engineering', 40000, 'arslan@gmail.com');

-- 1. Простые SELECT-запросы


-- все столбцы
SELECT * FROM Employees;

-- имя и отдел
SELECT name, department FROM Employees;

-- расчёт дополнительного поля (10% бонус)
SELECT name, salary, salary * 0.10 AS potential_bonus
FROM Employees;

-- 2. WHERE: фильтрация

-- все сотрудники отдела Sales
SELECT name, salary
FROM Employees
WHERE department = 'Sales';

-- сотрудники Engineering с зарплатой выше 75 000
SELECT name, salary
FROM Employees
WHERE salary > 75000 AND department = 'Engineering';

-- 3. BETWEEN и NULL-проверки

-- зп между 60 000 и 90 000
SELECT name, salary
FROM Employees
WHERE salary BETWEEN 60000 AND 90000;

-- 4. LIKE и ILIKE

-- имена, начинающиеся на 'A'
SELECT name
FROM Employees
WHERE name LIKE 'A%';

-- mail-адреса
SELECT name, email
FROM Employees
WHERE email ILIKE '%@gmail.com';

-- 5. Регулярные выражения

-- имена, начинающиеся на A или B
SELECT name
FROM Employees
WHERE name ~ '^[AB]';

-- проверка, что email выглядит корректно
SELECT name, email
FROM Employees
WHERE email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$';

-- 6. IN и EXISTS

-- сотрудники отделов Engineering или Sales
SELECT name, department
FROM Employees
WHERE department IN ('Engineering', 'Sales');

-- пример с подзапросом (все сотрудники, у которых есть зарплата выше средней)
SELECT name, salary
FROM Employees
WHERE salary > (SELECT AVG(salary) FROM Employees);

-- 7. CASE: логика внутри SELECT


SELECT name, salary,
  CASE
    WHEN salary > 100000 THEN 'Senior'
    WHEN salary BETWEEN 70000 AND 100000 THEN 'Mid-Level'
    ELSE 'Junior'
  END AS level
FROM Employees;

-- 8. CTE (WITH)

WITH department_avg AS (
  SELECT department, AVG(salary) AS avg_salary
  FROM Employees
  GROUP BY department
)
SELECT e.name, e.department, e.salary, da.avg_salary
FROM Employees e
JOIN department_avg da ON e.department = da.department
WHERE e.salary > da.avg_salary
ORDER BY da.department;
