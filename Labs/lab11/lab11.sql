DROP TABLE IF EXISTS Students CASCADE;

CREATE TABLE Students (
    student_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    birth_date DATE
);

2. Вставка данных (INSERT)


-- обычная вставка
INSERT INTO Students (first_name, last_name, birth_date)
VALUES ('Aibek', 'Sharshenov', '2002-05-12');

-- вставка нескольких записей
INSERT INTO Students (first_name, last_name, birth_date) VALUES
('Ainura', 'Toktomamatova', '2001-09-23'),
('Bakyt', 'Mamatov', '2003-01-15'),
('Gulzat', 'Sultanova', '2002-07-30');

-- проверим результат
SELECT * FROM Students;

-- 3. Изменение данных (UPDATE)

UPDATE Students
SET birth_date = '2002-05-15'
WHERE first_name = 'Aibek' AND last_name = 'Sharshenov';

-- проверим обновление
SELECT * FROM Students WHERE first_name = 'Aibek';

-- 4. Удаление данных (DELETE)

-- удалим конкретного студента
DELETE FROM Students
WHERE first_name = 'Gulzat' AND last_name = 'Sultanova';

-- проверим результат
SELECT * FROM Students;

-- удалим всех, кто родился до 2002 года
DELETE FROM Students
WHERE birth_date < '2002-01-01';

-- проверим оставшиеся записи
SELECT * FROM Students;


-- 5. Массовые операции (BULK OPERATIONS)

-- вставим несколько записей заново
INSERT INTO Students (first_name, last_name, birth_date) VALUES
('Nursultan', 'Isakov', '2002-04-10'),
('Meerim', 'Bekova', '2003-06-12'),
('Tilek', 'Usubaliev', '2001-11-05');

SELECT * FROM Students;

-- массовое обновление фамилий
UPDATE Students
SET last_name = 'Bekov'
WHERE last_name IN ('Usubaliev', 'Isakov');

-- проверим изменения
SELECT * FROM Students;

-- массовое удаление
DELETE FROM Students
WHERE student_id IN (2, 3, 5);

-- финальный результат
SELECT * FROM Students;
