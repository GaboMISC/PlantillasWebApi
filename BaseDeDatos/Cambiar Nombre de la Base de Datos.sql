-- Elimina la base de datos
USE master;  
GO
DROP DATABASE SitioValidador;
GO
DROP DATABASE SitioValidadorEDP;
GO
DROP DATABASE SitioValidador_90;
GO
DROP DATABASE SitioValidadorEDP_90;
GO

USE master; 
GO
-- Nombre Actual de la Base de Datos
ALTER DATABASE SitioValidador_90 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
-- Remplaza Nombre Actual por Nuevo
ALTER DATABASE SitioValidador_90 MODIFY NAME = SitioValidador;
GO
ALTER DATABASE SitioValidador SET MULTI_USER;
GO

USE master;  
GO
-- Nombre Actual de la Base de Datos
ALTER DATABASE SitioValidadorEDP_90 SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
-- Remplaza Nombre Actual por Nuevo
ALTER DATABASE SitioValidadorEDP_90 MODIFY NAME = SitioValidadorEDP;
GO
ALTER DATABASE SitioValidadorEDP SET MULTI_USER;
GO