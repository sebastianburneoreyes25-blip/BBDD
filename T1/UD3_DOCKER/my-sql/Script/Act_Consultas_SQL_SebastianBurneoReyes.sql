CREATE DATABASE IF NOT EXISTS Act_Consultas_SQL_Sebastian_Israel_Burneo_Reyes;
use Act_Consultas_SQL_Sebastian_Israel_Burneo_Reyes;

DROP TABLE IF EXISTS clientes;

CREATE TABLE clientes(
idcliente INT AUTO_INCREMENT ,constraint PK_idCliente PRIMARY KEY (idcliente), 
nombre VARCHAR(25) NOT NULL,
direccion varchar (40),
poblacion VARCHAR(40) NOT NULL DEFAULT 'Madrid',
facturacion INT,
fechaalta DATE,
credito INT NOT NULL DEFAULT 500
);

DESCRIBE clientes;
SELECT * FROM clientes;

INSERT IGNORE INTO clientes (nombre, direccion, poblacion, facturacion, fechaalta, credito) VALUES
('Juan Pérez', 'Calle Mayor 12', 'Madrid', 25000, '2024-01-15', 1000),
('Laura Gómez', 'Avda. del Sol 45', 'Sevilla', 18000, '2024-03-10', 750),
('Carlos López', 'Calle Luna 8', 'Valencia', 32000, '2024-05-25', 1200),
('Marta Sánchez', 'Calle Río 23', 'Bilbao', 27000, '2024-02-18', 500),
('Andrés Torres', 'Plaza Mayor 3', 'Madrid', 15000, '2024-06-05', 600),
('Lucía Fernández', 'Calle Real 67', 'Barcelona', 45000, '2024-07-20', 2000),
('Pedro Ruiz', 'Calle Jardín 4', 'Granada', 22000, '2024-08-10', 800),
('Sofía Morales', 'Avda. Libertad 21', 'Zaragoza', 31000, '2024-09-02', 1000),
('Javier Castillo', 'Calle Norte 11', 'Toledo', 28000, '2024-04-12', 700),
('Elena Navarro', 'Calle Sur 19', 'Valladolid', 35000, '2024-10-30', 1500),
('Javier Castillo', null, 'Toledo', 28000, '2024-04-12', 700);

INSERT INTO clientes (nombre, direccion, poblacion, facturacion, fechaalta, credito) VALUES
('Cliente prueba', 'Avda. del Sol 45', 'Sevilla', 180000, '2024-03-10', 7500);

SELECT nombre,direccion FROM clientes;
SELECT DISTINCT POBLACION FROM clientes;
SELECT *FROM clientes ORDER BY fechaalta ASC;
SELECT * FROM clientes WHERE credito>2000;
SELECT nombre,facturacion,facturacion-1000 AS facturacionReducido from clientes;
SELECT nombre, facturacion/10 AS facturacion10 from clientes;
SELECT * FROM clientes WHERE facturacion>=15000;
SELECT * FROM clientes WHERE facturacion <20000;
SELECT * FROM clientes WHERE poblacion='Madrid' OR poblacion='Barcelona';
SELECT *FROM clientes WHERE nombre LIKE '%Cliente%';
SELECT *FROM clientes WHERE facturacion BETWEEN 15000 and 25000;
SELECT *FROM clientes WHERE poblacion IN ('Madrid','Barcelona','Valencia');
SELECT *FROM clientes WHERE direccion IS NULL;
SELECT poblacion, sum(facturacion) as facturacion_Total FROM clientes GROUP BY poblacion;
SELECT poblacion, sum(facturacion) AS facturacionTotal FROM clientes GROUP BY poblacion HAVING facturacionTotal>40000;
SELECT * FROM clientes ORDER BY credito DESC;
UPDATE clientes SET credito=5000 WHERE poblacion='Madrid';
select poblacion,credito from clientes where poblacion='Madrid';
SELECT * FROM clientes WHERE facturacion>=(SELECT AVG(facturacion)FROM clientes);
DELETE FROM clientes WHERE facturacion<10000;
SELECT COUNT(idcliente) FROM clientes;
SELECT AVG(facturacion) FROM clientes;
SELECT MAX(facturacion) FROM clientes;
SELECT MIN(facturacion)FROM clientes;
SELECT SUM(credito)FROM clientes;
SELECT DISTINCT poblacion FROM clientes;
SELECT COUNT(DISTINCT poblacion) FROM clientes;
SELECT *FROM clientes WHERE fechaalta>'2023-06-01';
SELECT *FROM clientes WHERE poblacion NOT IN ('Madrid','Barcelona') ;
SELECT *FROM clientes WHERE facturacion ORDER BY facturacion DESC LIMIT 5;
SELECT *FROM clientes ORDER BY fechaalta ASC LIMIT 5 OFFSET 3;
SELECT *FROM clientes WHERE nombre NOT LIKE ("%Cliente%");
SELECT c.idcliente, c.nombre, f.idfilial, f.nombre	FROM clientes c JOIN filial f on c.idcliente=f.idcliente;
SELECT *FROM clientes LEFT JOIN filial ON clientes.idcliente=filial.idcliente;
SELECT c.idcliente, c.nombre, f.idfilial FROM clientes c INNER JOIN filial f ON c.idcliente=f.idcliente;
SELECT DISTINCT c.idcliente, c.nombre, cc.poblacion FROM clientes c  JOIN clientes cc ON c.poblacion=cc.poblacion order by cc.poblacion; 
Select c.*,count(f.idfilial) as cantidad_filiales from clientes c LEFT JOIN filial f on c.idcliente=f.idCliente group by c.idcliente;
SELECT *FROM clientes c RIGHT JOIN filial f ON c.idcliente=f.idcliente WHERE c.facturacion>20000;
SELECT c.idcliente, c.nombre, (SELECT count(f.idfilial) from filial f WHERE f.idcliente=c.idcliente) as cantidad_filiales FROM clientes c; 
SELECT * FROM clientes c LEFT JOIN filial f ON c.idcliente=f.idcliente where f.idfilial is null;
SELECT *FROM clientes c RIGHT JOIN filial f ON c.idcliente=f.idcliente WHERE c.idcliente is null;
SELECT * FROM clientes c join filial f on f.idcliente=c.idcliente where (select count(f.idfilial) as cantidad from filial f  WHERE f.idcliente=c.idcliente); 
SELECT * FROM clientes WHERE (select count(idfilial) as cantidad from filial where clientes.idcliente=filial.idcliente);


CREATE TABLE IF NOT EXISTS filial(
idfilial INT AUTO_INCREMENT PRIMARY KEY ,
nombre VARCHAR(50), 
idCliente INT, CONSTRAINT FK_clientes_filial FOREIGN KEY (idCliente)
REFERENCES clientes (idCliente) ON DELETE RESTRICT
);

DESCRIBE  filial;

INSERT IGNORE INTO filial (nombre, idCliente) VALUES 
('Filial Norte', 1),
('Filial Sur', 2),
('Filial Este', 3), 
('Filial Oeste', 4),
('Filial Central', 5),
('Filial Andina', 6), 
('Filial Pacífico', 7),
('Filial Atlántico', 8),
('Filial Amazonia', 9),
('Filial Patagonia', 10);

INSERT INTO filial(nombre) Values ('FilialSinCliente');

SELECT * FROM filial;




