USE [SitioValidador];
GO
-- Desactiva los Mensajes
SET NOCOUNT ON;
GO
-- ======================================================
-- Descripción:	Auditoría en tabla [adm].[NumeroPedido]
-- 2020-09-28 gmartinez: Creación del Desencadenador.
-- ======================================================

-- Trigger
CREATE TRIGGER tAgregarAuditoriaNumeroPedido
	ON [adm].[NumeroPedido] -- Se activa con la Tabla
	FOR INSERT, UPDATE, DELETE -- Se activa con INSERT, UPDATE o DELETE
AS
BEGIN
	-- Variables
	DECLARE @TipoOperacion CHAR(1);

	-- Tipo de Operacion
	IF EXISTS (SELECT 1 FROM INSERTED WITH (NOLOCK))
		BEGIN
			IF EXISTS (SELECT 1 FROM DELETED WITH (NOLOCK))
				BEGIN
					SET @TipoOperacion = 'A'; -- Actualizar
                END;
            ELSE
                BEGIN
                    SET @TipoOperacion = 'I'; -- Insertar
                END;
		END;
      ELSE
         BEGIN
               SET @TipoOperacion = 'B'; -- Borrar
         END;

	-- Inserta en la tabla auditoria
	IF (@TipoOperacion = 'A' OR @TipoOperacion = 'I') -- Insertar o Actualizar
		BEGIN
			INSERT INTO [aud].[NumeroPedido] (NumeroPedido, RazonSocial, InstitucionId, UsuarioModifica, FechaAuditoria, NombreServidor, UsuarioSesion, Operacion)
            SELECT NumeroPedido, RazonSocial, InstitucionId, UsuarioModifica, GETDATE(), HOST_NAME(), SYSTEM_USER, @TipoOperacion
            FROM INSERTED WITH (NOLOCK); -- Inserta los Valores
         END;            
      ELSE -- Borrar
         BEGIN
			INSERT INTO [aud].[NumeroPedido] (NumeroPedido, RazonSocial, InstitucionId, UsuarioModifica, FechaAuditoria, NombreServidor, UsuarioSesion, Operacion)
            SELECT NumeroPedido, RazonSocial, InstitucionId, UsuarioModifica, GETDATE(), HOST_NAME(), SYSTEM_USER, @TipoOperacion
            FROM DELETED WITH (NOLOCK); -- Inserta los Valores
         END;
END

-- DROP TRIGGER [adm].[tAgregarAuditoriaNumeroPedido];