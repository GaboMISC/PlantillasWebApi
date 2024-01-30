/* ********** Activar BCP **********
	Nota:
	Para activar el BCP coloque el número 1, de lo contrario coloque un 0 para desactivar.

	Use Master
	GO
	EXEC master.dbo.sp_configure 'show advanced options', 1
	RECONFIGURE WITH OVERRIDE
	GO
	EXEC master.dbo.sp_configure 'xp_cmdshell', 1
	RECONFIGURE WITH OVERRIDE
	GO
*/

/* ********** Elimina la Base de Datos **********
	USE master;
	DROP DATABASE BdCompleta;
	DROP DATABASE BdIncompleta;
*/

-- Base de Datos Uno
CREATE DATABASE BdCompleta;
GO
USE BdCompleta;
GO
CREATE TABLE [dbo].[TablaUno]
(
	CampoUno INT,
	CampoDos VARCHAR(50)
);
GO
INSERT TablaUno Values (1, 'Uno');
INSERT TablaUno Values (2, 'Dos');
INSERT TablaUno Values (3, 'Tres');
INSERT TablaUno Values (4, 'Cuatro');
INSERT TablaUno Values (5, 'Cinco');
GO
-- Base de Datos Dos
CREATE DATABASE BdIncompleta;
GO
USE BdIncompleta;
GO
CREATE TABLE [dbo].[TablaDos]
(
	CampoUno INT,
	CampoDos VARCHAR(50)
);
GO
INSERT TablaDos Values (1, 'Uno');
INSERT TablaDos Values (5, 'Cinco');
GO
SELECT * FROM [BdCompleta].[dbo].[TablaUno];
SELECT * FROM [BdIncompleta].[dbo].[TablaDos];
GO
/* ********** Consulta para Obtener las Diferencias de la Tabla en BD ********** */

-- C = BdCompleta, I = BdIncompleta

SELECT TOP(5) C.CampoUno, C.CampoDos
FROM [BdCompleta].[dbo].[TablaUno] AS C
WHERE C.CampoUno NOT IN
(
	SELECT I.CampoUno
	FROM [BdIncompleta].[dbo].[TablaDos] AS I	
)
ORDER BY C.CampoUno ASC;

-------------------- Ejemplo de BCP --------------------

/* Atributos:
	-T = Autenticación confiable de Windows.
	-t = Define la coma como el separador de campo.

	-- Variables
	DECLARE @ComandoBCP VARCHAR(8000);
	DECLARE @RutaSalida VARCHAR(1000) = 'C:\Base64Prueba\Reporte.csv';
	DECLARE @Consulta VARCHAR(8000) = 'SELECT C.CampoUno, C.CampoDos FROM [BdCompleta].[dbo].[TablaUno] AS C WHERE C.CampoUno NOT IN ( SELECT I.CampoUno FROM [BdIncompleta].[dbo].[TablaDos] AS I ) ORDER BY C.CampoUno ASC';

	-- Comando
	SET @ComandoBCP = 'BCP ' + '"' + @Consulta + '" ' + 'QUERYOUT "' + @RutaSalida + '" ' + '-c -t, -T -S ' + @@SERVERNAME;

	-- Ejecuta el Comando en Linea de Comando (CMD)
	EXECUTE master.sys.xp_cmdshell @ComandoBCP;
*/

-- Obtiene los nombre de las columnas
DECLARE @NombreColumnas VARCHAR(8000);
SELECT @NombreColumnas = COALESCE(@NombreColumnas+',','') + COLUMN_NAME FROM INFORMATION_SCHEMA.COLUMNS WHERE TABLE_NAME = 'TablaUno';
SELECT @NombreColumnas;