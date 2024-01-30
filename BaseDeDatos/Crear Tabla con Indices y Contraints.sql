/* ********** Creacion de la BD ********** */
SET NOCOUNT ON; -- Desactiva los Mensajes
USE master;
GO -- Base de Datos
IF EXISTS(SELECT * FROM SYS.DATABASES WHERE NAME='Ejemplo') -- Base de Datos
	BEGIN
		-- Si Existe
		DROP DATABASE Ejemplo;
		CREATE DATABASE Ejemplo;
		PRINT 'Se elimino y creo la base de datos';
	END
ELSE
	BEGIN
		-- No Existe
		CREATE DATABASE Ejemplo;
		PRINT 'Se creo la base de datos';
	END
GO
-- Cambio de Base de Datos
USE Ejemplo;
GO -- Esquema de Tablas
IF EXISTS(SELECT * FROM sys.schemas WITH(NOLOCK) WHERE name = 'adm')
	BEGIN
		-- Si Existe
		DROP SCHEMA adm;
		PRINT 'Se elimino el esquema';
	END
GO
	CREATE SCHEMA adm;
	GO
	PRINT 'Se creo el esquema';
GO -- Tabla
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WITH(NOLOCK) WHERE TABLE_NAME = 'Libro' AND TABLE_SCHEMA = 'adm')
	BEGIN
		DROP TABLE [Ejemplo].[adm].[Libro];
		PRINT 'Se elimino la tabla';
	END
GO
	CREATE TABLE [adm].[Libro]
	(
		LibroId INT IDENTITY(1, 1) NOT NULL,
		Nombre VARCHAR(50) NOT NULL,
		Autor VARCHAR(50) NOT NULL,
		FechaPublicacion DATETIME NOT NULL,
		Editorial VARCHAR(50) NULL,
		AnoPublicacion INT NULL
	);
	PRINT 'Se crea la tabla';
GO -- Contraints Tabla
	ALTER TABLE [adm].[Libro]
		ADD CONSTRAINT PK_Libro_LibroId PRIMARY KEY CLUSTERED (LibroId ASC);
	PRINT 'Se crean los contraints de la tabla';
GO -- Indices Tabla
	CREATE NONCLUSTERED INDEX IXNC_Libro_Editorial ON [Ejemplo].[adm].[Libro] (Editorial ASC);
	CREATE NONCLUSTERED INDEX IXNC_Libro_Autor ON [Ejemplo].[adm].[Libro] (Autor ASC);
	PRINT 'Se crean los indices de la tabla';
GO -- Registros
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 1', 'Gabriel Martinez', GETDATE(), 'Alfaomega', 2011);
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 2', 'Francisco Trujillo', GETDATE(), 'Selector', 2010);
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 3', 'Federico Navarrete', GETDATE(), 'Ediciones Siruela', 2012);
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 4', 'Jorge Luis Borges', GETDATE(), 'Anagrama', 2011);
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 5', 'Miguel de Cervantes', GETDATE(), 'Planeta', 2014);
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 6', 'Lorenzo Montes', GETDATE(), 'Lectorum', 2010);
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 7', 'Tomas Sanchez', GETDATE(), 'Planeta', 2009);
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 8', 'Brena Alvarado', GETDATE(), 'Jaguar', 2007);
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 9', 'Erika Suarez', GETDATE(), 'Marcial Ponts', 2009);
INSERT INTO [adm].[Libro] (Nombre, Autor, FechaPublicacion, Editorial, AnoPublicacion) 
VALUES('Libro 10', 'Santiago Echeverria', GETDATE(), 'Porrua', 2012);
PRINT 'Se ingresan los registros a la tabla';
--SELECT * FROM [Ejemplo].[adm].[Libro];