DROP DATABASE IF EXISTS empresa;
CREATE DATABASE IF NOT EXISTS empresa;
USE empresa;


CREATE TABLE IF NOT EXISTS empleados(
idEmpleado INT AUTO_INCREMENT PRIMARY KEY,
nombre VARCHAR(25),
jefe INT NULL, CONSTRAINT FK_jefe_empleado FOREIGN KEY (jefe) REFERENCES empleados(idEmpleado)
);
DESCRIBE empleados;


INSERT INTO empleados(nombre, jefe) VALUES 
('Ruperto', NULL),
('Lucas', 1),
('Rosa',1),
('Perico',2),
('Carlos',2),
('Miguel', 3),
('Alicia',3),
('Agapito',3);

SELECT * FROM empleados;

SELECT j.nombre AS jefe, s.nombre AS empleado FROM empleados s LEFT JOIN empleados j ON s.jefe = j.idEmpleado;

SELECT j.idEmpleado AS idJefe,j.nombre AS jefe,s.idEmpleado AS idEmpleado,s.nombre AS empleado 
FROM empleados s LEFT JOIN empleados j ON s.jefe = j.idEmpleado;

SELECT e.idEmpleado as idEmpleado, e.nombre as Empleado 
FROM empleados e INNER JOIN empleados j ON e.idEmpleado=j.idEmpleado WHERE j.jefe=3; 

SELECT e.idEmpleado as idEmpleado, e.nombre as Empleado 
FROM empleados e INNER JOIN empleados j ON e.idEmpleado=j.idEmpleado WHERE j.jefe=2 AND e.nombre LIKE 'C%';	

SELECT j.idEmpleado as idJefe, j.nombre AS Jefe FROM empleados e JOIN empleados j ON j.idEmpleado=e.jefe WHERE e.nombre='Alicia';

SELECT DISTINCT e.idEmpleado,e.nombre FROM empleados e INNER JOIN empleados s 
ON s.jefe = e.idEmpleado WHERE e.jefe IS NULL; 

SELECT e.idEmpleado,e.nombre FROM empleados e LEFT JOIN empleados s 
ON s.jefe = e.idEmpleado WHERE s.idEmpleado IS NULL;