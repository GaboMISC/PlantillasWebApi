/* ********** Creacion de la BD ********** */
SET NOCOUNT ON; -- Desactiva los Mensajes
USE master;
GO -- Base de Datos
IF EXISTS(SELECT * FROM SYS.DATABASES WHERE NAME='EmployeeDB') -- Base de Datos
	BEGIN
		-- Si Existe
		DROP DATABASE EmployeeDB;
		CREATE DATABASE EmployeeDB;
		PRINT 'Se elimino y creo la base de datos';
	END
ELSE
	BEGIN
		-- No Existe
		CREATE DATABASE EmployeeDB;
		PRINT 'Se creo la base de datos';
	END
GO
-- Cambio de Base de Datos
USE EmployeeDB;
GO -- Esquema de Tablas
IF EXISTS(SELECT * FROM sys.schemas WITH(NOLOCK) WHERE name = 'web')
	BEGIN
		-- Si Existe
		DROP SCHEMA web;
		PRINT 'Se elimino el esquema';
	END
GO
	CREATE SCHEMA web;
	GO
	PRINT 'Se creo el esquema';
GO -- Tabla
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WITH(NOLOCK) WHERE TABLE_NAME = 'Employee' AND TABLE_SCHEMA = 'web')
	BEGIN
		DROP TABLE [EmployeeDB].[web].[Employee];
		PRINT 'Se elimino la tabla';
	END
GO -- Tabla Employee
	CREATE TABLE [web].[Employee]
	(
		EmployeeId INT IDENTITY(1, 1) NOT NULL,
		FirstName VARCHAR(50) NOT NULL,
		LastName VARCHAR(50) NULL,
		Salary DECIMAL(18, 2) DEFAULT 0 NOT NULL
	);
	PRINT 'Se crea la tabla';
GO -- Contraints Tabla
	ALTER TABLE [web].[Employee]
		ADD CONSTRAINT PK_Employee_EmployeeId PRIMARY KEY CLUSTERED (EmployeeId ASC);
	PRINT 'Se crean los contraints de la tabla';
GO -- Indices Tabla
	CREATE NONCLUSTERED INDEX IXNC_Employee_Salary ON [EmployeeDB].[web].[Employee] (Salary ASC);
	PRINT 'Se crean los indices de la tabla';
GO -- Registros
-- Employee
INSERT INTO [web].[Employee] (FirstName, LastName, Salary) 
VALUES
	('Gabriel', 'Martinez', 30000),
	('Carlos', 'Baez', 35000),
	('Marcelo', 'Fernandez', 40000),
	('Monica', 'Galicia', 28000),
	('Carlos', 'Monroy', 45000);
/*
Consultas
	SELECT * FROM [EmployeeDB].[web].[Employee];
*/