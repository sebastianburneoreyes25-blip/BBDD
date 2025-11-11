CREATE DATABASE IF NOT EXISTS TechPlanet;
USE TechPlanet;
show databases;

CREATE TABLE IF NOT EXISTS departamentos(
id INT auto_increment primary KEY NOT NULL,
nombre varchar(50) not null,
ubicacion enum('Madrid', 'Barcelona','Valencia','Remoto')
);
describe departamentos;



CREATE TABLE IF NOT EXISTS 	empleados(
id INT auto_increment primary KEY NOT NULL,
nombre varchar(100) not null,
genero enum('M','F','Otro'),
tipo_contrato ENUM('Temporal','Indefinido','Becario'),
habilidades set('Java','Python','HTML','CSS','SQL','Docker','Linux'),
salario decimal(8,2),
departamento_id int not null #Foreign key
);
describe empleados;


INSERT INTO empleados(nombre, genero, tipo_contrato, habilidades,salario,departamento_id) 
VALUES  ('Sebas', 'M', 'Temporal', 'Java,Python,SQL',35000.00,1 ), 
		('Lope', 'M', 'Indefinido', 'Java,HTML,CSS',28000.00,1 ) ,
        ('Desire', 'F', 'Temporal', 'Java,Python,SQL',35000.00,1 ) ,
        ('Jesus', 'M', 'Becario', 'Python',25000.00,1 ) ,
        ('Juanjo ', 'M', 'Indefinido', 'Java',29000.00,1 ) ;
        
INSERT INTO empleados
set nombre='Cristina',
	genero='F',
    tipo_contrato='Indefinido',
    habilidades='SQL',
    salario=38000.00,    
	departamento_id=2;
select*from empleados;
    
SELECT id,nombre,habilidades FROM empleados;

select* from empleados where tipo_contrato='Indefinido';

#Se usa fin_in_set para buscar en una cadena separadas por comas
select* from empleados where find_in_set('Python',habilidades) ;

#Se usa like '%,%' para buscar que tenga mas de una cosa.
select* from empleados where habilidades like '%,%';

select* from empleados ORDER BY salario DESC;
        
describe empleados;


INSERT INTO empleados
set nombre='Alba',
	genero='A',
    tipo_contrato='Indefinido',
    habilidades='SQL',
    salario=38000.00,    
	departamento_id=2;