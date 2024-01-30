-- Crea la base de datos
CREATE DATABASE EjemploUnion;
GO
USE EjemploUnion;
GO
-- Se crean las tablas
CREATE TABLE CarreraUno
(
CarreraId INTEGER PRIMARY KEY, 
NombreCarrera VARCHAR(50), 
Ubicacion VARCHAR(50)
);
GO
CREATE TABLE CarreraDos
(
CarreraId INTEGER PRIMARY KEY, 
NombreCarrera VARCHAR(50), 
Ubicacion VARCHAR(50)
);
GO
-- Se insertan los registros a las tablas
INSERT INTO CarreraUno (CarreraId, NombreCarrera, Ubicacion) VALUES (1, 'Sistemas', 'Edificio Q');
INSERT INTO CarreraUno (CarreraId, NombreCarrera, Ubicacion) VALUES (2, 'Informatica', 'Edificio D');
INSERT INTO CarreraUno (CarreraId, NombreCarrera, Ubicacion) VALUES (3, 'Contabilidad', 'Edificio G');
INSERT INTO CarreraUno (CarreraId, NombreCarrera, Ubicacion) VALUES (4, 'Aeronautica', 'Edificio X');
INSERT INTO CarreraUno (CarreraId, NombreCarrera, Ubicacion) VALUES (5, 'Gestion Empresarial', 'Edificio Z');
GO
INSERT INTO CarreraDos (CarreraId, NombreCarrera, Ubicacion) VALUES (1, 'Historia', 'Edificio A');
INSERT INTO CarreraDos (CarreraId, NombreCarrera, Ubicacion) VALUES (2, 'Bioquimica', 'Edificio B');
INSERT INTO CarreraDos (CarreraId, NombreCarrera, Ubicacion) VALUES (3, 'Administracion', 'Edificio C');
INSERT INTO CarreraDos (CarreraId, NombreCarrera, Ubicacion) VALUES (4, 'Sistemas', 'Edificio Q');
INSERT INTO CarreraDos (CarreraId, NombreCarrera, Ubicacion) VALUES (5, 'Informatica', 'Edificio D');

SELECT * FROM CarreraUno;
SELECT * FROM CarreraDos;

-- UNION (no hay campos repetidos).
SELECT NombreCarrera FROM CarreraUno
UNION
SELECT NombreCarrera FROM CarreraDos;

-- UNION ALL (puede mostrar campos repetidos).
SELECT NombreCarrera FROM CarreraUno
UNION ALL
SELECT NombreCarrera FROM CarreraDos;

-- EXCEPT (muestra los registros que existen solo en la primera tabla).
SELECT NombreCarrera FROM CarreraUno
EXCEPT
SELECT NombreCarrera FROM CarreraDos;

-- INTERSECT (muestra los datos existentes en ambas tablas).
SELECT NombreCarrera FROM CarreraUno
INTERSECT
SELECT NombreCarrera FROM CarreraDos;