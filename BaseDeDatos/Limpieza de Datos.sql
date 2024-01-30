DECLARE @Cadena VARCHAR(200) = 'JOS    6MaR    2A   12  LAFRAGuua';
SELECT @Cadena AS Antes;

-- Elimina Espacio de más
SET @Cadena = TRIM(REPLACE(REPLACE(REPLACE(@Cadena, ' ', '<>'), '><', ''), '<>', ' '));

SELECT @Cadena AS Despues;

-- Elimina Numeros
DECLARE @NumberPattern VARCHAR(10) = '%[0-9]%';

WHILE PATINDEX(@NumberPattern, @Cadena) > 0
BEGIN
	SET @Cadena = STUFF(@Cadena, PATINDEX(@NumberPattern, @Cadena), 1, '');
END
SELECT @Cadena AS DespuesNumeros;

-- Mayusculas
SET @Cadena = UPPER(@Cadena);
SELECT @Cadena AS DespuesMayusculas;