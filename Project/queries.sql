SET search_path TO clinic;

-- 1. Все пациенты
SELECT * FROM patients;

-- 2. Пациенты старше 40
SELECT * FROM patients
WHERE date_of_birth <= CURRENT_DATE - INTERVAL '40 years';

-- 3. Все визиты с именами
SELECT
    v.visit_id,
    p.first_name || ' ' || p.last_name AS patient,
    d.first_name || ' ' || d.last_name AS doctor,
    v.visit_date,
    v.diagnosis,
    v.price
FROM visits v
JOIN patients p ON v.patient_id = p.patient_id
JOIN doctors d ON v.doctor_id = d.doctor_id;

-- 4. Выручка по врачам
SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    SUM(v.price) AS total_income
FROM doctors d
JOIN visits v ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id;

-- 5. Рейтинг врачей
SELECT
    d.doctor_id,
    d.first_name,
    d.last_name,
    COUNT(v.visit_id) AS total_visits,
    RANK() OVER (ORDER BY COUNT(v.visit_id) DESC) AS rank
FROM doctors d
LEFT JOIN visits v ON v.doctor_id = d.doctor_id
GROUP BY d.doctor_id;
