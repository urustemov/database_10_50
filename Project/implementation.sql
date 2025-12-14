DROP SCHEMA IF EXISTS clinic CASCADE;
CREATE SCHEMA clinic;
SET search_path TO clinic;

-- Таблицы
CREATE TABLE patients (
    patient_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    date_of_birth DATE,
    gender VARCHAR(10),
    phone VARCHAR(20),
    email VARCHAR(100),
    address VARCHAR(255)
);

CREATE TABLE doctors (
    doctor_id SERIAL PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    specialization VARCHAR(100),
    phone VARCHAR(20),
    email VARCHAR(100)
);

CREATE TABLE visits (
    visit_id SERIAL PRIMARY KEY,
    patient_id INT REFERENCES patients(patient_id),
    doctor_id INT REFERENCES doctors(doctor_id),
    visit_date TIMESTAMP,
    diagnosis VARCHAR(255),
    notes TEXT,
    price NUMERIC(10,2)
);

-- Данные
INSERT INTO patients VALUES
(1,'Anna','Petrova','1990-05-10','F','777000111','anna@example.com','Bishkek 1'),
(2,'Sergey','Ivanov','1985-02-20','M','777000222','sergey@example.com','Bishkek 2'),
(3,'Almaz','Bekov','2000-09-15','M','777000333','almaz@example.com','Bishkek 3');

INSERT INTO doctors VALUES
(1,'Aibek','Kadyrov','Therapist','777100100','aibek@example.com'),
(2,'Dana','Sadykova','Cardiologist','777100200','dana@example.com');

INSERT INTO visits VALUES
(1,1,1,'2025-12-01 10:00','Flu','Rest recommended',1500),
(2,1,2,'2025-12-03 12:30','Chest pain','Follow-up needed',2500),
(3,2,1,'2025-12-05 09:00','Cold','Mild illness',1200);

-- Индексы
CREATE INDEX idx_visits_patient ON visits(patient_id);
CREATE INDEX idx_visits_doctor  ON visits(doctor_id);
CREATE INDEX idx_visits_date    ON visits(visit_date);
