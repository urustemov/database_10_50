SET search_path TO clinic;

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
