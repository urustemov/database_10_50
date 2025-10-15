DROP TABLE IF EXISTS Employees CASCADE;

CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    department VARCHAR(50),
    salary NUMERIC(10,2),
    hire_date DATE,
    bonus NUMERIC(8,2)
);

INSERT INTO Employees (first_name, department, salary, hire_date, bonus) VALUES
('Aibek', 'Engineering', 95000, '2020-02-15', 5000),
('Ainura', 'Engineering', 72000, '2022-05-10', 3000),
('Bakyt', 'Sales', 68000, '2023-03-01', NULL),
('Meerim', 'HR', 52000, '2021-07-19', 2500),
('Tilek', 'Sales', 88000, '2019-11-08', 4000),
('Anna', 'Engineering', 110000, '2023-01-20', 8000),
('Boris', 'Marketing', 60000, '2020-09-01', 2000),
('Arslan', 'Engineering', 40000, '2024-04-01', NULL);

-- =====================
-- 1. COUNT() — подсчёт
-- =====================

-- Общее число сотрудников
SELECT COUNT(*) AS total_employees FROM Employees;

-- Сотрудники с ненулевым бонусом
SELECT COUNT(bonus) AS with_bonus FROM Employees;

-- Количество уникальных отделов
SELECT COUNT(DISTINCT department) AS unique_departments FROM Employees;

-- =====================
-- 2. SUM() и AVG()
-- =====================

-- Общие затраты на зарплату
SELECT SUM(salary) AS total_salary FROM Employees;

-- Средняя зарплата по всей компании
SELECT AVG(salary) AS avg_salary FROM Employees;

-- Средняя зарплата по отделам
SELECT department, AVG(salary) AS avg_salary
FROM Employees
GROUP BY department;

-- =====================
-- 3. MAX() и MIN()
-- =====================

-- Максимальная и минимальная зарплата
SELECT MAX(salary) AS highest_salary, MIN(salary) AS lowest_salary FROM Employees;

-- Самая поздняя дата найма по отделу
SELECT department, MAX(hire_date) AS last_hired
FROM Employees
GROUP BY department;

-- =====================
-- 4. STRING_AGG() и ARRAY_AGG()
-- =====================

-- Список сотрудников по отделу
SELECT department, STRING_AGG(first_name, ', ') AS employee_names
FROM Employees
GROUP BY department;

-- Массив зарплат по отделу
SELECT department, ARRAY_AGG(salary) AS salary_array
FROM Employees
GROUP BY department;

-- =====================
-- 5. Статистические функции
-- =====================

SELECT department,
       STDDEV(salary) AS salary_std_dev,
       VARIANCE(salary) AS salary_variance
FROM Employees
GROUP BY department;

-- =====================
-- 6. GROUP BY с выражением
-- =====================

SELECT 
    CASE 
        WHEN salary < 60000 THEN 'Low income'
        WHEN salary BETWEEN 60000 AND 90000 THEN 'Mid income'
        ELSE 'High income'
    END AS salary_group,
    COUNT(*) AS employee_count,
    AVG(salary) AS avg_salary
FROM Employees
GROUP BY 
    CASE 
        WHEN salary < 60000 THEN 'Low income'
        WHEN salary BETWEEN 60000 AND 90000 THEN 'Mid income'
        ELSE 'High income'
    END
ORDER BY avg_salary DESC;

-- =====================
-- 7. HAVING — фильтрация групп
-- =====================

-- Отделы, где средняя зарплата выше 70 000
SELECT department, AVG(salary) AS avg_salary
FROM Employees
GROUP BY department
HAVING AVG(salary) > 70000;

-- =====================
-- 8. Комбинированные агрегаты
-- =====================

SELECT department,
       COUNT(*) AS employee_count,
       MIN(salary) AS min_salary,
       MAX(salary) AS max_salary,
       AVG(salary) AS avg_salary,
       STDDEV(salary) AS std_dev
FROM Employees
GROUP BY department
ORDER BY avg_salary DESC;

-- =====================
-- 9. Условные агрегаты
-- =====================

SELECT department,
       COUNT(*) AS total_employees,
       COUNT(CASE WHEN salary > 80000 THEN 1 END) AS high_earners,
       COUNT(CASE WHEN hire_date > '2022-01-01' THEN 1 END) AS recent_hires
FROM Employees
GROUP BY department;

-- =====================
-- 10. Процентное распределение
-- =====================

SELECT department,
       COUNT(*) AS dept_count,
       ROUND(
         COUNT(*)::NUMERIC / (SELECT COUNT(*) FROM Employees) * 100, 2
       ) AS percentage
FROM Employees
GROUP BY department
ORDER BY percentage DESC;
