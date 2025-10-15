DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS customers CASCADE;

CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100)
);

CREATE TABLE products (
    product_id SERIAL PRIMARY KEY,
    product_name VARCHAR(100),
    price NUMERIC(10,2)
);

CREATE TABLE orders (
    order_id SERIAL PRIMARY KEY,
    customer_id INTEGER REFERENCES customers(customer_id),
    order_date DATE,
    total_amount NUMERIC(10,2)
);

CREATE TABLE order_items (
    item_id SERIAL PRIMARY KEY,
    order_id INTEGER REFERENCES orders(order_id),
    product_id INTEGER REFERENCES products(product_id),
    quantity INT
);

-- =====================
-- 1. Наполнение данными
-- =====================

INSERT INTO customers (name, email) VALUES
('Aibek', 'aibek@gmail.com'),
('Ainura', 'ainura@mail.com'),
('Bakyt', 'bakyt@gmail.com'),
('Meerim', 'meerim@yahoo.com');

INSERT INTO products (product_name, price) VALUES
('Laptop', 1200.00),
('Mouse', 25.00),
('Keyboard', 45.00),
('Monitor', 300.00);

INSERT INTO orders (customer_id, order_date, total_amount) VALUES
(1, '2024-01-10', 1250.00),
(2, '2024-02-05', 345.00),
(3, '2024-03-15', 1320.00);

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),  -- Aibek bought 1 Laptop
(1, 2, 2),  -- Aibek bought 2 Mice
(2, 4, 1),  -- Ainura bought 1 Monitor
(3, 1, 1),  -- Bakyt bought 1 Laptop
(3, 3, 1);  -- Bakyt bought 1 Keyboard

-- =====================
-- 2. INNER JOIN
-- =====================

-- Клиенты с их заказами
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id;

-- =====================
-- 3. LEFT JOIN
-- =====================

-- Все клиенты, включая тех, кто не сделал заказ
SELECT c.name, c.email, o.order_date, o.total_amount
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
ORDER BY c.name;

-- =====================
-- 4. RIGHT JOIN
-- =====================

-- Все заказы, включая случаи, где нет информации о клиенте
SELECT c.name, o.order_id, o.order_date, o.total_amount
FROM customers c
RIGHT JOIN orders o ON c.customer_id = o.customer_id;

-- =====================
-- 5. FULL OUTER JOIN
-- =====================

-- Все клиенты и все заказы, даже если нет совпадения
SELECT c.name, o.order_date, o.total_amount
FROM customers c
FULL OUTER JOIN orders o ON c.customer_id = o.customer_id;

-- =====================
-- 6. CROSS JOIN
-- =====================

-- Каждое сочетание клиента и продукта (осторожно!)
SELECT c.name AS customer, p.product_name
FROM customers c
CROSS JOIN products p;

-- =====================
-- 7. Множественное соединение (несколько JOIN)
-- =====================

-- Полный список заказов с клиентами и товарами
SELECT c.name AS customer, o.order_id, p.product_name, oi.quantity, p.price,
       (oi.quantity * p.price) AS item_total
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY o.order_id;

-- =====================
-- 8. Пример SELF JOIN
-- =====================

DROP TABLE IF EXISTS employees CASCADE;

CREATE TABLE employees (
    employee_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    manager_id INTEGER REFERENCES employees(employee_id)
);

INSERT INTO employees (name, manager_id) VALUES
('Aibek', NULL),  -- Руководитель
('Ainura', 1),
('Bakyt', 1),
('Meerim', 2);

-- Сотрудники и их менеджеры
SELECT e1.name AS employee, e2.name AS manager
FROM employees e1
LEFT JOIN employees e2 ON e1.manager_id = e2.employee_id;

-- =====================
-- 9. Join с условиями (WHERE)
-- =====================

SELECT c.name, o.order_date, o.total_amount
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
WHERE o.total_amount > 500;

-- =====================
-- 10. Many-to-Many пример
-- =====================

-- какие клиенты купили какие товары
SELECT c.name AS customer, p.product_name, o.order_date
FROM customers c
INNER JOIN orders o ON c.customer_id = o.customer_id
INNER JOIN order_items oi ON o.order_id = oi.order_id
INNER JOIN products p ON oi.product_id = p.product_id
ORDER BY c.name, p.product_name;
