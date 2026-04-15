SHOW CON_NAME;

SELECT PDB_NAME FROM DBA_PDBS;

ALTER SESSION SET CONTAINER= XEPDB1;

ALTER SESSION SET CONTAINER= CDB$ROOT;

SHOW PDBS;

SELECT name, cdb FROM v$database;

/*Conectarme a la cdb como sysdba*/
CREATE PLUGGABLE DATABASE pdb_alumnos
    ADMIN USER admin_alumnos IDENTIFIED BY Oracle123
    STORAGE UNLIMITED
    FILE_NAME_CONVERT=(
        '/opt/oracle/oradata/XE/pdbseed/',
        '/opt/oracle/oradata/XE/pdb_alumnos/'
    );
    
/*Ejecutamos la database*/
ALTER PLUGGABLE DATABASE pdb_alumnos OPEN;

/*Ejecutamos la database*/
ALTER SESSION SET CONTAINER = pdb_alumnos;

/*Creamos la tabla*/
CREATE TABLE estudiantes (
    id_ESTUDIANTE NUMBER PRIMARY KEY,
    nombre VARCHAR2(100),
    email VARCHAR2(100) UNIQUE,
    fecha_registro DATE DEFAULT SYSDATE
);


/*Insertamos en la tabla*/
INSERT INTO estudiantes (id_ESTUDIANTE, nombre, email) VALUES (1, 'Ana Perez', '3@GMAIL.COM');
INSERT INTO estudiantes (id_ESTUDIANTE, nombre, email) VALUES (2, 'Luis Gomez', '2@GMAIL.COM');
INSERT INTO estudiantes (id_ESTUDIANTE, nombre, email) VALUES (3, 'Marta Ruiz', '1@GMAIL.COM');

/*Mostramos la tabla*/
select * from estudiantes;

/*Cerramos la PDB*/
ALTER PLUGGABLE DATABASE pdb_alumnos CLOSE IMMEDIATE;

/*actividad 1.2*/
CREATE USER c##comun1 IDENTIFIED BY c1234;
GRANT CREATE SESSION to c##comun1; 
GRANT DBA to c##comun1;


CREATE USER local1 IDENTIFIED BY l1234;
GRANT CREATE SESSION TO local1;
show CON_NAME;

DROP USER local1;

SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE='LOCAL1'; 
//clonar PDB
ALTER SESSION SET CONTAINER=CDB$ROOT;
ALTER PLUGGABLE DATABASE pdb_alumnos CLOSE IMMEDIATE;
SELECT name FROM v$datafile;

CREATE PLUGGABLE DATABASE pdb_alumnos_copia FROM pdb_alumnos
FILE_NAME_CONVERT=('/opt/oracle/oradata/XE/pdb_alumnos/', '/opt/oracle/oradata/XE/pdb_alumnos_copia'); 
SHOW PDBS;

ALTER PLUGGABLE DATABASE pdb_alumnos OPEN;
ALTER PLUGGABLE DATABASE pdb_alumnos_copia OPEN;

ALTER SESSION SET CONTAINER = pdb_alumnos_copia;
SELECT * FROM DBA_SYS_PRIVS WHERE GRANTEE='LOCAL1';
SELECT * FROM estudiantes;

//Eliminar
ALTER SESSION SET CONTAINER=CDB$ROOT;

SELECT pdb_name, status FROM cdb_pdbs WHERE pdb_name IN ('PDB_ALUMNOS', 'PDB_ALUMNOS_COPIA');

BEGIN FOR ses IN
(SELECT sid, serial# from v$session WHERE con_id=(
SELECT con_id FROM v$pdbs WHERE name='PDB_ALUMNOS'))
LOOP
EXECUTE IMMEDIATE 'ALTER SYSTEM KILL SESSION '''||ses.sid||','||ses.serial#||'''IMMEDIATE';
END LOOP;
END;
/

ALTER PLUGGABLE DATABASE pdb_alumnos CLOSE IMMEDIATE;
ALTER PLUGGABLE DATABASE pdb_alumnos_copia CLOSE IMMEDIATE;

DROP PLUGGABLE DATABASE pdb_alumnos INCLUDING DATAFILES;
DROP PLUGGABLE DATABASE pdb_alumnos_copia INCLUDING DATAFILES;

SHOW PDBS;
//EJ 1.4
//CREAR TABLESPACE
CREATE TABLESPACE pruebas DATAFILE  '/opt/oracle/oradata/XE/pruebas.dbf' SIZE 100M AUTOEXTEND ON;
//Listar
SELECT tablespace_name, file_name, bytes/1024/1024 AS MB FROM dba_data_files;
SELECT tablespace_name, contents FROM dba_tablespaces;
//borrar
DROP TABLESPACE tienda INCLUDING CONTENTS AND DATAFILES;

//modificar
ALTER DATABASE DATAFILE  '/opt/oracle/oradata/XE/pruebas.dbf' RESIZE 150M;
SELECT tablespace_name, bytes FROM dba_data_files;
SELECT tablespace_name, contents FROM dba_tablespaces;

//agregamos datafile
ALTER TABLESPACE pruebas ADD DATAFILE '/opt/oracle/oradata/XE/pruebas2.dbf' SIZE 50M;

SELECT tablespace_name, file_name, bytes/1024/1024 AS MB FROM dba_data_files;

//1.5
//creamos tablespace 
CREATE TABLESPACE tienda DATAFILE '/opt/oracle/oradata/XE/tienda2.dbf' SIZE 100M;
//Creamos usuario1
CREATE USER usuario1 IDENTIFIED BY user DEFAULT TABLESPACE tienda QUOTA UNLIMITED on tienda;
SELECT user_id, substr(username,1,30) FROM dba_users WHERE username='USUARIO1';
//Creamos usuario2
CREATE USER usuario2 IDENTIFIED BY user2 DEFAULT TABLESPACE tienda QUOTA 15M ON tienda ACCOUNT LOCK;
SELECT user_id,account_status, substr(username,1,30) FROM dba_users WHERE username='USUARIO2';
//DESBLOQUEAR USUARIO2
ALTER USER usuario2 ACCOUNT UNLOCK;
SELECT user_id,account_status, substr(username,1,30) FROM dba_users WHERE username='USUARIO2';
//DAMOS MAS ESPACIO A USUARIO2
ALTER USER usuario2 QUOTA UNLIMITED ON tienda;
SELECT username, tablespace_name, bytes, max_bytes
FROM dba_ts_quotas  WHERE username='USUARIO2';
//Eliminamos usuario1
DROP USER usuario1;
SELECT user_id, substr(username,1,30) FROM dba_users WHERE username='USUARIO1';
//Damos privilegios a usuario2
GRANT CREATE SESSION, CREATE TABLE TO usuario2;
GRANT CREATE PROCEDURE, EXECUTE ANY PROCEDURE TO usuario2;
SELECT *FROM DBA_SYS_PRIVS WHERE GRANTEE = 'USUARIO2';
//CREAMOS USUARIO3
CREATE USER usuario3 IDENTIFIED BY user DEFAULT TABLESPACE tienda QUOTA UNLIMITED on tienda;
SELECT user_id, substr(username,1,30) FROM dba_users WHERE username='USUARIO3';
//Damos privilegios de ADMIN a usuario3
GRANT DBA TO usuario3;
SELECT *FROM DBA_SYS_PRIVS WHERE GRANTEE = 'USUARIO3';
//Quitamos privilegios a usuario2
REVOKE CREATE TABLE FROM usuario2;
SELECT *FROM DBA_SYS_PRIVS WHERE GRANTEE = 'USUARIO2';

//quitamos priv a usuario3
REVOKE DBA FROM usuario3;
SELECT *FROM DBA_SYS_PRIVS WHERE GRANTEE = 'USUARIO3';


//1.6
//Objetos SQL
//Creamos el objeto
CREATE OR REPLACE TYPE tDomicilio AS OBJECT(
    calle VARCHAR2(50),
    numero INT,
    piso VARCHAR2(4),
    MEMBER FUNCTION getDomicilio RETURN VARCHAR2
);
/

-- Creamos el método
CREATE OR REPLACE TYPE BODY tDomicilio AS
    MEMBER FUNCTION getDomicilio RETURN VARCHAR2 IS
    BEGIN
        RETURN SELF.calle || ' ' || SELF.numero || ' Piso: ' || SELF.piso;
    END;
END;
/

-- Creamos tabla con objeto
CREATE TABLE cliente (
    NIF CHAR(9),
    nombre VARCHAR2(40),
    apellido VARCHAR2(40),
    domicilio tDomicilio
);

//Insertamos datos
INSERT INTO cliente VALUES (
'12345678A',
'Juan',
'Perez',
tDomicilio('Calle Mayor', 10, '2A')
);

SELECT c.NIF, c.nombre, c.domicilio.getDomicilio() FROM cliente c;
//

CREATE TABLE departamentos (
    id NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(50) NOT NULL,
    CONSTRAINT pk_departamentos PRIMARY KEY (id)
);


CREATE TABLE empleados (
    id NUMBER GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR2(50) ,
    apellidos VARCHAR2(80) ,
    email VARCHAR2(100) UNIQUE,
    salario NUMBER(10,2),
    dept_id NUMBER,
    
    CONSTRAINT pk_empleados PRIMARY KEY (id),
    CONSTRAINT fk_empleados_departamentos 
        FOREIGN KEY (dept_id) 
        REFERENCES departamentos(id)
);

INSERT INTO departamentos (nombre) VALUES ('Informatica');
INSERT INTO departamentos (nombre) VALUES ('RRHH');
INSERT INTO departamentos (nombre) VALUES ('Finanzas');

COMMIT;


-- Procedimiento para dar de alta un empleado
CREATE OR REPLACE PROCEDURE sp_alta_empleado(
    p_nombre     IN VARCHAR2,
    p_apellidos  IN VARCHAR2,
    p_email      IN VARCHAR2,
    p_salario    IN NUMBER,
    p_dept_id    IN NUMBER,
    p_id         OUT NUMBER
)
AS
    v_existe NUMBER;
BEGIN
    -- Verificar que el departamento existe
    SELECT COUNT(*) INTO v_existe
    FROM departamentos
    WHERE id = p_dept_id;
    
    IF v_existe = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'El departamento no existe');
    END IF;
    
    -- Insertar empleado
    INSERT INTO empleados (nombre, apellidos, email, salario, dept_id)
    VALUES (p_nombre, p_apellidos, p_email, p_salario, p_dept_id)
    RETURNING id INTO p_id;
    
    COMMIT;
    
    DBMS_OUTPUT.PUT_LINE('Empleado creado con ID: ' || p_id);
    
EXCEPTION
    WHEN DUP_VAL_ON_INDEX THEN
        RAISE_APPLICATION_ERROR(-20002, 'El email ya existe');
    WHEN OTHERS THEN
        ROLLBACK;
        RAISE;
END sp_alta_empleado;
/

-- Desde SQL*Plus o SQL Developer
SET SERVEROUTPUT ON;

DECLARE
    v_nuevo_id NUMBER;
BEGIN
    sp_alta_empleado(
        p_nombre    => 'Nuevo',
        p_apellidos => 'Empleado Test',
        p_email     => 'nuevo.test@empresa.com',
        p_salario   => 30000,
        p_dept_id   => 3,
        p_id        => v_nuevo_id
    );
    DBMS_OUTPUT.PUT_LINE('ID asignado: ' || v_nuevo_id);
END;
/

-- O usando EXECUTE (solo para procedimientos sin OUT)
EXEC nombre_procedimiento(param1, param2);

--1.7
--Modificamos la tabla para crear funcion
ALTER TABLE empleados ADD  fecha_alta DATE;
UPDATE  empleados SET fecha_alta=SYSDATE;
SELECT * FROM empleados;

-- Funcion para calcular antiguedad en anos
CREATE OR REPLACE FUNCTION fn_antiguedad_empleado(
    p_empleado_id IN NUMBER
)
RETURN NUMBER
AS
    v_fecha_alta DATE;
    v_antiguedad NUMBER;
BEGIN
    SELECT fecha_alta
    INTO v_fecha_alta
    FROM empleados
    WHERE id = p_empleado_id;
    
    v_antiguedad := TRUNC(MONTHS_BETWEEN(SYSDATE, v_fecha_alta) / 12);
    
    RETURN v_antiguedad;
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RETURN NULL;
END fn_antiguedad_empleado;
/

-- Uso en SELECT
SELECT nombre, apellidos, fn_antiguedad_empleado(id) AS antiguedad_anos
FROM empleados
WHERE dept_id = 3;


--1.8
-- Trigger para auditar cambios en empleados
CREATE OR REPLACE TRIGGER trg_auditoria_empleados
AFTER INSERT OR UPDATE OR DELETE ON empleados
FOR EACH ROW
DECLARE
    v_operacion VARCHAR2(10);
    v_datos_antes CLOB;
    v_datos_despues CLOB;
BEGIN
    -- Determinar operacion
    IF INSERTING THEN
        v_operacion := 'INSERT';
        v_datos_despues := 'ID=' || :NEW.id || ', Nombre=' || :NEW.nombre;
    ELSIF UPDATING THEN
        v_operacion := 'UPDATE';
        v_datos_antes := 'ID=' || :OLD.id || ', Nombre=' || :OLD.nombre;
        v_datos_despues := 'ID=' || :NEW.id || ', Nombre=' || :NEW.nombre;
    ELSIF DELETING THEN
        v_operacion := 'DELETE';
        v_datos_antes := 'ID=' || :OLD.id || ', Nombre=' || :OLD.nombre;
    END IF;

    -- Insertar registro de auditoria
    INSERT INTO auditoria (
        tabla_afectada, operacion, registro_id,
        datos_antes, datos_despues
    ) VALUES (
        'EMPLEADOS', v_operacion, NVL(:NEW.id, :OLD.id),
        v_datos_antes, v_datos_despues
    );
END;
/
CREATE TABLE auditoria_empleados (
    id_auditoria NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha        DATE,
    operacion    VARCHAR2(10),
    datos_antes  CLOB,
    datos_despues CLOB
);

SELECT trigger_name, table_name, status, trigger_type
FROM user_triggers;.

-1.9
CREATE OR REPLACE PROCEDURE sp_con_defecto(
    p_nombre    IN VARCHAR2,
    p_salario   IN NUMBER DEFAULT 20000,
    p_dept_id   IN NUMBER DEFAULT 1
)
AS
BEGIN
    INSERT INTO empleados (nombre, salario, dept_id)
    VALUES (p_nombre, p_salario, p_dept_id);
END;
/
-- Llamadas validas
BEGIN
    sp_con_defecto('Juan');         -- usa valores por defecto
    sp_con_defecto('Ana', 30000);   -- cambia salario
    sp_con_defecto('Pedro', p_dept_id => 3); -- cambia dept
END;
/
EXEC sp_con_defecto('Jose');
select * from empleados;

