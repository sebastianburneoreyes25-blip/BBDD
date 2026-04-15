PL/SQL

SQL es un lenguaje tipo declarativo EL usuario solo indica sin especificar como obtenerlo

PL/SQL es una extensión del lenguaje sql para incluir la programación procedimental  lo que es mismo programación imperativa

Permite 

\-todo lo que admite sql

Declaración de variables

Utilización de sentencias de control de flujo

Creación de procedimientos

No puedo

\-Diseñar la interfaz de usuario

Crear programas ejecutables completos

\-Triggers desencadenan o ejecutan cuando ocurre un eventos relacionado con una tabla de la base de datos

DECLARACION

DECLARE nombre VARCHAR(25);

DECLARE edad INT;

DECLARE salida VARCHAR(70);

\--Asignacion 

SET nombre=’PEPE’;

SET edad=25;

SET salida=concat(‘hola’,nombre,’’tienes’,edad,’años’);

\--SALIDA

SELECT salida;

CREATE PROCEDURE 

