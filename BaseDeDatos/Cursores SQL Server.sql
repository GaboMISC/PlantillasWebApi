-- Transaccion
DECLARE @Transaccion VARCHAR(20);
SELECT @Transaccion = 'RollbackEstadoSat';  

BEGIN TRANSACTION @Transaccion;
	BEGIN TRY
		-- Variables Locales
		DECLARE @EstadoAceptadoSat INT = [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','AceptadoSAT');
		DECLARE @EstadoRechazadoSat INT = [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','RechazadoSAT');
		DECLARE @EstadoRechazadoPac INT = [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','RechazadoPAC');

		/* ---------- Foreach ---------- */
		DECLARE @Uuid UNIQUEIDENTIFIER;
		DECLARE @EstadoAnterior INT = 0;
		DECLARE @UltimoEstado INT = 0;
		DECLARE @UltimaFecha DATETIME;

		DECLARE @i INT = 1;
		DECLARE @EstadoActualizar VARCHAR(50) = '';

		-- Crea el Cursor
		DECLARE CursorCcb CURSOR
			FOR SELECT DISTINCT(UUID) FROM [PACNivel1].[his].[Comprobante] WHERE EstadoComprobanteId = @EstadoAceptadoSat;
		-- Abre el Cursor
		OPEN CursorCcb;
		-- Itera en la Consulta
		FETCH NEXT FROM CursorCcb INTO @Uuid;

		WHILE(@@FETCH_STATUS = 0) -- Itera Mientras Existan Registros en el Cursor
		BEGIN 
			---- Obtiene los Ultimos Dos Estados del Uuid
			WITH UltimoEstado (UUID, Fecha, EstadoComprobanteId, Fila) AS
			(
				SELECT TOP(2) EC.UUID, EC.Fecha, EC.EstadoComprobanteId, ROW_NUMBER() OVER (ORDER BY UUID) AS Fila
				FROM [PACNivel1].[his].[EstadoComprobante] AS EC
				WHERE EC.UUID = @Uuid
				ORDER BY EC.Fecha DESC
			)
			SELECT @UltimoEstado = EstadoComprobanteId FROM UltimoEstado WHERE Fila = 1;

			WITH EstadoAnterior (UUID, Fecha, EstadoComprobanteId, Fila) AS
			(
				SELECT TOP(2) EC.UUID, EC.Fecha, EC.EstadoComprobanteId, ROW_NUMBER() OVER (ORDER BY UUID) AS Fila
				FROM [PACNivel1].[his].[EstadoComprobante] AS EC
				WHERE EC.UUID = @Uuid
				ORDER BY EC.Fecha DESC
			)
			SELECT @EstadoAnterior = EstadoComprobanteId FROM EstadoAnterior WHERE Fila = 2;

			---- Obtiene la Ultima Fecha del Uuid
			WITH UltimaFecha (UUID, Fecha, EstadoComprobanteId, Fila) AS
			(
				SELECT TOP(1) EC.UUID, EC.Fecha, EC.EstadoComprobanteId, ROW_NUMBER() OVER (ORDER BY UUID) AS Fila
				FROM [PACNivel1].[his].[EstadoComprobante] AS EC
				WHERE EC.UUID = @Uuid
				ORDER BY EC.Fecha DESC
			)
			SELECT @UltimaFecha = Fecha FROM UltimaFecha WHERE Fila = 1;
		
			-- Actualiza el Ultimo Estado
			IF(@UltimoEstado = @EstadoAceptadoSat AND @EstadoAnterior = @EstadoRechazadoSat)
			BEGIN
				SET @EstadoActualizar = 'Rechazado SAT';

				--UPDATE [PACNivel1].[his].[EstadoComprobante]
				--SET EstadoComprobanteId = @EstadoRechazadoSat -- Comprobante Rechazado por el SAT
				--WHERE UUID = @Uuid
				--AND Fecha = @UltimaFecha;
			END

			IF(@UltimoEstado = @EstadoAceptadoSat AND @EstadoAnterior = @EstadoRechazadoPac)
			BEGIN
				SET @EstadoActualizar = 'Rechazado PAC';

				--UPDATE [PACNivel1].[his].[EstadoComprobante]
				--SET EstadoComprobanteId = @EstadoRechazadoPac -- Comprobante Rechazado por el PAC
				--WHERE UUID = @Uuid
				--AND Fecha = @UltimaFecha;
			END

			-- Imprime el Resultado
			PRINT 'Uuid: ' + CONVERT(VARCHAR(100), @Uuid) + ', i: '+ CONVERT(VARCHAR, @i) + ', Ultimo: ' + CONVERT(VARCHAR, @UltimoEstado) + ', Anterior: ' + CONVERT(VARCHAR, @EstadoAnterior) + ', Fecha: ' +CONVERT(VARCHAR, @UltimaFecha) + ', Estado Actual: ' + CONVERT(VARCHAR, @EstadoActualizar);
	
			-- Lectura de la Siguiente Fila
			FETCH NEXT FROM CursorCcb INTO @Uuid;

			-- Cambia las Variables
			SET @i = @i + 1;
			SET @EstadoActualizar = '';
		END
		-- Cierra el Cursor
		CLOSE CursorCcb;
		-- Libera el Cursor de la Memoria RAM
		DEALLOCATE CursorCcb;

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
			
		PRINT 'Error al Insertar los Registros:' + CHAR(10) + 'Numero de Error: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + CHAR(13) + 'Linea: ' + CONVERT(VARCHAR, ERROR_LINE()) + CHAR(10) + 'Mensaje: ' + CONVERT(VARCHAR, ERROR_MESSAGE()) + '.';
	END CATCH