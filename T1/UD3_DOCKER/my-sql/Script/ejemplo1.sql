CREATE DATABASE ejemplo1;
USE ejemplo1;

CREATE TABLE IF NOT EXISTS clientes(
Cif int auto_increment,CONSTRAINT PK_Cif PRIMARY KEY (Cif),
nombre VARCHAR(20),
direccion VARCHAR(30),
poblacion VARCHAR(20),
web VARCHAR(30),
correo VARCHAR(30)
);

CREATE TABLE IF NOT EXISTS facturas(
idFacturas INT AUTO_INCREMENT,CONSTRAINT PK_idFacturas PRIMARY KEY (idFacturas),
fechaFactura DATE NOT NULL,
total DECIMAL (20,2),
IVA DECIMAL (10,2),
descuento INT NULL,
Cif INT, CONSTRAINT FK_facturas_clientes FOREIGN KEY (Cif) REFERENCES clientes(Cif) ON DELETE CASCADE
);
 
 