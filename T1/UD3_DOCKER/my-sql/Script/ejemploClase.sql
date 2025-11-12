CREATE DATABASE vecindario;
USE vecindario;

CREATE TABLE persona(
DNI VARCHAR(9),
nombre VARCHAR(15),
apellido VARCHAR(15),
CONSTRAINT PK_persona_DNI primary key(DNI)
);

CREATE TABLE piso(
idpiso INT AUTO_INCREMENT PRIMARY KEY,
poblacion VARCHAR(15),
direccion VARCHAR(20),
idPersona VARCHAR(9),
CONSTRAINT FK_piso_persona FOREIGN KEY (idPersona) REFERENCES persona(DNI) 
) AUTO_INCREMENT=2000;

INSERT INTO persona(DNI,nombre,apellido) VALUES ('12345678K','persona1','apellido1'),('98765432A','Persona2','Nombre2');

INSERT INTO piso(poblacion,direccion,idPersona) values ('Madrid', 'CALLE 13', '12345678K');

SELECT persona.DNI, persona.nombre, piso.idpiso, piso.direccion FROM persona JOIN piso ON persona.DNI=piso.idPersona;

ALTER TABLE piso ADD poblacion VARCHAR(15);

ALTER TABLE piso ADD empadronados int DEFAULT 0;

select * FROM piso;

ALTER TABLE piso DROP FOREIGN KEY FK_piso_persona;

SHOW CREATE TABLE piso;

ALTER TABLE piso ADD CONSTRAINT FK_PERSONA_PISO FOREIGN KEY (idPersona) REFERENCES persona(DNI);
