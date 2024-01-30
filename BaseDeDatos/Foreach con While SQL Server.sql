-- Transaccion
DECLARE @Transaccion VARCHAR(20);
SELECT @Transaccion = 'RollbackEstadoSat';  

-- Variables Globales
DECLARE @LoteId VARCHAR(100) = '89145,89146';
DECLARE @EmisorRfc BIGINT = (SELECT bgEmisorId FROM [PAC_Cecoban].[dbo].[tadEmisor] WITH(NOLOCK) WHERE nvRFC = 'CSF0603083F1');

BEGIN TRANSACTION @Transaccion;
	BEGIN TRY
		-- Variables Globales
		DECLARE @EstadoAceptadoSat INT = [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','AceptadoSAT');
		DECLARE @EstadoRechazadoSat INT = [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','RechazadoSAT');
		DECLARE @EstadoRechazadoPac INT = [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','RechazadoPAC');

		DECLARE @NombreRechazadoSat VARCHAR(50);
		DECLARE @NombreRechazadoPac VARCHAR(50);
		SELECT @NombreRechazadoSat = nvDescripcion FROM [Pac_Cecoban].[dbo].[tadCatalogoComun] WITH(NOLOCK) WHERE bgCatalogoComunId = @EstadoRechazadoSat;
		SELECT @NombreRechazadoPac = nvDescripcion FROM [Pac_Cecoban].[dbo].[tadCatalogoComun] WITH(NOLOCK) WHERE bgCatalogoComunId = @EstadoRechazadoPac;

		-- Obtiene y Enumera los Uuids
		WITH TablaUuids AS
		(
			SELECT DISTINCT(UUID), LoteId
			FROM [PACNivel1].[his].[Comprobante] WITH(NOLOCK)
			WHERE EstadoComprobanteId = @EstadoAceptadoSat
			AND LoteId IN (SELECT value FROM STRING_SPLIT(@LoteId, ','))
			AND EmisorId = @EmisorRfc
			GROUP BY UUID, LoteId
		),
		TablaFilas AS
		(
			SELECT ROW_NUMBER() OVER (ORDER BY UUID) AS Fila, * FROM TablaUuids
		)
		SELECT Fila, UUID, LoteId INTO #TablaTemporal
		FROM TablaFilas
		ORDER BY Fila;
		
		/* ---------- Foreach ---------- */
		DECLARE @i INT = 1;
		DECLARE @CantidadRegistros INT = 0;
		DECLARE @Uuid UNIQUEIDENTIFIER;

		DECLARE @EstadoAnterior INT = 0;
		DECLARE @UltimoEstado INT = 0;
		DECLARE @UltimaFecha DATETIME;
		DECLARE @EstadoActualizar VARCHAR(100) = '';
            
		SET @CantidadRegistros = (SELECT COUNT(DISTINCT(UUID)) FROM [PACNivel1].[his].[Comprobante] WITH(NOLOCK) WHERE EstadoComprobanteId = @EstadoAceptadoSat AND LoteId IN (SELECT value FROM STRING_SPLIT(@LoteId, ',')) AND EmisorId = @EmisorRfc);

		IF (@CantidadRegistros > 0)
		BEGIN
			WHILE (@i <= @CantidadRegistros)
			BEGIN
				/* ---------- Iteracion por UUID ---------- */
				SELECT @Uuid = UUID FROM #TablaTemporal WHERE Fila = @i;
		
				---- Obtiene los Ultimos Dos Estados del Uuid
				WITH UltimoEstado (UUID, Fecha, EstadoComprobanteId, Fila) AS
				(
					SELECT TOP(2) EC.UUID, EC.Fecha, EC.EstadoComprobanteId, ROW_NUMBER() OVER (ORDER BY UUID) AS Fila
					FROM [PACNivel1].[his].[EstadoComprobante] AS EC WITH(NOLOCK)
					WHERE EC.UUID = @Uuid
					ORDER BY EC.Fecha DESC
				)
				SELECT @UltimoEstado = EstadoComprobanteId FROM UltimoEstado WHERE Fila = 1;
		
				WITH EstadoAnterior (UUID, Fecha, EstadoComprobanteId, Fila) AS
				(
					SELECT TOP(2) EC.UUID, EC.Fecha, EC.EstadoComprobanteId, ROW_NUMBER() OVER (ORDER BY UUID) AS Fila
					FROM [PACNivel1].[his].[EstadoComprobante] AS EC WITH(NOLOCK)
					WHERE EC.UUID = @Uuid
					ORDER BY EC.Fecha DESC
				)
				SELECT @EstadoAnterior = EstadoComprobanteId FROM EstadoAnterior WHERE Fila = 2;

				-- Actualiza el Ultimo Estado
				IF(@UltimoEstado = @EstadoAceptadoSat AND @EstadoAnterior = @EstadoRechazadoSat)
				BEGIN
					SET @EstadoActualizar = @NombreRechazadoSat;

					-- Actualiza el Estado del Comprobante ha: Rechazado por el SAT
					UPDATE [PACNivel1].[his].[Comprobante]
					SET EstadoComprobanteId = @EstadoRechazadoSat,
					EstadoComprobante = @NombreRechazadoSat
					WHERE UUID = @Uuid
					AND LoteId = (SELECT LoteId FROM #TablaTemporal WITH(NOLOCK) WHERE UUID = @Uuid)
					AND EmisorId = @EmisorRfc;

					---- Inseta un Nuevo Estado del Comprobante
					INSERT INTO [PACNivel1].[his].[EstadoComprobante] ([UUID], [Fecha], [CodigoRetorno], [EstadoComprobanteId], [FechaInsercion], [Acuse])
					VALUES(@Uuid, GETDATE(), 225, @EstadoRechazadoSat, GETDATE(), NULL);
				END

				IF(@UltimoEstado = @EstadoAceptadoSat AND @EstadoAnterior = @EstadoRechazadoPac)
				BEGIN
					SET @EstadoActualizar = @NombreRechazadoPac;

					-- Actualiza el Estado del Comprobante ha: Rechazado por el PAC
					UPDATE [PACNivel1].[his].[Comprobante]
					SET EstadoComprobanteId = @EstadoRechazadoPac,
					EstadoComprobante = @NombreRechazadoPac
					WHERE UUID = @Uuid
					AND LoteId = (SELECT LoteId FROM #TablaTemporal WITH(NOLOCK) WHERE UUID = @Uuid)
					AND EmisorId = @EmisorRfc;

					---- Inseta un Nuevo Estado del Comprobante
					INSERT INTO [PACNivel1].[his].[EstadoComprobante] ([UUID], [Fecha], [CodigoRetorno], [EstadoComprobanteId], [FechaInsercion], [Acuse])
					VALUES(@Uuid, GETDATE(), 225, @EstadoRechazadoPac, GETDATE(), NULL);
				END
	    
				-- Imprime el Resultado
				PRINT 'Uuid: ' + CONVERT(VARCHAR(100), @Uuid) + ', i: '+ CONVERT(VARCHAR, @i) + ', Ultimo: ' + CONVERT(VARCHAR, @UltimoEstado) + ', Anterior: ' + CONVERT(VARCHAR, @EstadoAnterior) + ', Nuevo Estado: ' + CONVERT(VARCHAR(100), @EstadoActualizar);

				-- Cambia las Variables
				SET @EstadoActualizar = '';
				SET @i = @i + 1; -- Iteracion
			END; -- While
		END;

		-- Elimina la Tabla Temporal
		DROP TABLE #TablaTemporal;		

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
			
		PRINT 'Error al Insertar los Registros:' + CHAR(10) + 'Numero de Error: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + CHAR(13) + 'Linea: ' + CONVERT(VARCHAR, ERROR_LINE()) + CHAR(10) + 'Mensaje: ' + CONVERT(VARCHAR, ERROR_MESSAGE()) + '.';
	END CATCH
/*
	-- Estados del Comprobante
	SELECT * FROM [Pac_Cecoban].[dbo].[tadCatalogoComun] WHERE nvTabla Like '%CFDIEstado%';

	-- Obtiene el Usuario
	SELECT * FROM [PAC_Cecoban].[dbo].[tadEmisor] WHERE nvRFC LIKE '%BNM%';

	-- Obtener RFC Emisor
	SELECT * FROM [Pac_Cecoban].[dbo].[tadCatalogoComun] WHERE bgCatalogoComunId = 177;

	-- Obtiene Informacion de un Uuid
	SELECT DISTINCT * FROM [PACNivel1].[his].[Comprobante] WHERE UUID = '54F1D0B3-CB60-418F-BE6E-A48AD8A26081' ORDER BY FechaInsercion DESC;
	SELECT DISTINCT * FROM [PACNivel1].[his].[EstadoComprobante] WHERE UUID = '54F1D0B3-CB60-418F-BE6E-A48AD8A26081' ORDER BY Fecha DESC;

	/* ***** INSERT -> Comprobante Rechazado por el SAT ***** */

	INSERT [PACNivel1].[his].[Comprobante] ([UUID], [InstitucionId], [EmisorId], [FechaInsercion], [RFCReceptor], [RazonSocialReceptor], [OrigenCFDIId], [LineaProductoId], [FechaTimbrado], [LoteId], [TipoId], [Serie], [Folio], [Total], [EstadoComprobanteId], [EstadoComprobante], [PACOrigenId])
	VALUES('19BBD4FE-4A49-417A-BAE8-02FB8E9920A5', 29, 71, GETDATE(), 'MAFG930824HR1', 'GABRIEL MARTINEZ FLORES', 30, 37, GETDATE(), 89145, 215, 'A', 356, 30000.50, 208, 'Aceptado SAT', 0);
	
	INSERT [PACNivel1].[his].[EstadoComprobante] ([UUID], [Fecha], [CodigoRetorno], [EstadoComprobanteId], [FechaInsercion], [Acuse])
	VALUES('19BBD4FE-4A49-417A-BAE8-02FB8E9920A5', GETDATE(), 225, 209, GETDATE(), NULL);
	INSERT [PACNivel1].[his].[EstadoComprobante] ([UUID], [Fecha], [CodigoRetorno], [EstadoComprobanteId], [FechaInsercion], [Acuse])
	VALUES('19BBD4FE-4A49-417A-BAE8-02FB8E9920A5', GETDATE(), 225, 208, GETDATE(), NULL);

	/* ***** INSERT -> Comprobante Rechazado por el PAC ***** */

	INSERT [PACNivel1].[his].[Comprobante] ([UUID], [InstitucionId], [EmisorId], [FechaInsercion], [RFCReceptor], [RazonSocialReceptor], [OrigenCFDIId], [LineaProductoId], [FechaTimbrado], [LoteId], [TipoId], [Serie], [Folio], [Total], [EstadoComprobanteId], [EstadoComprobante], [PACOrigenId])
	VALUES('F81D6336-5B8F-4B2B-A4EB-584716B83EC7', 29, 71, GETDATE(), 'MAFG930824HR1', 'GABRIEL MARTINEZ FLORES', 30, 37, GETDATE(), 89146, 215, 'A', 356, 30000.50, 208, 'Aceptado SAT', 0);
	
	INSERT [PACNivel1].[his].[EstadoComprobante] ([UUID], [Fecha], [CodigoRetorno], [EstadoComprobanteId], [FechaInsercion], [Acuse])
	VALUES('F81D6336-5B8F-4B2B-A4EB-584716B83EC7', GETDATE(), 225, 207, GETDATE(), NULL);
	INSERT [PACNivel1].[his].[EstadoComprobante] ([UUID], [Fecha], [CodigoRetorno], [EstadoComprobanteId], [FechaInsercion], [Acuse])
	VALUES('F81D6336-5B8F-4B2B-A4EB-584716B83EC7', GETDATE(), 225, 208, GETDATE(), NULL);
	
	-- Obtiene los Diferetes Estados
	SELECT [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','AceptadoSAT'); -- 208
	SELECT [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','RechazadoSAT'); -- 209
	SELECT [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','RechazadoPAC'); -- 207
	SELECT [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','Cancelado'); -- 210
	SELECT [Pac_Cecoban].[dbo].[fadCatComunId]('CFDIEstado','Timbrado'); -- 206

	-- Obtiene la Informacion de Todos los Registros
	SELECT DISTINCT * FROM [PACNivel1].[his].[Comprobante] ORDER BY FechaInsercion DESC;
	SELECT DISTINCT * FROM [PACNivel1].[his].[EstadoComprobante] ORDER BY FechaInsercion DESC;
	
	-- Consulta de Uuids
	DECLARE @LoteId VARCHAR(100) = '89145,89146';

	SELECT DISTINCT(UUID), LoteId
	FROM [PACNivel1].[his].[Comprobante] WITH(NOLOCK)
	WHERE EstadoComprobanteId = 208
	AND LoteId IN (SELECT value FROM STRING_SPLIT(@LoteId, ','))
	AND EmisorId = 71
	GROUP BY UUID, LoteId;

	SELECT COUNT(DISTINCT(UUID)) FROM [PACNivel1].[his].[Comprobante] WITH(NOLOCK) WHERE EstadoComprobanteId = 208 AND LoteId IN (SELECT value FROM STRING_SPLIT(@LoteId, ',')) AND EmisorId = 71
*/