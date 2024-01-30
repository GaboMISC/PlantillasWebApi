-- Crea la base de datos
CREATE DATABASE EjemploJoin;
GO
USE EjemploJoin;
GO
-- Se crean las tablas
CREATE TABLE Carrera
(
CarreraId INTEGER PRIMARY KEY, 
NombreCarrera VARCHAR(50), 
Ubicacion VARCHAR(50)
);
GO
CREATE TABLE Alumno
(
AlumnoId INTEGER PRIMARY KEY, 
NombreAlumno VARCHAR(100), 
NumCarrera INTEGER,
FOREIGN KEY (NumCarrera) REFERENCES Carrera(CarreraId)
);
GO
-- Se insertan los registros a las tablas
INSERT INTO Carrera (CarreraId, NombreCarrera, Ubicacion) VALUES (1, 'Sistemas', 'Edificio Q');
INSERT INTO Carrera (CarreraId, NombreCarrera, Ubicacion) VALUES (2, 'Informatica', 'Edificio D');
INSERT INTO Carrera (CarreraId, NombreCarrera, Ubicacion) VALUES (3, 'Contabilidad', 'Edificio G');
INSERT INTO Carrera (CarreraId, NombreCarrera, Ubicacion) VALUES (4, 'Aeronautica', NULL);
INSERT INTO Carrera (CarreraId, NombreCarrera, Ubicacion) VALUES (5, 'Gestion Empresarial', NULL);
GO
INSERT INTO Alumno (AlumnoId, NombreAlumno, NumCarrera) VALUES (1, 'Martinez Flores Gabriel', 1);
INSERT INTO Alumno (AlumnoId, NombreAlumno, NumCarrera) VALUES (2, 'Gamiño Hernandez Nancy', 1);
INSERT INTO Alumno (AlumnoId, NombreAlumno, NumCarrera) VALUES (3, 'Almaraz Granados Pablo', 2);
INSERT INTO Alumno (AlumnoId, NombreAlumno, NumCarrera) VALUES (4, 'Gonzalez Segoviano Jaqueline', NULL);
INSERT INTO Alumno (AlumnoId, NombreAlumno, NumCarrera) VALUES (5, 'Vargas Ortega Marilu', NULL);

SELECT * FROM Carrera;
SELECT * FROM Alumno;

-- Muestra el nombre del alumno y la carrera
SELECT A.NombreAlumno, C.NombreCarrera
FROM Carrera C, Alumno A
WHERE A.NumCarrera = C.CarreraId;

-- INNER JOIN (Muestra los Alumnos con Carrera)
SELECT A.NombreAlumno, C.NombreCarrera
FROM Carrera C INNER JOIN Alumno A
ON A.NumCarrera = C.CarreraId;

-- LEFT JOIN (Muestra las Carreras con y sin Alumnos)
SELECT A.NombreAlumno, C.NombreCarrera
FROM Carrera C LEFT JOIN Alumno A
ON A.NumCarrera = C.CarreraId;

-- RIGHT JOIN (Muestra los Alumnos con y sin Carrera)
SELECT A.NombreAlumno, C.NombreCarrera
FROM Carrera C RIGHT JOIN Alumno A
ON A.NumCarrera = C.CarreraId;

-- FULL JOIN (Muestra todos los Registros)
SELECT A.NombreAlumno, C.NombreCarrera
FROM Carrera C FULL JOIN Alumno A
ON A.NumCarrera = C.CarreraId;

-- Muestra todos los alumnos que no tengan carrera con un LEFT JOIN
SELECT A.NombreAlumno, C.NombreCarrera
FROM Alumno A LEFT JOIN Carrera C
ON A.NumCarrera = C.CarreraId
WHERE A.NumCarrera IS NULL;

-- CROSS JOIN
SELECT A.NombreAlumno, C.NombreCarrera
FROM Carrera C CROSS JOIN Alumno A;