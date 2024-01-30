USE [SitioValidador];
-- Desactiva los Mensajes
SET NOCOUNT ON;
-- Transaccion
DECLARE @Transaccion VARCHAR(20) = 'Transacci�n';

BEGIN TRANSACTION @Transaccion;
	BEGIN TRY
		-- Inserta el error}
		INSERT INTO [SitioValidador].[adm].[CatalogoError] (CodigoError, MensajeError, Estado)
		VALUES('2004', 'N�mero de pedido no v�lido, contacta al comprador.', 1);

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
			
		PRINT 'Ocurri� un Error:' + CHAR(10) + 'N�mero de Error: ' + CONVERT(VARCHAR(50), ERROR_NUMBER()) + CHAR(13) + 'L�nea: ' + CONVERT(VARCHAR(50), ERROR_LINE()) + CHAR(10) + 'Mensaje: ' + CONVERT(VARCHAR(500), ERROR_MESSAGE()) + '.';
	END CATCH

-- SELECT * FROM [SitioValidador].[adm].[CatalogoError];