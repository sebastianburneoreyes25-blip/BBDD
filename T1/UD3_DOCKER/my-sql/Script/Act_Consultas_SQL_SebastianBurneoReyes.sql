CREATE DATABASE IF NOT EXISTS Act_Consultas_SQL_Sebastian_Israel_Burneo_Reyes;
use Act_Consultas_SQL_Sebastian_Israel_Burneo_Reyes;

CREATE TABLE IF NOT EXISTS clientes(
idcliente INT AUTO_INCREMENT PRIMARY KEY ,
nombre VARCHAR(25) NOT NULL,
direccion varchar (40),
poblacion VARCHAR(40) NOT NULL DEFAULT 'Madrid',
facturacion INT,
fechaalta DATE,
credito INT NOT NULL DEFAULT 500
);
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

CREATE TABLE IF NOT EXISTS filial(
idfilial INT AUTO_INCREMENT PRIMARY KEY ,
nombre VARCHAR(50), 
idCliente INT, CONSTRAINT FK_clientes_filial FOREIGN KEY (idCliente)
REFERENCES clientes (idCliente)
);

