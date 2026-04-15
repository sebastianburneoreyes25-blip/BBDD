RESUMEN 

Funciones estándar

A mayúscula 

SELECT UCASE(dato)

A minúscula

SELECT LCASE(dato)ç

Número de caracteres

LENGTH

CONCAT 

CONCAT\_WS(con separador)

Busca la posición donde se encuentra algo

SELECT nombre, INSTR(NOMBRE,’ALGO’) a buscar algo FROM tabla

Extra 3 caracteres de la izq 

SELECT NOMBRE , LEFT(NOMBRE,3) AS ABREVIAR3 from tabla

SELECT NOMBRE , RIGHT(NOMBRE,3) AS ABREVIAR3 from tabla

SELECT NOMBRE , MID(NOMBRE,3) AS ABREVIAR3 from tabla

Substring

SELECT NOMBRE, SUBSTRING(NOMBRE, 5\) as substring

REPLACE

REVERSE (invierte caracteres)

SET @tecto=’teto’;

SELECT LTRIM(ESPACIOS DE LA IZQ)

SELECT RTRIM(DE LA DERECHA)

SELECT TRIM(TODOS)

ABS(absoluti)

FLOOR/elimina deciamles)

CEIL (redondea al alza)

ROUND (numerocondecimales, 2\) redondea con dos decimales

POW(potencia)

SQRT(raíz cuadrada)

CURDATE()

NOW()

LOCLATIME()

SYSDATE()

DATE()

DATE\_FORMAT()

SELECT DAY(NOW)—dia del mes

DAYNAME(NOW())—dia en texto

DAYOFWEEK(NOW())--dia en número

SELECT MONTH(NOW)—MES del mes

MONTHNAME(NOW())—Mes en texto

MONTHOFWEEK(NOW())--Mes en número

SELECT CURRENT USER

SELECT DATABASE()

SELECT ROW\_COUNT()—cuenta líneas en la base de datos

