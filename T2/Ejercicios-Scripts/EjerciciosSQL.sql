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

/*4.4
Ejercicio 1: Crear script de inicializacion
Crea un script que cree una tabla productos con campos id, nombre, precio y stock.*/

BEGIN;

CREATE TABLE IF NOT EXISTS productos2(
id SERIAL PRIMARY KEY,
nombre VARCHAR(80),
precio DECIMAL (10,2) CHECK (precio>=0),
stock INTEGER DEFAULT 0 CHECK (stock>=0)
);
COMMIT;

/*Ejercicio 2: Script con variables
Crea un script que actualice el stock de un producto usando una variable.*/
BEGIN;
DO $$
DECLARE 
v_idProducto INTEGER := 1;
v_stock INTEGER := 25;

BEGIN
UPDATE productos 
SET stock=v_stock
WHERE id=v_idProducto;

RAISE NOTICE 'Se ha actualizado el stock del producto con id % a % ',v_idProducto,v_stock;
END $$;
COMMIT;

/*4.5
Ejercicio 1: Transaccion basica
Crea una transaccion que inserte un departamento y dos empleados en ese departamento.*/

BEGIN;
INSERT INTO departamentos(nombre, ubicacion) VALUES ('IT', 'Nose')
RETURNING id;

INSERT INTO empleados (nombre,apellido,email,salario,departamento_id) 
VALUES ('yo','yo','yo@yo.yo',50000,5),('tu','to','to@o.yo',50000,5)
RETURNING *;

COMMIT;

/*Ejercicio 2: Identificar ACID
Indica que propiedad ACID se aplica en cada caso:

Si la luz se va durante una transaccion, los cambios no confirmados se pierden.  ATOMICITY(atomicidad)

Una transferencia resta de una cuenta y suma a otra, o no hace nada. CONSISTENCY(consistencia)

Dos usuarios modificando la misma tabla no ven los cambios del otro hasta confirmar.  ISOLATION(aislamiento)

Una vez confirmado el COMMIT, los datos permanecen aunque reinicies el servidor. DURABILITY(durabilidad)*/

----------------------------------------------------------------------------------------------------------------
/*4.6
Ejercicio 1: Usar SAVEPOINT
Crea una transaccion que inserte 3 registros con savepoints entre cada uno. Luego deshaz solo el ultimo.*/
BEGIN; 
INSERT INTO categorias (nombre,descripcion) VALUES ('Nueva Categoria 1', 'Descripcion 1');
SAVEPOINT sp1;

INSERT INTO categorias (nombre,descripcion) VALUES ('Nueva Categoria 2', 'Descripcion 1');
SAVEPOINT sp2;

INSERT INTO categorias (nombre,descripcion) VALUES ('Nueva Categoria 3', 'Descripcion 3');
SAVEPOINT sp3;

ROLLBACK TO sp2;
COMMIT;

/*Ejercicio 2: Manejo de errores
Escribe un bloque que intente insertar un registro, y si falla, inserte un registro alternativo.*/

DO $$
BEGIN
	INSERT INTO cuentas(titular,saldo,tipo) VALUES ('Sebas', '158a', 'nose');

	EXCEPTION WHEN OTHERS THEN 	
		RAISE NOTICE 'Operacion fallida, creado cuenta temporal con datos predeterminados. Configurar antes de seguir';
		INSERT INTO cuentas(titular,saldo,tipo) VALUES ('default',1, 'corriente');
COMMIT;
END $$;



