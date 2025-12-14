SET search_path TO clinic;

CREATE INDEX idx_visits_patient ON visits(patient_id);
CREATE INDEX idx_visits_doctor  ON visits(doctor_id);
CREATE INDEX idx_visits_date    ON visits(visit_date);
