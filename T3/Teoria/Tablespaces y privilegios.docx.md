Tablespaces y privilegios

Oracle utiliza tablespaces para gestionar el almacenamiento de los datos de las bases de datos

Los privilegios son necesarios para controlar qué tiene acceso a qué en una base de datos

Un tablespaces es una unidad lógica de almacenamiento dentro de una base de datos de Oracle. Son estructuras donde se almacenan los objetos del esquema de la base de datos.Ante de crear las tables de la base de datos se tiene que crear un tablespaces

Los tablespaces se componen como mínimo de un datafile y cada datafile solo puede pertenecer a un tablespaces

\-SYSTEM: contiene un diccionario de datos creado automáticamente 

\-SYSAUX es un tablespace auxiliar donde se almacenan algunos de los componentes que antes se almacenaban en el tablespaces SYSTEM

\-TEMP contiene objetos temporales

\-BIGFILE tablespace que almacena un solo datafile muy grande 128TB

\-USER usado para almacenar permanentemente objetos 

CREATE TABLESPACE

CREATE \[TEMPORARY|UNDO\] TABLESPACE nombre del tablespace DATAFILE opciones datafile opciones almacenamiento.

Las rutas de los datafiles se resumen en

\-‘ruta y nombre del fichero’ SIZE entero \[K|M\]\[AUTOEXTEND OFF\]

\-‘ruta y nombre del fichero’ SIZE entero \[K|M\]\[AUTOEXTEND ON \[NEXT int \[K|M\]\[MAX SIZE int\[K|M\]\]

\-SIZE especifica el tamaño del tablespaces en KB o MB

\-AUTOEXTEND activa o desactiva el crecimiento automático del tablespace

\-NEXT especifica el incremento y MAXSIZE el tamaño máximo de espacio reservado en el disco

\-MAXSIZE toma el valor por defecto UNLIMITED si no se especifica ningún valor

Opciones de almacenamiento

DEFAUTL STORAGE(

INITIAL entero

NEXT entero

MINEXTENTS entero 

MAXENTENTS entero 

PCTINCREASE entero)

ONLINE|OFFLINE

PERMANENT | TEMPORARY

EXTEND MANAGMENT {DICTIONARIO |LOCAL{AUTOALLOCATE|UNIFORM\[SIZE entero K|M}}

Cuando creamos un tablespace podemos definir un almacenamiento por defecto para los objetos qie se crean dentro de erl 

\-ONLINE   |OFFLINE activamos o desactivamos el acceso al tablespace por defecto

PERMANENT |TEMPORARY

\-EXTENT MANGMENT 

\-DICTIONARU mediante tablas del diccionario

\-LOCAL mediante un mapa de bit

\-AUTOALLOCATE el tablespace lo gestiona el sistema

UNIFORM  se gestiona con extensiones de un tamaño determinado

Modificar tablespace

ALTER TABLESPACE nombre tablespace 

\-ADD DATAFILE para añadir uno o ,más archivos 

RENAME DATAFILE cambia el nombre del fichero. Primero debe realizarse desde el SO

\-ONLINE|OFFLINE ONLINE actica el tablespace y OFFLINE lo desactiva

Borrar tablespace

DROP TABLESPACE nombre del tablespace INCLUDING CONTENT \[AND DATAFILES\]

INCLUDING CONTENT borra tablespace que contenga datos AND DATAFILES elimina los archivo de datos asociados a este tablespace

Consultar tablespace

\-DBA\_TABLESPACES muestra información relativa a los tablespace (obtener nombre y tipo de tablespace)

\-DBA\_DATA\_FILES nos muestra información sobre los archivos que utiliza el tablespace

\-DBA\_TS\_QUOTAS muestra en cada tablespace los bytes usados cada usuario

\-USER\_FREE\_SPACE muestra las extensiones libres en los tablespaces

CREATE TABLESPACE pruebas DATAFILE  ‘c:\\\\oracle\\\\pruebas.**dbf’** SIZE 100M AUTOEXTEND ON;

SELECT tablespace\_name, bytes FROM dba\_data\_files;//asi tal cual

LISTAR NOMBRE Y TIPO TABLESPACE

SELECT tablespace\_name, contents FROM dba\_tablespace;

Borrar

DROP TABLESPACE pruebas INCLUDING CONTENTS AND DATAFILES;

Modificar

ALTER DATABASE DATAFILE ‘c:\\\\oracle\\\\pruebas.dbf’ RESIZE 150M;//Modificamos el DATAFILE

ALTER TABLESPACE pruebas ADD DATAFILE ‘ruta/pruebas2.dbf’ SIZE 50M;//añadir datafile

SELECT tablespace\_name, contents FROM dba\_tablespace;  //Consultar el tamaño del tablespace, nos mostrará un tablespace por datafile

Usuarios 

Durante el proceso de instalación de Oracle se crean dos cuentas administrativas y otras dos cuentas con permisos especiales para tareas de optimización y monitorización

SYS rol DBA y en su esquema se crea el diccionario de datos donde se almacena información sobre el resto de las estructuras .(no se deberían crear otro tipo de tablas)

SYSTEM también DBA y se crean durante la instalación contraseña manager o la del composer y en su esquema se suelen crear tablas y vistas administrativas .(no se deberían crear otro tipo de tablas)

SYSMAN usado para realizar tareas administrativas con Enterorise manager

SBSNMP monitoriza el Entrtprise manager

Para crear un usuario de Oracle debes disponer del privilegio CREATE USER. Para crear usuarios por primera vez deberemos conectarnos con SYSTEM. Utilizaremos la orden CREATE USER CON

CREATE USER nombre IDENTITIES BY contraseña 

\[DEFAULT TABLESPACE nombre tablespace\]

\[TEMPORARY TABLESPACE nombre\]

\[QUOTA 

DEFAULT y TEMPORARY SPACE asignan el tablespace de trabajo y temporal al usuario. Si no se especifica el DEFAULT se asigna por defecto USERS

QUOTA asigna el límite de almacenamiento en KB o MB, ilimitado con UNLIMITED

PROFILE asigna un perfil al usuario Los perfiles sirven para asignar el tiempo de CPU

PASSWORD EXPIRE especifica que la contraseña asignada al usuario CADUCARÁ. El usuario o DBA asignan una nueva

ACCOUNT LOCK bloquear la cuenta del usuario en el momento de la creación. Por defecto se crea desbloqueada

DBA\_USER muestra la lista y configuración del sistema(DESCRIBE DBS\_USERS)

Para modificar usuario ALTER USER y el nombre del usuario

Borrar es DROP USER 

DROP USER nombre \[CASCADE\];

\-CASCADE suprime todos los elementos del usuario antes de borrarlo. Si intentamos borrar un usuario sin esta opción sin cascade y hay cosas dará error

CREATE TABLESPACE tienda DATAFILE ‘ruta’ SIZWE 100M;

CREATE USER usuario1 IDENTIFIED BY ‘user’ DEFAULT TABLESPACE tienda QUOTA UNLIMITED on tienda;

CREATE USER usuario2 IDENTIFIED BY ‘user2’ DEFAULT TABLESPACE tienda QUOTA 15M ON tienda ACCOUNT LOCK;

ALTER USER usuario2 ACCOUNT UNLOCK;

ALTER USER usuario2 QUOTA UNLIMITED ON tienda;

DROP USER usuario1;

SELECT user\_id, substr(username,1,30) FROM dba\_users;

PRIVILEGIOS 

Los privilegios son permisos que damos a los usuarios para que puedan realizar ciertas operaciones

Pueden ser privilegios del sistema , objeto y roles

Privilegios de sistema permiten ejecutar comandos del tipo DDL o DML . Existen dos privilegios especiales que permiten conceder nivel DBA y son SYSDBA y SYSOPER

Entre los privilegios de sistema podemos destacar:

Créate tanñe 

Créate anu table

Alter table

Drop any table

LOCK anuy table //bloquear

MANAGE TABLESPACE //poner online offline tablescape

El privilegio SYSOPER a diferencia del SYSBDA permite a un usuario realizar las tareas básicas de funcionamiento pero sin la capacidad de mirar los datos del usuario.

Para asignar los privilegios 

GRANT permisos TO  usuario|rol \[WITH ADMIN OPTION\];

WITH ADMIN OPTION puede conceder a otros usuarios o roles

Concedemos permiso de crear usuarios al 1

GRANT CREATE USER TO usuario1 WITH ADMIN OPTION;

REVOKE quita privilegios.

REVOKE permisos |ALL PRIVILEGES 

FROM usuarios|rol|PUBLIC\[nombreUsuario|nombreRol\];

PUBLIC quita el privilegio o privilegios a todos los usuarios del sistema

Privilegios sobre obj

Permiten al usuario realizar ciertas acciones en objetos de la base de datos.

Si el usuario no se le dan estos permisos sólo puede acceder a sus propios objetos. Estos los puede conceder el administrador.

GRANT privilegios \[(columna 1,….)\]\[ON usuario\[.objeto\]|ANY TABLE\]

\==========================================================

GRANT CREATE SESSION, CREATE TABLE TO usuario2;

GRAN CREATE PROCEDURE, EXECUTE ANY PROCEDURE TO usuario2;

Creamos user 3

GRAN DBA TO usuario3;

REVOKE ALL PRIVILEGES FROM usuario1;

REVOKE CREATE TABLE FROM usuario2;