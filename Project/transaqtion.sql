SET search_path TO clinic;

BEGIN;

WITH new_patient AS (
    INSERT INTO patients (first_name, last_name, date_of_birth, gender, phone, email, address)
    VALUES ('Alina','Muratova','1995-03-15','F','777333444','alina@example.com','Bishkek 5')
    RETURNING patient_id
)
INSERT INTO visits (patient_id, doctor_id, visit_date, diagnosis, notes, price)
SELECT patient_id,
       1,
       '2025-12-10 11:00',
       'Headache',
       'Transaction insert',
       1800
FROM new_patient;

COMMIT;
