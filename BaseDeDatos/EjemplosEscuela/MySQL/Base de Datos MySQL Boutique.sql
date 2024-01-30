-- Existe la Base de Datos
SELECT SCHEMA_NAME AS BaseDeDatos FROM INFORMATION_SCHEMA.SCHEMATA WHERE SCHEMA_NAME = 'boutique';

-- Pone en Uso la Base de Datos Principal
USE mysql;
-- Elimina la Base de Datos Si Existe
DROP DATABASE IF EXISTS boutique;
-- Se Crea la Base de Datos
CREATE DATABASE IF NOT EXISTS boutique;
-- Se pone en Uso la Base de Datos
USE boutique;

/* ******************** Se Crean las Tablas ******************** */

CREATE TABLE tipo_empleado
(
	id_tipo_empleado INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	descripcion_tipo_empleado VARCHAR(50) NOT NULL,
	UNIQUE (descripcion_tipo_empleado)
);

CREATE TABLE cliente
(
	id_cliente INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	nombre_cliente VARCHAR(50) NOT NULL,
	paterno_cliente VARCHAR(50) NOT NULL,
	materno_cliente VARCHAR(50) NOT NULL,
	rfc_cliente VARCHAR(50) DEFAULT NULL,
	celular_cliente VARCHAR(50) NOT NULL,
	domicilio_cliente VARCHAR(200) NOT NULL,
	UNIQUE (rfc_cliente)
);

CREATE TABLE empleado
(
	id_empleado INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	nombre_empleado VARCHAR(50) NOT NULL,
	paterno_empleado VARCHAR(50) NOT NULL,
	materno_empleado VARCHAR(50) NOT NULL,
	rfc_empleado VARCHAR(50) DEFAULT NULL,
	celular_empleado VARCHAR(50) NOT NULL,
	domicilio_empleado VARCHAR(200) NOT NULL,
	num_tipo_empleado INT NOT NULL,
	UNIQUE (rfc_empleado),
	FOREIGN KEY (num_tipo_empleado) REFERENCES tipo_empleado(id_tipo_empleado)
);

CREATE TABLE usuario
(
	id_usuario INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	nombre_usuario VARCHAR(50) NOT NULL,
	contrasena_usuario VARCHAR(50) NOT NULL,
	num_empleado INT NOT NULL,
	UNIQUE(nombre_usuario),
	FOREIGN KEY (num_empleado) REFERENCES empleado(id_empleado)
);

CREATE TABLE venta
(
	id_venta INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	fecha_venta DATE NOT NULL,
	total_venta FLOAT NOT NULL,
	num_empleado INT NOT NULL,
	num_cliente INT NOT NULL,	
	estatus_factura TINYINT NOT NULL, -- 1 = Si o 0 = No
	FOREIGN KEY (num_empleado) REFERENCES empleado(id_empleado),
	FOREIGN KEY (num_cliente) REFERENCES cliente(id_cliente)
);

CREATE TABLE factura
(
	id_factura INT AUTO_INCREMENT PRIMARY KEY NOT NULL,
	num_venta INT NOT NULL,
	fecha_factura DATE NOT NULL,
	total_factura FLOAT NOT NULL,	
	FOREIGN KEY (num_venta) REFERENCES venta(id_venta)
);

CREATE TABLE auditoria_usuarios
(
	operacion VARCHAR(50),
	usuario VARCHAR(50),
	fecha DATETIME,
	NEW_id_empleado INT DEFAULT NULL,
    NEW_nombre VARCHAR(50) DEFAULT '-------------',
    NEW_contraseña VARCHAR(50) DEFAULT '-------------',
	OLD_id_empleado INT DEFAULT NULL,
    OLD_nombre VARCHAR(50) DEFAULT '-------------',
    OLD_contraseña VARCHAR(50) DEFAULT '-------------'
);

/* ******************** Se Insertan Datos en las Tablas ******************** */

-- Tipo Empleado
INSERT INTO tipo_empleado(descripcion_tipo_empleado) VALUES('Cajero');
INSERT INTO tipo_empleado(descripcion_tipo_empleado) VALUES('Administrador');

-- Cliente
INSERT INTO cliente(nombre_cliente, paterno_cliente, materno_cliente, rfc_cliente, celular_cliente, domicilio_cliente) 
VALUES('Mario', 'Salas', 'Cardenas', 'SACA02', '5589487544', 'Zoquipa, Hidalgo');
INSERT INTO cliente(nombre_cliente, paterno_cliente, materno_cliente, rfc_cliente, celular_cliente, domicilio_cliente) 
VALUES('Marco Antonio', 'Tellez', 'Salinas', 'TEAR03', '5553478904', 'Seccion 33, Ecatepec de Morelos');
INSERT INTO cliente(nombre_cliente, paterno_cliente, materno_cliente, rfc_cliente, celular_cliente, domicilio_cliente) 
VALUES('Belen', 'Campos', 'Tiburcio', 'CATB03', '5533671234', 'Poligonos, Ecatepec de Morelos');
INSERT INTO cliente(nombre_cliente, paterno_cliente, materno_cliente, rfc_cliente, celular_cliente, domicilio_cliente) 
VALUES('Eduardo', 'Fabian', 'Herrera','FA34J6','5543478090','Ecatepec de Morelos, Estado de Mexico');
INSERT INTO cliente(nombre_cliente, paterno_cliente, materno_cliente, rfc_cliente, celular_cliente, domicilio_cliente) 
VALUES('Arnulfo', 'Enriquez', 'Meza','ARF5540','55409831','Ecatepec de Morelos, Estado de Mexico');

-- Empleado
INSERT INTO empleado(nombre_empleado, paterno_empleado, materno_empleado, rfc_empleado, celular_empleado, domicilio_empleado, num_tipo_empleado) 
VALUES('Nancy', 'Gamiño', 'Hernandez', 'GAHN01', '5547489966', 'Ecatepec de Morelos, Estado de Mexico', 2);
INSERT INTO empleado(nombre_empleado, paterno_empleado, materno_empleado, rfc_empleado, celular_empleado, domicilio_empleado, num_tipo_empleado) 
VALUES('Gabriel', 'Martinez', 'Flores', 'MART02', '5555345768', 'Moctezuma, Cuidad de Mexico', 2);
INSERT INTO empleado(nombre_empleado, paterno_empleado, materno_empleado, rfc_empleado, celular_empleado, domicilio_empleado, num_tipo_empleado) 
VALUES('Alberto Ivan', 'Romero', 'Barrera', 'ROBA04', '5587123108', 'San Agustin, Ecatepec de Morelos', 1);
INSERT INTO empleado(nombre_empleado, paterno_empleado, materno_empleado, rfc_empleado, celular_empleado, domicilio_empleado, num_tipo_empleado) 
VALUES('Beatriz', 'Lopez', 'Ortega', 'BELA01', '5566238916', 'Jardines de Morelos, Ecatepec de Morelos', 1);
INSERT INTO empleado(nombre_empleado, paterno_empleado, materno_empleado, rfc_empleado, celular_empleado, domicilio_empleado, num_tipo_empleado) 
VALUES('Fabiola', 'Ramirez', 'Sanchez', 'RAHF04', '5508512345', 'Ecatepec de Morelos, Estado de Mexico', 1);

-- Usuario
INSERT INTO usuario(nombre_usuario, contrasena_usuario, num_empleado) VALUES('nancy', 'nancy01', 1);
INSERT INTO usuario(nombre_usuario, contrasena_usuario, num_empleado) VALUES('gabo', 'gabo01', 2);
INSERT INTO usuario(nombre_usuario, contrasena_usuario, num_empleado) VALUES('alberto', 'alberto01', 3);
INSERT INTO usuario(nombre_usuario, contrasena_usuario, num_empleado) VALUES('beatriz', 'beatriz01', 4);
INSERT INTO usuario(nombre_usuario, contrasena_usuario, num_empleado) VALUES('fabiola', 'fabiola01', 5);

-- Venta
INSERT INTO venta(fecha_venta, total_venta, num_empleado, num_cliente, estatus_factura) 
VALUES('2017/07/02', 501.97, 2, 3, 0);
INSERT INTO venta(fecha_venta, total_venta, num_empleado, num_cliente, estatus_factura) 
VALUES('2019/03/28', 15954, 5, 2, 1);

-- Factura
INSERT INTO factura(num_venta, fecha_factura, total_factura) VALUES(2, '2019/03/28', 15954);

/* ******************** Consultas ******************** */

-- SELECT * FROM tipo_empleado;
-- SELECT * FROM cliente;
-- SELECT * FROM empleado;
-- SELECT * FROM usuario;
-- SELECT * FROM venta;
-- SELECT * FROM factura;

/* ******************** Vistas ******************** */

-- 1) Datos del Cliente
CREATE VIEW V_Clientes
AS
SELECT id_cliente AS Id_Cliente, nombre_cliente AS Nombre, paterno_cliente AS Paterno, materno_cliente AS Materno, rfc_cliente AS RFC
FROM cliente;

-- Se ejecuta la Vista
-- SELECT * FROM V_Clientes WHERE Id_Cliente = 1;

/* ******************** Procedimientos Almacenados ******************** */

/* ------------------------ Validar Administrador ------------------------ */
DELIMITER $

CREATE PROCEDURE Validar_Administrador
(
	IN usuario VARCHAR(50),
	IN contrasena VARCHAR(50),
	OUT respuesta VARCHAR(100)
)
BEGIN
	DECLARE no_empleado INT;
	DECLARE no_tipo_empleado INT;
	DECLARE tipo_e VARCHAR(50);

	IF (usuario = '') THEN
		SELECT 'Falta Agregar el Usuario!' INTO respuesta;
	ELSE
		IF (contrasena = '') THEN
			SELECT 'Falta Agregar la Contraseña!' INTO respuesta;
		ELSE
			
			IF EXISTS(SELECT * FROM usuario WHERE nombre_usuario = usuario AND contrasena_usuario = contrasena) THEN
								
				SELECT num_empleado INTO no_empleado
				FROM usuario 
				WHERE nombre_usuario = usuario 
				AND contrasena_usuario = contrasena; -- id Empleado

				SELECT num_tipo_empleado INTO no_tipo_empleado
				FROM empleado 
				WHERE id_empleado = no_empleado; -- id Tipo de Empleado

				SELECT descripcion_tipo_empleado INTO tipo_e
				FROM tipo_empleado 
				WHERE id_tipo_empleado = no_tipo_empleado; -- Tipo de Empleado

				IF (tipo_e = 'Administrador') THEN
					SELECT 'Inicio de Sesion Correcto!' INTO respuesta;
				ELSE
					SELECT 'Tu Usuario No Tiene Privilegios de Administrador!' INTO respuesta;
				END IF; -- if (Administrador)				

			ELSE
				SELECT 'Usuario o Contraseña Incorrectos!' INTO respuesta;
			END IF; -- if (Existe)	

		END IF; -- if (Contrasena)
	END IF; -- if (Usuario)
END $
DELIMITER ;

-- Se manda a llamar el Procedimiento Almacenado
-- CALL Validar_Administrador('beatriz', 'beatriz01', @res);
-- SELECT @res AS Respuesta;

/* ------------------------ Iniciar Sesion ------------------------ */
DELIMITER $

CREATE PROCEDURE Iniciar_Sesion
(
	IN usuario VARCHAR(50),
	IN contrasena VARCHAR(50),
	OUT respuesta VARCHAR(100),
	OUT nombre_e VARCHAR(50),
	OUT paterno_e VARCHAR(50),
	OUT materno_e VARCHAR(50)
)
BEGIN
	DECLARE no_empleado INT;

	IF usuario = '' THEN
		SELECT 'Falta Agregar el Usuario!' INTO respuesta;
	ELSE
		IF contrasena = '' THEN
			SELECT 'Falta Agregar la Contraseña!' INTO respuesta;
		ELSE
			
			IF EXISTS(SELECT * FROM usuario WHERE nombre_usuario = usuario AND contrasena_usuario = contrasena) THEN
								
				SELECT num_empleado INTO no_empleado
				FROM usuario 
				WHERE nombre_usuario = usuario 
				AND contrasena_usuario = contrasena; -- id Empleado
				
				SELECT nombre_empleado INTO nombre_e
				FROM empleado 
				WHERE id_empleado = no_empleado; -- Nombre

				SELECT paterno_empleado INTO paterno_e
				FROM empleado 
				WHERE id_empleado = no_empleado; -- Paterno

				SELECT materno_empleado INTO materno_e
				FROM empleado 
				WHERE id_empleado = no_empleado; -- Materno

				SELECT 'Inicio de Sesion Correcto!' INTO respuesta;

			ELSE
				SELECT 'Usuario o Contraseña Incorrectos!' INTO respuesta;
			END IF; -- if (Existe)	

		END IF; -- if (Contrasena)
	END IF; -- if (Usuario)
END $
DELIMITER ;

-- Se manda a llamar el Procedimiento Almacenado
-- CALL Iniciar_Sesion('gabo', 'gabo01', @res, @nombre, @paterno, @materno);
-- SELECT @res AS Respuesta, @nombre AS Nombre, @paterno AS Paterno, @materno AS Materno;

/* >>>>>>>>>>>>>>> Metodos INSERT <<<<<<<<<<<<<<< */

/* ------------------------ Alta Empleado ------------------------ */
DELIMITER $ 

CREATE PROCEDURE Alta_Empleado
(
	IN nombre VARCHAR(50),
	IN paterno VARCHAR(50),
	IN materno VARCHAR(50),
	IN rfc VARCHAR(50),
	IN celular VARCHAR(50),
	IN domicilio VARCHAR(200),
	IN tipo_empleado VARCHAR(50),
	IN usuario VARCHAR(50),
	IN contrasena VARCHAR(50),
	OUT respuesta VARCHAR(100)
)
BEGIN
	DECLARE num_tipo_empleado INT;
	DECLARE num_empleado INT;

	IF nombre = '' THEN
		SELECT 'Falta Agregar el Nombre!' INTO respuesta;
	ELSE
		IF paterno = '' THEN
			SELECT 'Falta Agregar el Apellido Paterno!' INTO respuesta;
		ELSE
			IF materno = '' THEN
				SELECT 'Falta Agregar el Apellido Materno!' INTO respuesta;
			ELSE
				IF celular = '' THEN
					SELECT 'Falta Agregar el Telefono Movil!' INTO respuesta;
				ELSE
					IF domicilio = '' THEN
						SELECT 'Falta Agregar el Domicilio!' INTO respuesta;
					ELSE
						IF tipo_empleado = '' THEN
							SELECT 'Falta Agregar el Tipo de Empleado!' INTO respuesta;
						ELSE
							IF usuario = '' THEN
								SELECT 'Falta Agregar el Usuario!' INTO respuesta;
							ELSE
								IF contrasena = '' THEN
									SELECT 'Falta Agregar la Contraseña!' INTO respuesta;
								ELSE

									IF rfc = '' THEN
										SET rfc = NULL;
									END IF; -- if (RFC)

									SELECT id_tipo_empleado INTO num_tipo_empleado
									FROM tipo_empleado 
									WHERE descripcion_tipo_empleado = tipo_empleado;

									IF EXISTS(SELECT * FROM empleado WHERE nombre_empleado = nombre AND paterno_empleado = paterno AND materno_empleado = materno) THEN
										SELECT 'El Empleado Ya Existe!' INTO respuesta;
									ELSE
										INSERT INTO empleado(nombre_empleado, paterno_empleado, materno_empleado, rfc_empleado, celular_empleado, domicilio_empleado, num_tipo_empleado) 
										VALUES(nombre, paterno, materno, rfc, celular, domicilio, num_tipo_empleado);

										SET num_empleado = LAST_INSERT_ID();

										INSERT INTO usuario(nombre_usuario, contrasena_usuario, num_empleado) VALUES(usuario, contrasena, num_empleado);

										SELECT CONCAT('Empleado Registrado con Exito, su id es: ', num_empleado) INTO respuesta;
									END IF; -- if (Existe)									
					
								END IF; -- if (Contraseña)
							END IF; -- if (Usuario)
						END IF; -- if (Tipo de Empleado)
					END IF; -- if (Domicilio)
				END IF; -- if (Celular)
			END IF; -- if (Materno)	
		END IF; -- if (Paterno)
	END IF; -- if (Nombre)
END $
DELIMITER ;

-- Se manda a llamar el Procedimiento Almacenado
-- CALL Alta_Empleado('Alejandro','Jimenez','Chavez', '', '5574982341', 'Jardin Balbuena, Ciudad de Mexico', 'Cajero', 'alex', 'alex01', @res);
-- SELECT @res AS Respuesta;

/* ------------------------ Alta Cliente ------------------------ */
DELIMITER $ 

CREATE PROCEDURE Alta_Cliente
(
	IN nombre VARCHAR(50),
	IN paterno VARCHAR(50),
	IN materno VARCHAR(50),
	IN rfc VARCHAR(50),
	IN celular VARCHAR(50),
	IN domicilio VARCHAR(200),
	OUT respuesta VARCHAR(100)
)
BEGIN
	DECLARE num_cliente INT;

	IF nombre = '' THEN
		SELECT 'Falta Agregar el Nombre!' INTO respuesta;
	ELSE
		IF paterno = '' THEN
			SELECT 'Falta Agregar el Apellido Paterno!' INTO respuesta;
		ELSE
			IF materno = '' THEN
				SELECT 'Falta Agregar el Apellido Materno!' INTO respuesta;
			ELSE
				IF celular = '' THEN
					SELECT 'Falta Agregar el Telefono Movil!' INTO respuesta;
				ELSE
					IF domicilio = '' THEN
						SELECT 'Falta Agregar el Domicilio!' INTO respuesta;
					ELSE

						IF rfc = '' THEN
							SET rfc = NULL;
						END IF; -- if (RFC)

						IF EXISTS(SELECT * FROM cliente WHERE nombre_cliente = nombre AND paterno_cliente = paterno AND materno_cliente = materno) THEN
							SELECT 'El Cliente Ya Existe!' INTO respuesta;
						ELSE
							INSERT INTO cliente(nombre_cliente, paterno_cliente, materno_cliente, rfc_cliente, celular_cliente, domicilio_cliente) 
							VALUES(nombre, paterno, materno, rfc, celular, domicilio);

							SET num_cliente = LAST_INSERT_ID();

							SELECT CONCAT('Cliente Registrado con Exito, su id es: ', num_cliente) INTO respuesta;
						END IF; -- if (Existe)	

					END IF; -- if (Domicilio)
				END IF; -- if (Celular)
			END IF; -- if (Materno)	
		END IF; -- if (Paterno)
	END IF; -- if (Nombre)
END $
DELIMITER ;

-- Se manda a llamar el Procedimiento Almacenado
-- CALL Alta_Cliente('Adrian','Trejo','Rocha', 'RAR234', '5509125432', 'Jardines de Morelos, Estado de Mexico', @res);
-- SELECT @res AS Respuesta;

/* ------------------------ Alta Venta ------------------------ */
DELIMITER $

CREATE PROCEDURE Alta_Venta
(
	IN total FLOAT,
	IN nombre_e VARCHAR(50),
	IN paterno_e VARCHAR(50),
	IN materno_e VARCHAR(50),
	IN nombre_c VARCHAR(50),
	IN paterno_c VARCHAR(50),
	IN materno_c VARCHAR(50),
	IN estado_factura VARCHAR(50),
	OUT respuesta INT
)
BEGIN
	DECLARE no_cliente INT;
	DECLARE num_empleado INT;
	DECLARE factura INT;
	DECLARE fecha DATE;

	SELECT CURDATE() INTO fecha;

	IF total = 0 THEN
		SELECT -1 INTO respuesta;
	ELSE
		IF nombre_e = '' THEN
			SELECT -2 INTO respuesta;
		ELSE
			IF paterno_e = '' THEN
				SELECT -3 INTO respuesta;
			ELSE
				IF materno_e = '' THEN
					SELECT -4 INTO respuesta;
				ELSE					
					IF nombre_c = '' THEN
						SELECT -5 INTO respuesta;
					ELSE					
						IF paterno_c = '' THEN
							SELECT -6 INTO respuesta;
						ELSE					
							IF materno_c = '' THEN
								SELECT -7 INTO respuesta;
							ELSE
								IF estado_factura = '' THEN
									SELECT -8 INTO respuesta;
								ELSE

									SELECT id_cliente INTO no_cliente
									FROM cliente 
									WHERE nombre_cliente = nombre_c
									AND paterno_cliente = paterno_c
									AND materno_cliente = materno_c;

									SELECT id_empleado INTO num_empleado
									FROM empleado 
									WHERE nombre_empleado = nombre_e
									AND paterno_empleado = paterno_e
									AND materno_empleado = materno_e;

									IF estado_factura = 'Si' THEN
										SET factura = 1;
									ELSE
										SET factura = 0;
									END IF; -- if (Factura)
									
									IF EXISTS(SELECT * FROM venta WHERE fecha_venta = fecha AND total_venta = total AND num_cliente = no_cliente) THEN
										SELECT -9 INTO respuesta;
									ELSE
										INSERT INTO venta(fecha_venta, total_venta, num_empleado, num_cliente, estatus_factura) 
										VALUES(fecha, total, num_empleado, no_cliente, factura);

										SET respuesta = LAST_INSERT_ID();
									END IF; -- if (Existe)								

								END IF; -- if (Factura)		
							END IF; -- if (Materno Cliente)
						END IF; -- if (Paterno Cliente)
					END IF; -- if (Nombre Cliente)
				END IF; -- if (Materno Empleado)
			END IF; -- if (Paterno Empleado)	
		END IF; -- if (Nombre Empleado)
	END IF; -- if (Total)
END $
DELIMITER ;

-- Se manda a llamar el Procedimiento Almacenado
-- CALL Alta_Venta(1200, 'Beatriz', 'Lopez', 'Ortega', 'Eduardo', 'Fabian', 'Herrera', 'Si', @res);
-- SELECT @res AS Respuesta;

/* ------------------------ Alta Factura ------------------------ */
DELIMITER $

CREATE PROCEDURE Alta_Factura
(
	IN venta INT,
	IN total FLOAT,
	OUT respuesta VARCHAR(100)
)
BEGIN
	DECLARE num_factura INT;
	DECLARE fecha DATE;

	SELECT CURDATE() INTO fecha;

	IF venta = 0 THEN
		SELECT 'Falta Agregar el id de la Venta!' INTO respuesta;
	ELSE
		IF total = 0 THEN
			SELECT 'Falta Agregar el Total!' INTO respuesta;
		ELSE
			
			IF EXISTS(SELECT * FROM factura WHERE num_venta = venta AND fecha_factura = fecha) THEN
				SELECT 'La Factura, Ya Existe!' INTO respuesta;
			ELSE
				INSERT INTO factura(num_venta, fecha_factura, total_factura) 
				VALUES(venta, fecha, total);

				SET num_factura = LAST_INSERT_ID();

				SELECT CONCAT('Factura Registrada con Exito, su id es: ', num_factura) INTO respuesta;
			END IF; -- if (Existe)	

		END IF; -- if (Total)
	END IF; -- if (Venta)
END $
DELIMITER ;

-- Se manda a llamar el Procedimiento Almacenado
-- CALL Alta_Factura(3, 1200, @res);
-- SELECT @res AS Respuesta;

/* >>>>>>>>>>>>>>> Metodos DELETE <<<<<<<<<<<<<<< */

/* ------------------------ Eliminar Cliente ------------------------ */
DELIMITER $

CREATE PROCEDURE Eliminar_Cliente
(
	IN num_cliente INT,
	OUT respuesta VARCHAR(100)
)
BEGIN
	DECLARE nombre VARCHAR(50);
	DECLARE paterno VARCHAR(50);
	DECLARE materno VARCHAR(50);

	IF num_cliente = 0 THEN
		SELECT 'Falta Agregar el id del Cliente!' INTO respuesta;
	ELSE
					
		IF EXISTS(SELECT * FROM cliente WHERE id_cliente = num_cliente) THEN
			
			SELECT nombre_cliente INTO nombre
			FROM cliente 
			WHERE id_cliente = num_cliente;

			SELECT paterno_cliente INTO paterno
			FROM cliente 
			WHERE id_cliente = num_cliente;

			SELECT materno_cliente INTO materno
			FROM cliente 
			WHERE id_cliente = num_cliente;

			DELETE FROM cliente WHERE id_cliente = num_cliente;
			
			SELECT CONCAT('Cliente: ', nombre, ' ', paterno, ' ', materno, ', Eliminado!') INTO respuesta;
		ELSE
			SELECT 'El Cliente No Existe!' INTO respuesta;
		END IF; -- if (Existe)	

	END IF; -- if (Cliente)
END $
DELIMITER ;

-- Se manda a llamar el Procedimiento Almacenado
-- CALL Eliminar_Cliente(5, @res);
-- SELECT @res AS Respuesta;
-- DROP PROCEDURE IF EXISTS Eliminar_Usuario;
/* ------------------------ Eliminar Usuario ------------------------ */
DELIMITER $

CREATE PROCEDURE Eliminar_Usuario
(
	IN numero_empleado INT,
	OUT respuesta VARCHAR(100)
)
BEGIN
	DECLARE nombre VARCHAR(50);
	DECLARE paterno VARCHAR(50);
	DECLARE materno VARCHAR(50);

	IF numero_empleado = 0 THEN
		SELECT 'Falta Agregar el id del Usuario!' INTO respuesta;
	ELSE
					
		IF EXISTS(SELECT * FROM empleado WHERE id_empleado = numero_empleado) THEN
			
			SELECT nombre_empleado INTO nombre
			FROM empleado 
			WHERE id_empleado = numero_empleado;

			SELECT paterno_empleado INTO paterno
			FROM empleado 
			WHERE id_empleado = numero_empleado;

			SELECT materno_empleado INTO materno
			FROM empleado 
			WHERE id_empleado = numero_empleado;

			DELETE FROM usuario WHERE num_empleado = numero_empleado;
			
			SELECT CONCAT('Usuario del Usuario: ', nombre, ' ', paterno, ' ', materno, ', Eliminado!') INTO respuesta;
		ELSE
			SELECT 'El Usuario No Existe!' INTO respuesta;
		END IF; -- if (Existe)	

	END IF; -- if (Empleado)
END $
DELIMITER ;

-- Se manda a llamar el Procedimiento Almacenado
-- CALL Eliminar_Usuario(7, @res);
-- SELECT @res AS Respuesta;

/* ******************** Triggers ******************** */

/* >>>>>>>>>>>>>>> Triggers Auditoria <<<<<<<<<<<<<<< */

-- Obtiene el usuario
-- SELECT CURRENT_USER();

/* ------------------------ Usuario INSERT ------------------------ */	
DELIMITER $

CREATE TRIGGER Insertar_Usuario
AFTER INSERT ON usuario
FOR EACH ROW
BEGIN
	INSERT INTO auditoria_usuarios(operacion, usuario, fecha, NEW_id_empleado, NEW_nombre, NEW_contraseña)
	VALUES ('INSERT', CURRENT_USER(), NOW(), NEW.num_empleado, NEW.nombre_usuario, NEW.contrasena_usuario);
END $
DELIMITER ;

-- Se Comprueba el Funcionamiento del Trigger
-- INSERT INTO usuario(nombre_usuario, contrasena_usuario, num_empleado) VALUES('adrian', 'adrian01', 2);
-- SELECT * FROM usuario;
-- SELECT * FROM auditoria_usuarios;

/* ------------------------ Usuario DELETE ------------------------ */
DELIMITER $

CREATE TRIGGER Eliminar_Usuario
AFTER DELETE ON usuario
FOR EACH ROW
BEGIN
	INSERT INTO auditoria_usuarios(operacion, usuario, fecha, OLD_id_empleado, OLD_nombre, OLD_contraseña)
	VALUES ('DELETE', CURRENT_USER(), NOW(), OLD.num_empleado, OLD.nombre_usuario, OLD.contrasena_usuario);
END $
DELIMITER ;

-- Se Comprueba el Funcionamiento del Trigger
-- DELETE FROM usuario WHERE id_usuario = 2;
-- SELECT * FROM usuario;
-- SELECT * FROM auditoria_usuarios;

/* ------------------------ Usuario UPDATE ------------------------ */
DELIMITER $

CREATE TRIGGER Actualizar_Usuario
AFTER UPDATE ON usuario
FOR EACH ROW
BEGIN
	INSERT INTO auditoria_usuarios(operacion, usuario, fecha, 
	NEW_id_empleado, NEW_nombre, NEW_contraseña,
	OLD_id_empleado, OLD_nombre, OLD_contraseña)
	VALUES ('UPDATE', CURRENT_USER(), NOW(), 
	NEW.num_empleado, NEW.nombre_usuario, NEW.contrasena_usuario,
	OLD.num_empleado, OLD.nombre_usuario, OLD.contrasena_usuario);
END $
DELIMITER ;

-- Se Comprueba el Funcionamiento del Trigger
-- UPDATE usuario SET nombre_usuario ='erick', contrasena_usuario = 'erick01' WHERE id_usuario = 3;
-- SELECT * FROM usuario;
-- SELECT * FROM auditoria_usuarios;
