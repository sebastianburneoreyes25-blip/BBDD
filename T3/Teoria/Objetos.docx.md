Tipos de Objeto

Un OBDBMS object dabatase management system es un sistema gestor de base de datos que permite trabajar con objetos directamente. Aunque Oracle es relacional también soporta características orientadas a objetos

Definir objeto en Oracle 

En Oracle un tipo objeto es como una clase en programación con atributos y métodos

CREATE OR REPLACE TYPE tDomicilio AS OBJECT(atributos );

La cabecera (CREATE OR REPLACE TYPE define la Estricto sus atributos y la firma de sus métodos 

Esta definición se guarda en el diccionario de Oracle como un nuevo tipo de dato que luego se podrá usar en tablas. Si intentar usa ese tipo en una tabla sin haberla definido antes te dará un error

Cuando trabajas como objetos se comportan como clases en programación

Para poder usar ese tipo de datos dentro de una tabla Oracle necesita saber ese tipo de dato

Debes declara la cabecera del tipo antes de usarla en cualquier parte porque

Le estas diciendo que es ese tipo

Solo así puedes usarlo en estructuras con tablas y columnas…

funciona como una clase reutilizable

Para implementar los métodos declarados se usa 

CREATE TYPE BODY tDomicilio AS MEMBER FUNCTION nombre función RETURN VARCHAR IS 

BEGIN RETURN (lo que sea ) END;//Cerrar begin END;//Cerar créate type 

Cuando defines un tipo de objeto TYPE n Oracle puedes incluir métodos en el 

\-Primero declares el método en la cabecera del tipo

\-Después se crea el método implementando como funciona

Oracle separa la declaración de la implementación

\-Declarar para registrar tipo y su firma

Implementamos para escribir la lógica real del método

Sirve para encapsular lógica dentro del objeto y poder usarla fácilmente en consultas

Crear una tabla con tipos objeto

CREATE TABLE cliente (atributo, DOMICILIO tDomicilio//Objeto );

Insertar datos en tabla con objetos

INSERT INTO cliente VALUES(datos, tDomicilio(datos deL OBJETO));

Consultar atributos y métodos

SELECT c.datos, c.domilio.getDomicilio() FROM cliente c;

Fechas 

3 evaluación 2 marzo a 15 mayo(fecha límite exámenes 14 mayo)

no recu

Prácticas del 18 a 29 de mayo

Ordinaria lunes 1 junio

Extraordinaria martes 9 junio

Junta evaluación 15 junio. 

Examen 22-23

Otro examen 13-14

