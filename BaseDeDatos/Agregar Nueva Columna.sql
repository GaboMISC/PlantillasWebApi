-- Transaccion
DECLARE @Transaccion VARCHAR(20);
SELECT @Transaccion = 'ActualizarTabla';  

BEGIN TRANSACTION @Transaccion;
	BEGIN TRY
		-- Agrega las Columnas a la Tabla
		ALTER TABLE [PAC_Cecoban].[ope].[ControlCargaComprobante]
		ADD TotalComprobantes INT NOT NULL DEFAULT 0 WITH VALUES, 
			TotalComprobantesProcesados INT NOT NULL DEFAULT 0 WITH VALUES;

		-- WITH VALUES se asegurará de que el valor DEFAULT específico se aplique a las filas existentes

		-- Imprime el Resultado
		PRINT 'Tabla Actualizada con Exito!';
		
		-- SELECT * FROM [PAC_Cecoban].[ope].[ControlCargaComprobante]

		-- Confirma la Transaccion
		--COMMIT TRANSACTION @Transaccion;
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