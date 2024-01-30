-- ====================================================================================================
-- Cte
-- ====================================================================================================
WITH Cte AS
(
	SELECT 'Cfdi' AS Nombre
	UNION
	SELECT 'Constancias' AS Nombre
)
SELECT *, ROW_NUMBER() OVER (ORDER BY Nombre) AS NoLinea
FROM Cte
WHERE Nombre = 'Cfdi';
-- ====================================================================================================
-- Tabla Temporal
-- ====================================================================================================
-- Uso No 1
CREATE TABLE #TablaTemporal
(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(10) NULL,
	NoFila INT DEFAULT 0
);
GO
-- Insert
INSERT INTO #TablaTemporal (Nombre, NoFila)
VALUES
	('Uno', 1),
	('Dos', 2),
	('Tres', 3);
GO
-- Consulta Tabla Temporal
SELECT * FROM #TablaTemporal;
GO
-- Elimina Tabla Temporal
DROP TABLE #TablaTemporal;
-- ====================================================================================================
-- Uso No 2
-- Insert
SELECT 'Gabriel' AS Nombre, 'Martinez' AS Paterno, 'Flores' AS Materno, 29 AS Edad, 1 AS Estado INTO #TablaTemporal;
GO
-- Consulta Tabla Temporal
SELECT * FROM #TablaTemporal;
GO
-- Elimina Tabla Temporal
DROP TABLE #TablaTemporal;
-- ====================================================================================================
-- Variable Tipo Tabla
-- ====================================================================================================
-- Crea la Variable
DECLARE @VariableTabla AS TABLE 
(
	Id INT IDENTITY(1, 1) NOT NULL,
	Nombre VARCHAR(10) NULL,
	NoFila INT DEFAULT 0
);
-- Insert
 INSERT INTO @VariableTabla
 VALUES
	('Uno', 1),
	('Dos', 2),
	('Tres', 3);
-- Consulta la Variable	
SELECT * FROM @VariableTabla;