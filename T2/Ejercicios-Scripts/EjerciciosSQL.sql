/*Ejercicio 4.1
Ejercicio 1: Identificar el tipo de sentencia
Clasifica las siguientes sentencias segun su tipo (DDL, DML, DCL, TCL):

CREATE TABLE clientes (id INT, nombre VARCHAR(50));

INSERT INTO clientes VALUES (1, 'Juan');

GRANT SELECT ON clientes TO usuario1;

COMMIT;

UPDATE clientes SET nombre = 'Pedro' WHERE id = 1;

DDL: CREATE TABLE clientes  (id INT, nombre VARCHAR(50));

DML:INSERT INTO clientes VALUES (1, 'Juan');||UPDATE clientes SET nombre = 'Pedro' WHERE id = 1;

DCL:GRANT SELECT ON clientes TO usuario1;

TCL:COMMIT;
*/


/*EJERCICIOS 4.2
Ejercicio 1: Insertar empleados
Inserta 3 empleados nuevos en la tabla empleados.*/
INSERT INTO empleados(nombre, apellido, email, salario,departamento_id) VALUES ('Sebastian', 'Buneo', 'sbr@gmail.com', 38000, 1),('Abril','Fernandez', 'afr@gmail.com', 30000, 1), ('Fernanda','Bueno', 'mfer@gmail.com', 50000, 2) ;

/*Ejercicio 2: Aumentar salarios
Aumenta un 5% el salario de todos los empleados del departamento 2.*/

UPDATE empleados SET salario=salario*1.05 WHERE departamento_id=2;

/*Ejercicio 3: Eliminar registros
Elimina los empleados que tengan un salario menor a 25000.*/
DELETE FROM empleados WHERE salario<25000;

/*Ejercicios 4.3
Ejercicio 1: Crear tabla de backup
Crea una tabla empleados_backup con todos los empleados del departamento 1.*/
CREATE TABLE empleados_backup AS 
SELECT * FROM empleados WHERE departamento_id=2;

/*Ejercicio 2: Insertar resumen
Inserta en una tabla resumen_departamentos el total de empleados y salario medio por departamento.*/
CREATE TABLE resumen_departamentos AS 
SELECT departamento_id,COUNT(id)  AS totaleEmpleados ,AVG(salario) AS SalarioMedio FROM empleados GROUP BY departamento_id;

SELECT * FROM resumen_departamentos;
DROP TABLE resumen_departamentos;

/*Ejercicio 3: Migrar datos con transformacion
Crea una tabla empleados_exportar con nombre completo en mayusculas y salario anual.*/

CREATE TABLE empleados_exportar AS 
SELECT nombre || ' ' || apellido AS nombre_completo, salario * 12 AS salario_anual 
FROM empleados;

