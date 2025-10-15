DROP TABLE IF EXISTS accounts CASCADE;
DROP TABLE IF EXISTS logs CASCADE;

CREATE TABLE accounts (
    account_id SERIAL PRIMARY KEY,
    owner_name VARCHAR(100),
    balance NUMERIC(10,2) CHECK (balance >= 0)
);

CREATE TABLE logs (
    log_id SERIAL PRIMARY KEY,
    message TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

INSERT INTO accounts (owner_name, balance) VALUES
('Aibek', 1000.00),
('Ainura', 500.00),
('Bakyt', 300.00);

-- =====================
-- 1. Простая транзакция (BEGIN, COMMIT, ROLLBACK)
-- =====================

-- Пример перевода 200 с Aibek на Ainura
BEGIN;
UPDATE accounts SET balance = balance - 200 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 200 WHERE account_id = 2;
COMMIT;

-- Проверим результат
SELECT * FROM accounts;

-- Пример с ROLLBACK
BEGIN;
UPDATE accounts SET balance = balance - 100 WHERE account_id = 3;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
-- Ошибка — отменяем
ROLLBACK;

-- Проверим, что ничего не изменилось
SELECT * FROM accounts;

-- =====================
-- 2. Демонстрация принципов ACID
-- =====================

-- ATOMICITY: либо всё, либо ничего
BEGIN;
INSERT INTO logs (message) VALUES ('Начинаем операцию перевода');
UPDATE accounts SET balance = balance - 100 WHERE account_id = 1;
UPDATE accounts SET balance = balance + 100 WHERE account_id = 2;
COMMIT;

-- CONSISTENCY: поддержание ограничений
BEGIN;
-- Этот запрос не выполнится, так как CHECK(balance >= 0)
UPDATE accounts SET balance = balance - 2000 WHERE account_id = 3;
COMMIT;

-- ISOLATION и DURABILITY демонстрируются при параллельных транзакциях
-- (выполняется в двух psql-сессиях, см. методичку)

-- =====================
-- 3. Уровни изоляции (Isolation Levels)
-- =====================

-- READ UNCOMMITTED (в PostgreSQL эквивалентен READ COMMITTED)
BEGIN TRANSACTION ISOLATION LEVEL READ UNCOMMITTED;
SELECT * FROM accounts;
COMMIT;

-- READ COMMITTED (по умолчанию)
BEGIN TRANSACTION ISOLATION LEVEL READ COMMITTED;
SELECT * FROM accounts WHERE balance > 100;
COMMIT;

-- REPEATABLE READ
BEGIN TRANSACTION ISOLATION LEVEL REPEATABLE READ;
SELECT * FROM accounts;
-- Даже если другая транзакция изменит данные, здесь результат будет тем же
COMMIT;

-- SERIALIZABLE
BEGIN TRANSACTION ISOLATION LEVEL SERIALIZABLE;
UPDATE accounts SET balance = balance * 1.05; -- 5% начисление
COMMIT;

-- =====================
-- 4. SAVEPOINT
-- =====================

BEGIN;
INSERT INTO logs (message) VALUES ('Тест savepoint');
SAVEPOINT sp1;

UPDATE accounts SET balance = balance - 50 WHERE account_id = 2;
UPDATE accounts SET balance = balance + 50 WHERE account_id = 3;

-- Ошибка или отмена части
ROLLBACK TO SAVEPOINT sp1;

-- Добавим другое действие
INSERT INTO logs (message) VALUES ('После savepoint rollback');
COMMIT;

SELECT * FROM logs;

-- =====================
-- 5. Пример с несколькими SAVEPOINT
-- =====================

BEGIN;

INSERT INTO accounts (owner_name, balance) VALUES ('Test1', 100);
SAVEPOINT sp1;

INSERT INTO accounts (owner_name, balance) VALUES ('Test2', 200);
SAVEPOINT sp2;

-- Ошибочная операция
INSERT INTO accounts (owner_name, balance) VALUES ('ErrorUser', -50);
ROLLBACK TO SAVEPOINT sp2;

INSERT INTO accounts (owner_name, balance) VALUES ('Test3', 300);
COMMIT;

SELECT * FROM accounts;

-- =====================
-- 6. Пример обработки ошибок через PL/pgSQL
-- =====================

DO $$
DECLARE
    insufficient_funds EXCEPTION;
    current_balance DECIMAL;
BEGIN
    SELECT balance INTO current_balance FROM accounts WHERE account_id = 3;
    IF current_balance < 500 THEN
        RAISE insufficient_funds;
    END IF;

    UPDATE accounts SET balance = balance - 500 WHERE account_id = 3;
    UPDATE accounts SET balance = balance + 500 WHERE account_id = 2;

EXCEPTION
    WHEN insufficient_funds THEN
        RAISE NOTICE 'Transaction failed: Insufficient funds';
        ROLLBACK;
END $$;

-- =====================
-- 7. Мониторинг блокировок и зависаний
-- =====================

SELECT 
    blocked_locks.pid AS blocked_pid,
    blocked_activity.usename AS blocked_user,
    blocking_locks.pid AS blocking_pid,
    blocking_activity.usename AS blocking_user,
    blocked_activity.query AS blocked_statement
FROM pg_catalog.pg_locks blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity 
    ON blocked_activity.pid = blocked_locks.pid
JOIN pg_catalog.pg_locks blocking_locks 
    ON blocking_locks.locktype = blocked_locks.locktype
WHERE NOT blocked_locks.granted;