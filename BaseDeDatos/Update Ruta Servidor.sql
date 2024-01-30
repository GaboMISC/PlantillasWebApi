/* 
	Consulta Ruta Servidor:
	SELECT Ruta FROM [SitioValidador].[adm].[Institucion] WHERE Nombre = 'HSBC';	
*/
USE SitioValidador;
GO

/* Remplazo de variables */
DECLARE @ServidorAnterior VARCHAR(100) = 'VPD00'; -- Remplace el servidor VIEJO (Consulta anterior)
DECLARE @ServidorNuevo VARCHAR(100) = 'VPD51'; -- Remplace el servidor NUEVO

/* ***** Script ***** */
-- Transaccion
DECLARE @Transaccion VARCHAR(20);
SELECT @Transaccion = 'ActualizarTabla';  

BEGIN TRANSACTION @Transaccion;
	BEGIN TRY

		UPDATE [SitioValidador].[adm].[Institucion] SET Ruta = REPLACE(Ruta, @ServidorAnterior, @ServidorNuevo) WHERE Nombre = 'HSBC';
		PRINT 'Actualización exitosa.';
				
		-- Confirma la Transaccion
		COMMIT TRANSACTION @Transaccion;
	END TRY
	BEGIN CATCH
		-- Rechaza la Transaccion
		ROLLBACK TRANSACTION;

		-- Imprime el Error
			SELECT   
			ERROR_NUMBER() AS CodigoError, 
			ERROR_LINE() AS LineaError,
			ERROR_MESSAGE() AS Mensaje;
			
		PRINT 'Error al Actualizar la Tabla:' + CHAR(10) + 'Numero de Error: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + CHAR(13) + 'Linea: ' + CONVERT(VARCHAR, ERROR_LINE()) + CHAR(10) + 'Mensaje: ' + CONVERT(VARCHAR, ERROR_MESSAGE()) + '.';
	END CATCH