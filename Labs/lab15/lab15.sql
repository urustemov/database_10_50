DROP TABLE IF EXISTS employees CASCADE;
DROP TABLE IF EXISTS sales CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    manager_id INT,
    salary NUMERIC(10,2),
    tenure INT
);

CREATE TABLE sales (
    sale_id SERIAL PRIMARY KEY,
    employee_id INT REFERENCES employees(employee_id),
    region VARCHAR(50),
    year INT,
    sales_amount NUMERIC(10,2)
);

INSERT INTO employees (first_name, last_name, department, manager_id, salary, tenure) VALUES
('Aibek', 'Sharshenov', 'Engineering', NULL, 95000, 7),
('Ainura', 'Toktomamatova', 'Engineering', 1, 72000, 4),
('Bakyt', 'Mamatov', 'Sales', 1, 68000, 6),
('Meerim', 'Sultanova', 'HR', 2, 52000, 3),
('Tilek', 'Usubaliev', 'Sales', 3, 88000, 8),
('Anna', 'Ivanova', 'Engineering', 1, 110000, 10);

INSERT INTO sales (employee_id, region, year, sales_amount) VALUES
(3, 'North', 2022, 50000),
(3, 'North', 2023, 64000),
(5, 'South', 2022, 82000),
(5, 'South', 2023, 91000),
(5, 'South', 2024, 75000),
(2, 'Central', 2023, 40000);

-- =====================
-- 1. Подзапросы (Subqueries)
-- =====================

-- Сотрудники, чья зарплата выше средней
SELECT first_name, last_name, salary
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees);

-- Кол-во сотрудников в каждом отделе (в подзапросе)
SELECT e.department, e.first_name, e.salary
FROM employees e
WHERE e.department IN (
  SELECT department FROM employees GROUP BY department HAVING COUNT(*) >= 2
);

-- =====================
-- 2. CTE (WITH)
-- =====================

WITH dept_avg AS (
  SELECT department, AVG(salary) AS avg_salary
  FROM employees
  GROUP BY department
)
SELECT e.first_name, e.department, e.salary, da.avg_salary
FROM employees e
JOIN dept_avg da ON e.department = da.department
WHERE e.salary > da.avg_salary;

-- =====================
-- 3. Рекурсивный CTE
-- =====================

WITH RECURSIVE hierarchy AS (
  SELECT employee_id, first_name, manager_id
  FROM employees
  WHERE manager_id IS NULL
  UNION ALL
  SELECT e.employee_id, e.first_name, e.manager_id
  FROM employees e
  INNER JOIN hierarchy h ON e.manager_id = h.employee_id
)
SELECT * FROM hierarchy;

-- =====================
-- 4. Set-операции (UNION, INTERSECT, EXCEPT)
-- =====================

-- Уникальные регионы продаж и отделы (пример UNION)
SELECT region AS area FROM sales
UNION
SELECT department AS area FROM employees;

-- Сотрудники, которые также совершали продажи (INTERSECT)
SELECT first_name FROM employees
INTERSECT
SELECT DISTINCT e.first_name
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id;

-- Сотрудники, у которых нет продаж (EXCEPT)
SELECT first_name FROM employees
EXCEPT
SELECT DISTINCT e.first_name
FROM employees e
JOIN sales s ON e.employee_id = s.employee_id;

-- =====================
-- 5. Оконные функции (Window Functions)
-- =====================

SELECT
    first_name,
    department,
    salary,
    RANK() OVER (PARTITION BY department ORDER BY salary DESC) AS dept_rank,
    AVG(salary) OVER (PARTITION BY department) AS dept_avg_salary
FROM employees;

-- =====================
-- 6. Pivot (поворот данных)
-- =====================

-- Продажи по годам в виде столбцов
SELECT
    employee_id,
    SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS sales_2022,
    SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS sales_2023,
    SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS sales_2024
FROM sales
GROUP BY employee_id
ORDER BY employee_id;

-- =====================
-- 7. Unpivot (обратный поворот)
-- =====================

-- Превращаем данные обратно в строки
WITH pivoted AS (
  SELECT
      employee_id,
      SUM(CASE WHEN year = 2022 THEN sales_amount ELSE 0 END) AS y2022,
      SUM(CASE WHEN year = 2023 THEN sales_amount ELSE 0 END) AS y2023,
      SUM(CASE WHEN year = 2024 THEN sales_amount ELSE 0 END) AS y2024
  FROM sales
  GROUP BY employee_id
)
SELECT employee_id, '2022' AS year, y2022 AS sales_amount FROM pivoted
UNION ALL
SELECT employee_id, '2023', y2023 FROM pivoted
UNION ALL
SELECT employee_id, '2024', y2024 FROM pivoted
ORDER BY employee_id, year;

-- =====================
-- 8. Сложная фильтрация и сортировка
-- =====================

SELECT first_name, department, salary,
  CASE
    WHEN salary > 100000 THEN 'High Priority'
    WHEN salary BETWEEN 70000 AND 100000 THEN 'Medium Priority'
    ELSE 'Low Priority'
  END AS status
FROM employees
ORDER BY
  CASE
    WHEN salary > 100000 THEN 1
    WHEN salary BETWEEN 70000 AND 100000 THEN 2
    ELSE 3
  END;

-- =====================
-- 9. Оптимизация (EXPLAIN)
-- =====================

EXPLAIN
SELECT * FROM employees WHERE salary > 80000;
