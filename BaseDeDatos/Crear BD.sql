/* ********** Creacion de la BD ********** */
SET NOCOUNT ON; -- Desactiva los Mensajes
USE master;
GO -- Base de Datos
IF EXISTS(SELECT * FROM SYS.DATABASES WHERE NAME='PersonaBD') -- Base de Datos
	BEGIN
		-- Si Existe
		DROP DATABASE PersonaBD;
		CREATE DATABASE PersonaBD;
		PRINT 'Se elimino y creo la base de datos';
	END
ELSE
	BEGIN
		-- No Existe
		CREATE DATABASE PersonaBD;
		PRINT 'Se creo la base de datos';
	END
GO
-- Cambio de Base de Datos
USE PersonaBD;
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
IF EXISTS(SELECT * FROM INFORMATION_SCHEMA.TABLES WITH(NOLOCK) WHERE TABLE_NAME = 'Persona' AND TABLE_SCHEMA = 'web')
	BEGIN
		DROP TABLE [PersonaBD].[web].[Persona];
		PRINT 'Se elimino la tabla';
	END
GO -- Tabla Pais
	CREATE TABLE [web].[Pais]
	(
		PaisId INT IDENTITY(1, 1) NOT NULL,
		Descripcion VARCHAR(50) NOT NULL,	
	);
	PRINT 'Se crea la tabla';
GO -- Contraints Tabla
	ALTER TABLE [web].[Pais]
		ADD CONSTRAINT PK_Pais_PaisId PRIMARY KEY CLUSTERED (PaisId ASC);
	PRINT 'Se crean los contraints de la tabla';
GO -- Indices Tabla
	CREATE NONCLUSTERED INDEX IXNC_Pais_PaisId ON [PersonaBD].[web].[Pais] (PaisId ASC);
	PRINT 'Se crean los indices de la tabla';
GO -- Tabla Persona
	CREATE TABLE [web].[Persona]
	(
		PersonaId INT IDENTITY(1, 1) NOT NULL,
		Nombre VARCHAR(50) NOT NULL,
		Paterno VARCHAR(50) NULL,
		Materno VARCHAR(50) NULL,
		RFC VARCHAR(50) NOT NULL,
		PaisId INT  NOT NULL,
		Sexo CHAR(1) DEFAULT 'H' NOT NULL,
		Edad INT DEFAULT 0 NULL,
		FechaNacimiento DATETIME NOT NULL		
	);
	PRINT 'Se crea la tabla';
GO -- Contraints Tabla
	ALTER TABLE [web].[Persona]
		ADD CONSTRAINT PK_Persona_PersonaId PRIMARY KEY CLUSTERED (PersonaId ASC);
	ALTER TABLE [web].[Persona]
		ADD CONSTRAINT FK_Persona_PaisId FOREIGN KEY (PaisId) REFERENCES [PersonaBD].[web].[Pais] (PaisId);
	PRINT 'Se crean los contraints de la tabla';
GO -- Indices Tabla
	CREATE NONCLUSTERED INDEX IXNC_Persona_RFC ON [PersonaBD].[web].[Persona] (RFC ASC);
	CREATE NONCLUSTERED INDEX IXNC_Persona_Nombre ON [PersonaBD].[web].[Persona] (Nombre ASC);
	PRINT 'Se crean los indices de la tabla';
GO -- Registros
-- Pais
INSERT INTO [web].[Pais] (Descripcion) VALUES('Mexico');
INSERT INTO [web].[Pais] (Descripcion) VALUES('Estados Unidos');
INSERT INTO [web].[Pais] (Descripcion) VALUES('Rusia');
INSERT INTO [web].[Pais] (Descripcion) VALUES('Japon');
INSERT INTO [web].[Pais] (Descripcion) VALUES('China');
GO
-- Persona
INSERT INTO [web].[Persona] (Nombre, Paterno, Materno, RFC, PaisId, Sexo, Edad, FechaNacimiento) 
VALUES('Gabriel', 'Martinez', 'Flores', 'GABO0001', 1, 'H', 28, GETDATE());
/*
Consultas
	SELECT * FROM [PersonaBD].[web].[Pais];
	SELECT * FROM [PersonaBD].[web].[Persona];
*/