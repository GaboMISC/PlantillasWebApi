-- Se Crea la Base de Datos
USE master;
GO
IF EXISTS(SELECT * FROM SYS.DATABASES WHERE NAME='boutique')
	BEGIN
		-- Si Existe
		DROP DATABASE boutique;
		CREATE DATABASE boutique;
	END
ELSE
	BEGIN
		-- No Existe
		CREATE DATABASE boutique;
	END -- if (Existe)
GO
-- Pone en Uso la Base de Datos
USE boutique;
GO
/* ******************** Se Crean las Tablas ******************** */

CREATE TABLE material
(
	id_material INT IDENTITY PRIMARY KEY NOT NULL,
	descripcion_material VARCHAR(50) NOT NULL,
	UNIQUE (descripcion_material)
);
GO
CREATE TABLE color
(
	id_color INT IDENTITY PRIMARY KEY NOT NULL,
	descripcion_color VARCHAR(50) NOT NULL,
	UNIQUE (descripcion_color)
);
GO
CREATE TABLE proveedor
(
	id_proveedor INT IDENTITY PRIMARY KEY NOT NULL,
	nombre_proveedor VARCHAR(50) NOT NULL,
	rfc_proveedor VARCHAR(50) NOT NULL,
	contacto_proveedor VARCHAR(50) NOT NULL,
	telefono_proveedor VARCHAR(50) NOT NULL,
	domicilio_proveedor VARCHAR(200) NOT NULL,
	UNIQUE (rfc_proveedor)
);
GO
CREATE TABLE producto
(
	id_producto INT IDENTITY PRIMARY KEY NOT NULL,
	descripcion_producto VARCHAR(200) NOT NULL,
	precio_producto FLOAT NOT NULL,
	almacen_producto INT NOT NULL,
	num_color INT NOT NULL,
	num_material INT NOT NULL,	
	num_proveedor INT NOT NULL,
	FOREIGN KEY (num_color) REFERENCES color(id_color),
	FOREIGN KEY (num_material) REFERENCES material(id_material),
	FOREIGN KEY (num_proveedor) REFERENCES proveedor(id_proveedor)
);
GO
CREATE TABLE detalle_venta
(
	id_detalle_venta INT IDENTITY PRIMARY KEY NOT NULL,
	num_venta INT NOT NULL,
	num_producto INT NOT NULL,
	cantidad_detalle_venta INT NOT NULL,
	precio_detalle_venta FLOAT NOT NULL,
	subtotal_detalle_venta FLOAT NOT NULL,	
	FOREIGN KEY (num_producto) REFERENCES producto(id_producto)
);
GO
/* ******************** Se Insertan Datos en las Tablas ******************** */

-- Material
INSERT INTO material(descripcion_material) VALUES('Sintetico');
INSERT INTO material(descripcion_material) VALUES('Piel');
INSERT INTO material(descripcion_material) VALUES('Tela');
INSERT INTO material(descripcion_material) VALUES('Plastico');
INSERT INTO material(descripcion_material) VALUES('Fantasia');
GO
-- Color
INSERT INTO color(descripcion_color) VALUES('Rosa');
INSERT INTO color(descripcion_color) VALUES('Azul');
INSERT INTO color(descripcion_color) VALUES('Rojo');
INSERT INTO color(descripcion_color) VALUES('Negro');
INSERT INTO color(descripcion_color) VALUES('Blanco');
GO
-- Proveedor
INSERT INTO proveedor(nombre_proveedor, rfc_proveedor, contacto_proveedor, telefono_proveedor, domicilio_proveedor) 
VALUES('Linio', 'LNO125432', 'Belen Campos Tiburcio', '5500127690', 'San Fernando Avenue 649, Manantial Peña Pobre, 14060 Ciudad de México, CDMX');
INSERT INTO proveedor(nombre_proveedor, rfc_proveedor, contacto_proveedor, telefono_proveedor, domicilio_proveedor) 
VALUES('Jennyfer', 'JNF084523', 'Luis Mario Salas Cardenas', '5578120934', 'Avenida Hidalgo S/N, Industrial Tlaxcolpan, 54030 Tlalnepantla de Baz, México');
INSERT INTO proveedor(nombre_proveedor, rfc_proveedor, contacto_proveedor, telefono_proveedor, domicilio_proveedor) 
VALUES('Zara', 'ZRA237834', 'Edgar Eduardo Fabian Herrera', '5598010245', 'Av. Central Ote. 837, Asamblea de barrio, Zona Sin Asignación de Nombre de Col 42, 29000 Tuxtla Gutiérrez, Chiapas');
GO
-- Producto
INSERT INTO producto(descripcion_producto, precio_producto, almacen_producto, num_color, num_material, num_proveedor) 
VALUES('Bolso con Asas Madison', 450.99, 25, 1, 1, 2);
INSERT INTO producto(descripcion_producto, precio_producto, almacen_producto, num_color, num_material, num_proveedor) 
VALUES('Bolso de Mano Pandora', 1568.00, 7, 4, 2, 3);
INSERT INTO producto(descripcion_producto, precio_producto, almacen_producto, num_color, num_material, num_proveedor) 
VALUES('Bolso con Asas Cinthya', 877.00, 10, 2, 3, 2);
INSERT INTO producto(descripcion_producto, precio_producto, almacen_producto, num_color, num_material, num_proveedor) 
VALUES('Bolso de Mano Satchel', 1250.50, 15, 5, 1, 1);
INSERT INTO producto(descripcion_producto, precio_producto, almacen_producto, num_color, num_material, num_proveedor) 
VALUES('Bolso de Hombro Cloe', 2400.50, 9, 3, 2, 2);
GO
-- Detalle de Venta
INSERT INTO detalle_venta(num_venta, num_producto, cantidad_detalle_venta, precio_detalle_venta, subtotal_detalle_venta) 
VALUES(1, 1, 3, 450.99, 1352.97);
INSERT INTO detalle_venta(num_venta, num_producto, cantidad_detalle_venta, precio_detalle_venta, subtotal_detalle_venta) 
VALUES(1, 3, 2, 877.00, 1754);
INSERT INTO detalle_venta(num_venta, num_producto, cantidad_detalle_venta, precio_detalle_venta, subtotal_detalle_venta) 
VALUES(2, 5, 3, 2400.50, 7201.50);
INSERT INTO detalle_venta(num_venta, num_producto, cantidad_detalle_venta, precio_detalle_venta, subtotal_detalle_venta) 
VALUES(2, 2, 1, 1568.00, 1568.00);
GO
/* ******************** Consultas ******************** */
/*
SELECT * FROM material;
SELECT * FROM color;
SELECT * FROM proveedor;
SELECT * FROM producto;
SELECT * FROM detalle_venta;
*/
/* ******************** Funciones ******************** */

-------------------- Retorna una Tabla --------------------
CREATE FUNCTION F_Productos()
RETURNS TABLE  
AS  
RETURN   
(
	-- Consulta Sin Punto y Coma (;)
    SELECT P.id_producto AS Id_Producto, P.descripcion_producto AS Descripcion, P.precio_producto AS Precio, 
	C.descripcion_color AS Color, M.descripcion_material AS Material, PR.nombre_proveedor AS Proveedor, P.almacen_producto AS Almacen
	FROM producto AS P, color AS C, material AS M, proveedor AS PR
	WHERE P.num_color = C.id_color
	AND P.num_material = M.id_material
	AND P.num_proveedor = PR.id_proveedor
);

-- Se Ejecuta la Funcion 
-- SELECT * FROM F_Productos();
GO
-------------------- Actualizar Producto --------------------
CREATE FUNCTION Actualizar_Producto
(
	@material INT
)
RETURNS VARCHAR(100)
AS
BEGIN
	-- Variables
    DECLARE @respuesta VARCHAR(100);
	SET @respuesta = 'Texto de Prueba';
	-- Retorna el Valor
	RETURN(@respuesta);
END;

-- Se Ejecuta la Funcion 
-- SELECT dbo.Actualizar_Producto(4);
GO
/* ******************** Vistas ******************** */

-- 1) Datos del Producto
CREATE VIEW V_Productos
AS
SELECT P.id_producto AS Id_Producto, P.descripcion_producto AS Descripcion, P.precio_producto AS Precio, 
C.descripcion_color AS Color, M.descripcion_material AS Material, PR.nombre_proveedor AS Proveedor, P.almacen_producto AS Almacen
FROM producto AS P, color AS C, material AS M, proveedor AS PR
WHERE P.num_color = C.id_color
AND P.num_material = M.id_material
AND P.num_proveedor = PR.id_proveedor;
GO
-- Se ejecuta la Vista
-- SELECT * FROM V_Productos WHERE Id_Producto = 1;

-- 2) Vista Detalle de Venta
CREATE VIEW V_Detalle_Venta
AS
SELECT id_producto, descripcion_producto, precio_producto
FROM producto;
GO
-- Se ejecuta la Vista
-- SELECT * FROM Vista_Detalle_Venta;

/* ******************** Procedimientos Almacenados ******************** */

/* °°°°°°°°°°°°°°° Metodos INSERT °°°°°°°°°°°°°°° */

-------------------- Alta Material --------------------

CREATE PROCEDURE Alta_Material
(
	@material VARCHAR(50),
	@respuesta VARCHAR(100) OUTPUT
)
AS
BEGIN
	-- Variables
	DECLARE @id_material INT;
	-- Validaciones
	IF (@material = '')
	BEGIN
		SET @respuesta = 'Falta Agregar la Descripcion del Material!';
		PRINT 'Falta Agregar la Descripcion del Material!';
	END
	ELSE
	BEGIN

		IF EXISTS (SELECT * FROM material WHERE descripcion_material = @material)
		BEGIN
			SET @respuesta = 'El Material Ya existe!';
			PRINT 'El Material Ya existe!';
		END
		ELSE
		BEGIN
			INSERT INTO material(descripcion_material) VALUES(@material);

			-- SET @nuevo_producto = SCOPE_IDENTITY();
			SET @id_material = @@IDENTITY;
			SELECT @respuesta = CONCAT('Material Registrado con Exito, su id es: ', @id_material);
			PRINT 'Material Registrado con Exito, su id es: ' + CONVERT(VARCHAR, @id_material) + '.';
		END -- if (Existe)

	END -- if (Descripcion Material)
END -- Cierrre del Procedimiento Almacenado

-- Se ejecuta el Pocedimiento Almacenado
-- EXECUTE Alta_Material 'Metal', '';
GO

-------------------- Alta Color --------------------

CREATE PROCEDURE Alta_Color
(
	@color VARCHAR(50),
	@respuesta VARCHAR(100) OUTPUT
)
AS
BEGIN
	-- Variables
	DECLARE @id_color INT;
	-- Validaciones
	IF (@color = '')
	BEGIN
		SET @respuesta = 'Falta Agregar la Descripcion del Color!';
		PRINT 'Falta Agregar la Descripcion del Color!';
	END
	ELSE
	BEGIN

		IF EXISTS (SELECT * FROM color WHERE descripcion_color = @color)
		BEGIN
			SET @respuesta = 'El Color Ya existe!';
			PRINT 'El Color Ya existe!';
		END
		ELSE
		BEGIN
			INSERT INTO color(descripcion_color) VALUES(@color);

			-- SET @nuevo_producto = SCOPE_IDENTITY();
			SET @id_color = @@IDENTITY;
			SELECT @respuesta = CONCAT('Color Registrado con Exito, su id es: ', @id_color);
			PRINT 'Color Registrado con Exito, su id es: ' + CONVERT(VARCHAR, @id_color) + '.';
		END -- if (Existe)

	END -- if (Descripcion Color)
END -- Cierrre del Procedimiento Almacenado

-- Se ejecuta el Pocedimiento Almacenado
-- EXECUTE Alta_Color 'Morado', '';
GO

-------------------- Alta Proveedor --------------------

CREATE PROCEDURE Alta_Proveedor
(
	@nombre VARCHAR(50),
	@rfc VARCHAR(50),
	@contacto VARCHAR(50),
	@telefono VARCHAR(50),
	@domicilio VARCHAR(200),
	@respuesta VARCHAR(100) OUTPUT
)
AS
BEGIN
	-- Variables
	DECLARE @id_proveedor INT;
	-- Validaciones
	IF (@nombre = '')
	BEGIN
		SET @respuesta = 'Falta Agregar el Nombre del Proveedor!';
		PRINT 'Falta Agregar el Nombre del Proveedor!';
	END
	ELSE
	BEGIN
		IF (@contacto = '')
		BEGIN
			SET @respuesta = 'Falta Agregar la Persona de Contacto del Proveedor!';
			PRINT 'Falta Agregar la Persona de Contacto del Proveedor!';
		END
		ELSE
		BEGIN
			IF (@telefono = '')
			BEGIN
				SET @respuesta = 'Falta Agregar el Telefono del Proveedor!';
				PRINT 'Falta Agregar el Telefono del Proveedor!';
			END
			ELSE
			BEGIN
				IF (@domicilio = '')
				BEGIN
					SET @respuesta = 'Falta Agregar el Domicilio del Proveedor!';
					PRINT 'Falta Agregar el Domicilio del Proveedor!';
				END
				ELSE
				BEGIN
						
					IF (@rfc = '')
					BEGIN
						SET @rfc = 'VACIO';
					END

					IF EXISTS (SELECT * FROM proveedor WHERE nombre_proveedor = @nombre)
					BEGIN
						SET @respuesta = 'El Proveedor Ya existe!';
						PRINT 'El Proveedor Ya existe!';
					END
					ELSE
					BEGIN
						INSERT INTO proveedor(nombre_proveedor, rfc_proveedor, contacto_proveedor, telefono_proveedor, domicilio_proveedor) 
						VALUES(@nombre, @rfc, @contacto, @telefono, @domicilio);

						-- SET @nuevo_producto = SCOPE_IDENTITY();
						SET @id_proveedor = @@IDENTITY;
						SELECT @respuesta = CONCAT('Proveedor Registrado con Exito, su id es: ', @id_proveedor);
						PRINT 'Proveedor Registrado con Exito, su id es: ' + CONVERT(VARCHAR, @id_proveedor) + '.';
					END -- if (Existe)

				END -- if (Domicilio)
			END -- if (Telefono)
		END -- if (Contacto)
	END -- if (Nombre)
END -- Cierrre del Procedimiento Almacenado

-- Se ejecuta el Pocedimiento Almacenado
-- EXECUTE Alta_Proveedor 'Lacoste', 'LST230712', 'Ciria Salinas Lopez', '557845312', 'Calle Floresta 77 4 blocks from the Refinería Metro, between Clavería and Nilo, Claveria, 02080 Ciudad de México, CDMX', '';
GO

-------------------- Alta Producto --------------------

CREATE PROCEDURE Alta_Producto
(
	@descripcion VARCHAR(200),
	@precio FLOAT,
	@cantidad INT,
	@color VARCHAR(50),
	@material VARCHAR(50),
	@proveedor VARCHAR(50),
	@respuesta VARCHAR(100) OUTPUT
)
AS
BEGIN
	-- Variables
	DECLARE @id_color INT;
	DECLARE @id_material INT;
	DECLARE @id_proveedor INT;
	DECLARE @nuevo_producto INT;
	-- Validaciones
	IF (@descripcion = '')
	BEGIN
		SET @respuesta = 'Falta Agregar la Descripcion del Producto!';
		PRINT 'Falta Agregar la Descripcion del Producto!';
	END
	ELSE
	BEGIN
		IF (@precio = 0)
		BEGIN
			SET @respuesta = 'Falta Agregar el Precio del Producto!';
			PRINT 'Falta Agregar el Precio del Producto!';
		END
		ELSE
		BEGIN
			IF (@cantidad = 0)
			BEGIN
				SET @respuesta = 'Falta Agregar la Cantidad del Producto!';
				PRINT 'Falta Agregar la Cantidad del Producto!';
			END
			ELSE
			BEGIN
				IF (@color = '')
				BEGIN
					SET @respuesta = 'Falta Agregar el Color del Producto!';
					PRINT 'Falta Agregar el Color del Producto!';
				END
				ELSE
				BEGIN
					IF (@material = '')
					BEGIN
						SET @respuesta = 'Falta Agregar el Material del Producto!';
						PRINT 'Falta Agregar el Material del Producto!';
					END
					ELSE
					BEGIN
						IF (@proveedor = '')
						BEGIN
							SET @respuesta = 'Falta Agregar el Proveedor del Producto!';
							PRINT 'Falta Agregar el Proveedor del Producto!';
						END
						ELSE
						BEGIN
							-- Color
							SELECT @id_color = id_color
							FROM color
							WHERE descripcion_color = @color;
							-- Material
							SELECT @id_material = id_material
							FROM material
							WHERE descripcion_material = @material;
							-- Proveedor
							SELECT @id_proveedor = id_proveedor
							FROM proveedor
							WHERE nombre_proveedor = @proveedor;

							IF EXISTS (SELECT * FROM producto WHERE descripcion_producto = @descripcion AND precio_producto = @precio)
							BEGIN
								SET @respuesta = 'El Producto Ya existe!';
								PRINT 'El Producto Ya existe!';
							END
							ELSE
							BEGIN
								INSERT INTO producto(descripcion_producto, precio_producto, almacen_producto, num_color, num_material, num_proveedor)
								VALUES(@descripcion, @precio, @cantidad, @id_color, @id_material, @id_proveedor);

								-- SET @nuevo_producto = SCOPE_IDENTITY();
								SET @nuevo_producto = @@IDENTITY;
								SELECT @respuesta = CONCAT('Producto Registrado con Exito, su id es: ', @nuevo_producto);
								PRINT 'Producto Registrado con Exito, su id es: ' + CONVERT(VARCHAR, @nuevo_producto) + '.';
							END -- if (Existe)

						END -- if (Proveedor)
					END -- if (Material)
				END -- if (Color)
			END -- if (Cantidad)
		END -- if (Precio)
	END -- if (Descripcion)
END -- Cierrre del Procedimiento Almacenado

-- Se ejecuta el Pocedimiento Almacenado
-- EXECUTE Alta_Producto 'Bolso de Mano Rubino', 999.00, 7, 'Rosa', 'Sintetico', 'Zara', '';
GO

-------------------- Alta Detalle de Venta --------------------

CREATE PROCEDURE Alta_Detalle_Venta
(
	@venta INT,
	@producto VARCHAR(200),
	@cantidad INT,
	@precio FLOAT,	
	@respuesta VARCHAR(100) OUTPUT
)
AS
BEGIN
	-- Variables
	DECLARE @id_producto INT;
	DECLARE @nuevo_detalle INT;
	DECLARE @subtotal FLOAT;
	DECLARE @existencia_almacenados INT;
	-- Validaciones
	IF (@venta = 0)
	BEGIN
		SET @respuesta = 'Falta Agregar el Id de la Venta!';
		PRINT 'Falta Agregar el Id de la Venta!';
	END
	ELSE
	BEGIN
		IF (@producto = '')
		BEGIN
			SET @respuesta = 'Falta Agregar el Producto!';
			PRINT 'Falta Agregar el Producto!';
		END
		ELSE
		BEGIN
			IF (@cantidad = 0)
			BEGIN
				SET @respuesta = 'Falta Agregar la Cantidad!';
				PRINT 'Falta Agregar la Cantidad!';
			END
			ELSE
			BEGIN
				IF (@precio = 0)
				BEGIN
					SET @respuesta = 'Falta Agregar el Precio del Producto!';
					PRINT 'Falta Agregar el Precio del Producto!';
				END
				ELSE
				BEGIN
					-- Producto
					SELECT @id_producto = id_producto
					FROM producto
					WHERE descripcion_producto = @producto;
					-- Almacen Producto
					SELECT @existencia_almacenados = almacen_producto 
					FROM producto 
					WHERE id_producto = @id_producto;

					IF EXISTS (SELECT * FROM detalle_venta WHERE num_venta = @venta AND num_producto = @id_producto)
					BEGIN
						SET @respuesta = 'El Detalle de Venta, Ya Existe!';
						PRINT 'El Detalle de Venta, Ya Existe!';
					END
					ELSE
					BEGIN

						IF (@existencia_almacenados >= @cantidad)
						BEGIN
							-- Calcula el Subtotal
							SET @subtotal = @cantidad * @precio;
							-- Realiza la Insercion
							INSERT INTO detalle_venta(num_venta, num_producto, cantidad_detalle_venta, precio_detalle_venta, subtotal_detalle_venta) 
							VALUES(@venta, @id_producto, @cantidad, @precio, @subtotal);
							-- Muestra el Mensaje
							SET @nuevo_detalle = @@IDENTITY;
							SELECT @respuesta = CONCAT('Venta Registrada con Exito, su id es: ', @venta);
							PRINT 'Venta Registrada con Exito, su id es: ' + CONVERT(VARCHAR, @venta) + '.';

							-- Actualiza la Cantidad de Productos
							UPDATE producto 
							SET almacen_producto = (@existencia_almacenados - @cantidad) 
							WHERE id_producto = @id_producto;
							-- Muestra el Mensaje
							PRINT 'Se Actualizo la Cantidad de Productos, Existencia: ' + CONVERT(VARCHAR, @existencia_almacenados) + ', Venta: ' + CONVERT(VARCHAR, @cantidad) + ', Nuevo en Almacen: ' + CONVERT(VARCHAR, (@existencia_almacenados - @cantidad));
						END
						ELSE
						BEGIN
							SET @respuesta = 'La Venta No se puede Realizar, No hay Suficientes Productos!';
							PRINT 'La Venta No se puede Realizar, No hay Suficientes Productos!';
						END
												
					END -- if (Existe)

				END -- if (Precio)
			END -- if (Cantidad)
		END -- if (Producto)
	END -- if (Venta)
END

-- Se ejecuta el Pocedimiento Almacenado
-- EXECUTE Alta_Detalle_Venta 2, 'Bolso con Asas Cinthya', 2, 877.00, '';
GO

/* °°°°°°°°°°°°°°° Metodos DELETE °°°°°°°°°°°°°°° */

-------------------- Eliminar Proveedor --------------------

CREATE PROCEDURE Eliminar_Proveedor
(
	@id_proveedor INT,
	@respuesta VARCHAR(100) OUTPUT
)
AS
BEGIN
	-- Variables
	DECLARE @nombre_proveedor VARCHAR(50);
	-- Validaciones
	IF (@id_proveedor = 0)
	BEGIN
		SET @respuesta = 'Falta Agregar el Id del Proveedor!';
		PRINT 'Falta Agregar el Id del Proveedor!';
	END
	ELSE
	BEGIN

		IF EXISTS (SELECT * FROM proveedor WHERE id_proveedor = @id_proveedor)
		BEGIN

			BEGIN TRY
				-- Producto
				SELECT @nombre_proveedor = nombre_proveedor
				FROM proveedor
				WHERE id_proveedor = @id_proveedor;
				-- Se Elimina el Registro
				DELETE FROM proveedor WHERE id_proveedor = @id_proveedor;
				-- Muestra un Mensaje
				SELECT @respuesta = CONCAT('Proveedor Eliminado: ', @nombre_proveedor, '.');
				PRINT 'Proveedor Eliminado: ' + CONVERT(VARCHAR, @nombre_proveedor) + '.';
			END TRY
			BEGIN CATCH
				-- Almacena el Mensaje de Error
				SELECT @respuesta = CONCAT('Error al Eliminar el Proveedor ', @nombre_proveedor, ': ',
				-- ERROR_NUMBER(), -- Numero de Error
				-- ERROR_SEVERITY(), -- Severidad del Error
				-- ERROR_STATE(), -- Estado del Error
				-- ERROR_PROCEDURE(), -- Procedimiento del Error
				-- ERROR_LINE(), -- Linea del Error
				ERROR_MESSAGE()); -- Mensaje del Error

				-- Muestra un Mensaje
				PRINT @respuesta;
			END CATCH
		END
		ELSE
		BEGIN
			SELECT @respuesta = 'El Proveedor No Existe!';
			PRINT 'El Proveedor No Existe!';
		END -- if (Existe)

	END -- if (RFC)
END

-- Se ejecuta el Pocedimiento Almacenado
-- EXECUTE Eliminar_Proveedor 1, '';
GO

/* ******************** Triggers ******************** */

-------------------- Actualiza Almacen --------------------
CREATE TRIGGER Actualiza_Cantidad_Productos
ON detalle_venta -- Se activa con la Tabla Venta
FOR INSERT -- Se activa cuando se inserta una nueva venta, pero puede ser INSERT, UPDATE o DELETE
AS
BEGIN
	-- Variables
	DECLARE
	@id_producto INT,
	@cantidad_producto INT,
	@existencia_almacenados INT;
	-- Obtiene los Valores
	SELECT @id_producto = INSERTED.num_producto FROM INSERTED;
	SELECT @cantidad_producto = INSERTED.cantidad_detalle_venta FROM INSERTED;
	SELECT @existencia_almacenados = almacen_producto FROM producto WHERE id_producto = @id_producto;
	-- Verifica la Cantidad de Productos
	IF (@existencia_almacenados < @cantidad_producto)
	BEGIN
		PRINT 'La Venta No se puede Realizar, No hay Suficientes Productos!'
		ROLLBACK TRANSACTION; -- No permite Continuar con la Accion
	END
	ELSE
	BEGIN		
		-- Actualiza la Cantidad de Productos
		UPDATE producto SET almacen_producto = (@existencia_almacenados - @cantidad_producto) WHERE id_producto = @id_producto;
		PRINT 'Se Actualizo la Cantidad de Productos, Existencia: ' + CONVERT(VARCHAR, @existencia_almacenados) + ', Venta: ' + CONVERT(VARCHAR, @cantidad_producto)
		+ ', Nuevo en Almacen: ' + CONVERT(VARCHAR, (@existencia_almacenados - @cantidad_producto));
		COMMIT TRANSACTION; -- Autoriza la Accion
	END
END -- Trigger*/
/*
-- Se Comprueba que el Trigger se Dispara al Momento de Insertar una Venta
INSERT INTO detalle_venta(num_venta, num_producto, cantidad_detalle_venta, precio_detalle_venta, subtotal_detalle_venta) 
VALUES(3, 3, 2, 877.00, 1754);

SELECT * FROM detalle_venta;
SELECT * FROM producto;
*/
