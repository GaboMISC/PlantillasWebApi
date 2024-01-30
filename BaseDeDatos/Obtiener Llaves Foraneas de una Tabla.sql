-- Base de Datos
USE [SitioValidador];
GO
-- Obtiene las Llaves Foraneas de la Base de Datos
SELECT FK.name AS [Nombre Foreign Key], PFK.name AS [Tabla Padre], RFK.name AS [Referencia Tabla]
FROM sys.foreign_keys FK
	INNER JOIN sys.objects PFK ON PFK.object_id = FK.parent_object_id
	INNER JOIN sys.objects RFK ON RFK.object_id = FK.referenced_object_id
WHERE PFK.name = 'Pantalla'; -- Nombre Tabla
GO
-- Obtiene Informacion de la Tabla
EXEC sp_help 'adm.Pantalla';