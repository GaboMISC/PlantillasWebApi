USE [SitioValidador];
-- Desactiva los Mensajes
SET NOCOUNT ON;
-- Transaccion
DECLARE @Transaccion VARCHAR(20) = 'CrearTablas';

BEGIN TRANSACTION @Transaccion;
	BEGIN TRY
		-- Tablas
		CREATE TABLE [adm].[NumeroPedido]
		(
			NumeroPedido VARCHAR(30) NOT NULL,
			RazonSocial VARCHAR(200) NOT NULL,
			InstitucionId BIGINT NOT NULL,
			UsuarioModifica CHAR(36) NOT NULL,
			FechaModifica DATETIME NOT NULL,
			CONSTRAINT PK_NumeroPedido_NumeroPedido PRIMARY KEY CLUSTERED (NumeroPedido ASC),
			CONSTRAINT FK_NumeroPedido_Institucion FOREIGN KEY (InstitucionId) REFERENCES [SitioValidador].[adm].[Institucion] (InstitucionId)			
		);

		CREATE TABLE [aud].[NumeroPedido]
		(
			NumeroPedido VARCHAR(30) NOT NULL,
			RazonSocial VARCHAR(200) NOT NULL,
			InstitucionId INT NOT NULL,
			UsuarioModifica CHAR(36) NOT NULL,
			FechaAuditoria DATETIME NOT NULL,	
			NombreServidor VARCHAR(50) NOT NULL,
			UsuarioSesion VARCHAR(50) NOT NULL,
			Operacion CHAR(1) NOT NULL
		);

		-- Indices Tabla
		CREATE NONCLUSTERED INDEX IXNC_NumeroPedido_FechaAuditoria ON [SitioValidador].[aud].[NumeroPedido] (FechaAuditoria DESC);
		CREATE NONCLUSTERED INDEX IXNC_NumeroPedido_Operacion ON [SitioValidador].[aud].[NumeroPedido] (Operacion ASC);

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
			
		PRINT 'Error al Crear las Tablas:' + CHAR(10) + 'Numero de Error: ' + CONVERT(VARCHAR, ERROR_NUMBER()) + CHAR(13) + 'Linea: ' + CONVERT(VARCHAR, ERROR_LINE()) + CHAR(10) + 'Mensaje: ' + CONVERT(VARCHAR, ERROR_MESSAGE()) + '.';
	END CATCH

-- SELECT * FROM [SitioValidador].[adm].[NumeroPedido];
-- SELECT * FROM [SitioValidador].[aud].[NumeroPedido];