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
    FILE_NAME_CONVERT = (
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
commit;

/*Cerramos la PDB*/
ALTER PLUGGABLE DATABASE pdb_alumnos CLOSE IMMEDIATE;

