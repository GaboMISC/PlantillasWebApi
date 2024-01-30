/*
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
/* ********** Consulta para Igualar BD ********** */
/*
	-- C = BdCompleta, I = BdIncompleta

	INSERT INTO [BdIncompleta].[dbo].[TablaDos](CampoUno, CampoDos)
	SELECT TOP(5) C.CampoUno, C.CampoDos
	FROM [BdCompleta].[dbo].[TablaUno] AS C
	WHERE C.CampoUno NOT IN
	(
		SELECT I.CampoUno
		FROM [BdIncompleta].[dbo].[TablaDos] AS I	
	)
	ORDER BY C.CampoUno ASC;
*/

-------------------- Ejemplo --------------------
/*
	-- Hoy = BdCompleta, Ayer = BdIncompleta
	USE [SitioValidador];
	GO
	-- Comprobante
	INSERT INTO [SitioValidador].[ope].[Comprobante](UUID, RFCEmisor, RFCReceptor, RazonSocialReceptor, Folio, Serie, Certificado, Sello, FechaEmision, FechaTimbrado, UnidadNegocio, Ruta, Importe, IVA, EstadoId, ProveedorNumero, ProveedorClave, MetodoPago, FormaPago)
	SELECT TOP(1000) Hoy.UUID, Hoy.RFCEmisor, Hoy.RFCReceptor, Hoy.RazonSocialReceptor, Hoy.Folio, Hoy.Serie, Hoy.Certificado, Hoy.Sello, Hoy.FechaEmision, Hoy.FechaTimbrado, Hoy.UnidadNegocio, Hoy.Ruta, Hoy.Importe, Hoy.IVA, Hoy.EstadoId, Hoy.ProveedorNumero, Hoy.ProveedorClave, Hoy.MetodoPago, Hoy.FormaPago
	FROM [SitioValidador_reporteNoOk].[ope].[Comprobante] AS Hoy
	WHERE Hoy.ArchivoId NOT IN
	(
		SELECT Ayer.ArchivoId
		FROM [SitioValidador].[ope].[Comprobante] AS Ayer	
	)
	ORDER BY Hoy.ArchivoId ASC;
	GO
	-- Archivo
	INSERT INTO [SitioValidador].[ope].[Archivo](ArchivoId, NombreArchivo, FechaRecepcion, TotalRegistros, Estado, TipoArchivoId, ErrorId, UsuarioId, LoteId)
	SELECT TOP(1000) Hoy.ArchivoId, Hoy.NombreArchivo, Hoy.FechaRecepcion, Hoy.TotalRegistros, Hoy.Estado, Hoy.TipoArchivoId, Hoy.ErrorId, Hoy.UsuarioId, Hoy.LoteId
	FROM [SitioValidador_reporteNoOk].[ope].[Archivo] AS Hoy
	WHERE Hoy.ArchivoId NOT IN
	(
		SELECT Ayer.ArchivoId
		FROM [SitioValidador].[ope].[Archivo] AS Ayer	
	)
	ORDER BY Hoy.ArchivoId ASC;
*/