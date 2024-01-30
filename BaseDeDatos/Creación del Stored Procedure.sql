USE [SitioValidador];
GO
-- ======================================================
-- Descripci�n: Administraci�n del n�mero de pedido.
-- 2020-09-28 gmartinez: Creaci�n del Stored Procedure.
-- ======================================================
CREATE PROCEDURE [adm].[pNumeroPedido]
(
	@Opcion				INT,
	@NumeroPedido		VARCHAR(30)		= NULL,
	@RazonSocial		VARCHAR(200)	= NULL,
	@InstitucionId		BIGINT			= NULL,
	@UsuarioModifica	CHAR(36)		= NULL,
	@CodigoError		INT				OUTPUT,	-- C�digo de error
	@MensajeError		VARCHAR(2048)	OUTPUT	-- Mensaje de error
)
AS
BEGIN
	-- Desactiva los mensajes
	SET NOCOUNT ON;

	-- Transaccion
	DECLARE @Transaccion VARCHAR(20) = 'NumeroDePedido';
		
	BEGIN TRY
		BEGIN TRANSACTION @Transaccion;

		SET @CodigoError = 0;
		SET @MensajeError = '';

		IF (@Opcion = 1) -- Limpia la tabla
			BEGIN
				DELETE FROM [adm].[NumeroPedido];
			END;

		IF (@Opcion = 2) -- Inserta el nuevo registro
			BEGIN
				INSERT INTO [adm].[NumeroPedido] (NumeroPedido, RazonSocial, InstitucionId, UsuarioModifica, FechaModifica)
				VALUES(@NumeroPedido, @RazonSocial, @InstitucionId, @UsuarioModifica, GETDATE());
			END;

		IF (@Opcion = 3) -- Consulta si existe el n�mero de pedido
			BEGIN
				IF NOT EXISTS (SELECT * FROM [adm].[NumeroPedido] WHERE NumeroPedido = @NumeroPedido)
					BEGIN
						SET @CodigoError = 2004;
						SET @MensajeError = 'N�mero de pedido no v�lido, contacta al comprador.';
					END;
			END;
			
		-- Confirma la transaccion
		COMMIT TRANSACTION @Transaccion;		
	END TRY
	BEGIN CATCH
		-- Obtiene el error
		SET @CodigoError = ERROR_NUMBER();
		SET @MensajeError = ERROR_MESSAGE();

		-- Rechaza la transaccion
		ROLLBACK TRANSACTION;
	END CATCH;
END;

-- EXECUTE [adm].[pNumeroPedido] @Opcion = 1, @CodigoError = '', @MensajeError = '';

-- EXECUTE [adm].[pNumeroPedido] @Opcion = 2, @NumeroPedido = '12345', @RazonSocial = 'Cecoban S.A. de C.V.', @InstitucionId = 1, @UsuarioModifica = '370ADB0D-52B1-4AD7-A27C-090BFCDB4EC4', @CodigoError = '', @MensajeError = '';