CREATE DATABASE IF NOT EXISTS biblioteca_digital ;
USE biblioteca_digital; 
CREATE TABLE autores( 
id_autor CHAR(9) PRIMARY KEY NOT NULL, 
nombre_autor VARCHAR(20), 
nacionalidad VARCHAR(20) ); 

CREATE TABLE editoriales ( 
id_editorial INT AUTO_INCREMENT PRIMARY KEY, 
nombre_editorial VARCHAR(100) NOT NULL, 
pais VARCHAR(50) ); 

CREATE TABLE libros ( 
id_libro INT AUTO_INCREMENT PRIMARY KEY, 
titulo VARCHAR(200) NOT NULL,
id_autor CHAR(9) NOT NULL, 
id_editorial INT NOT NULL, 
año_publicacion YEAR, 
isbn VARCHAR(20) UNIQUE,
FOREIGN KEY (id_autor) REFERENCES autores(id_autor) ON DELETE CASCADE, 
FOREIGN KEY (id_editorial) REFERENCES editoriales(id_editorial) ON DELETE CASCADE ); 

CREATE TABLE usuarios ( 
id_usuario INT AUTO_INCREMENT PRIMARY KEY, 
nombre_usuario VARCHAR(100) NOT NULL, 
email VARCHAR(100) UNIQUE NOT NULL, 
fecha_registro DATE DEFAULT (CURRENT_DATE) ); 

CREATE TABLE prestamos ( 
id_prestamo INT AUTO_INCREMENT PRIMARY KEY, 
id_usuario INT NOT NULL, 
id_libro INT NOT NULL, 
fecha_prestamo DATE NOT NULL, 
fecha_devolucion DATE, 
devuelto BOOLEAN DEFAULT FALSE, 
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE, 
FOREIGN KEY (id_libro) REFERENCES libros(id_libro) ON DELETE CASCADE ); 

CREATE TABLE valoraciones ( 
id_valoracion INT AUTO_INCREMENT PRIMARY KEY, 
id_usuario INT NOT NULL, 
id_libro INT NOT NULL, 
puntuacion TINYINT NOT NULL CHECK (puntuacion BETWEEN 1 AND 5), 
comentario TEXT, 
fecha_valoracion DATE DEFAULT (CURRENT_DATE), 
FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario) ON DELETE CASCADE, 
FOREIGN KEY (id_libro) REFERENCES libros(id_libro) ON DELETE CASCADE ); 

CREATE TABLE multas ( 
id_multa INT AUTO_INCREMENT PRIMARY KEY, 
id_prestamo INT NOT NULL, 
importe DECIMAL(10,2) NOT NULL, 
pagada BOOLEAN DEFAULT FALSE, 
FOREIGN KEY (id_prestamo) REFERENCES prestamos(id_prestamo) ON DELETE CASCADE );

INSERT INTO autores (id_autor, nombre_autor, nacionalidad) VALUES
('A001', 'Gabriel Márquez', 'Colombiana'),
('A002', 'Isabel Allende', 'Chilena'),
('A003', 'J.K. Rowling', 'Británica'),
('A004', 'George Orwell', 'Británica');

INSERT INTO editoriales (nombre_editorial, pais) VALUES
('Penguin Random House', 'Estados Unidos'),
('Planeta', 'España'),
('Bloomsbury', 'Reino Unido');

INSERT INTO libros (titulo, id_autor, id_editorial, año_publicacion, isbn) VALUES
('Cien Años de Soledad', 'A001', 2, 1967, '978-84-204-0613-0'),
('La Casa de los Espíritus', 'A002', 2, 1982, '978-84-323-3582-5'),
('Harry Potter y la Piedra Filosofal', 'A003', 3, 1997, '978-74-133-6003-0'),
('1984', 'A004', 1, 1949, '978-0-452-28423-4');

INSERT INTO usuarios (nombre_usuario, email) VALUES
('Juan Pérez', 'juan.perez@email.com'),
('María López', 'maria.lopez@email.com'),
('Carlos Gómez', 'carlos.gomez@email.com');

INSERT INTO prestamos (id_usuario, id_libro, fecha_prestamo, fecha_devolucion, devuelto) VALUES
(1, 1, '2026-01-01', '2026-01-10', TRUE),
(2, 3, '2026-01-05', NULL, FALSE),
(3, 2, '2026-01-08', '2026-01-12', TRUE);

INSERT INTO valoraciones (id_usuario, id_libro, puntuacion, comentario) VALUES
(1, 1, 5, 'Una obra maestra de la literatura.'),
(2, 3, 4, 'Muy entretenido para todas las edades.'),
(3, 2, 3, 'Interesante, pero un poco largo.');

INSERT INTO multas (id_prestamo, importe, pagada) VALUES
(2, 5.00, FALSE);  

/*Ejemplo 1:*/
SELECT libros.titulo, autores.nombre_autor FROM libros
INNER JOIN autores ON libros.id_autor = autores.id_autor;

/*Ejemplo 2*/
SELECT prestamos.id_prestamo, usuarios.nombre_usuario, prestamos.fecha_prestamo
FROM prestamos INNER JOIN usuarios ON prestamos.id_usuario = usuarios.id_usuario;

/*Ejemplo 3: Mismo que Ejemplo 1, con alias*/
SELECT l.titulo, a.nombre_autor FROM libros AS l
INNER JOIN autores AS a ON l.id_autor = a.id_autor;

/*Ejemplo 4: Libros con su editorial*/
SELECT l.titulo, e.nombre_editorial, l.año_publicacion FROM libros l
INNER JOIN editoriales e ON l.id_editorial = e.id_editorial;


/*Ejemplo 5: Préstamos con usuario y libro
Objetivo: Ver quién ha prestado qué libro.*/
SELECT u.nombre_usuario, l.titulo, p.fecha_prestamo FROM prestamos p
INNER JOIN usuarios u ON p.id_usuario = u.id_usuario
INNER JOIN libros l ON p.id_libro = l.id_libro;

/*Ejemplo 6: Préstamos completos (usuario, libro, autor, editorial)*/
SELECT u.nombre_usuario, l.titulo, a.nombre_autor, e.nombre_editorial, p.fecha_prestamo FROM prestamos p
INNER JOIN usuarios u ON p.id_usuario = u.id_usuario
INNER JOIN libros l ON p.id_libro = l.id_libro
INNER JOIN autores a ON l.id_autor = a.id_autor
INNER JOIN editoriales e ON l.id_editorial = e.id_editorial;

/*Ejemplo 7: Valoraciones con usuario y libro*/
SELECT u.nombre_usuario, l.titulo, v.puntuacion, v.comentario FROM valoraciones v
INNER JOIN usuarios u ON v.id_usuario = u.id_usuario
INNER JOIN libros l ON v.id_libro = l.id_libro;

/*Ejemplo 8: Préstamos de libros publicados después de 2000*/
SELECT u.nombre_usuario, l.titulo, l.año_publicacion, p.fecha_prestamo FROM prestamos p
INNER JOIN usuarios u ON p.id_usuario = u.id_usuario
INNER JOIN libros l ON p.id_libro = l.id_libro
WHERE l.año_publicacion > 2000;

/*Ejemplo 9: Préstamos aún no devueltos*/
SELECT u.nombre_usuario,l.titulo,p.fecha_prestamo,p.fecha_devolucion FROM prestamos p
INNER JOIN usuarios u ON p.id_usuario = u.id_usuario
INNER JOIN libros l ON p.id_libro
WHERE p.devuelto = FALSE;

/*Ejemplo 23: Producto cartesiano simple - Usuarios × Libros*/
SELECT u.nombre_usuario, l.titulo FROM usuarios u CROSS JOIN libros l LIMIT 10;

/*Ejemplo 24: Caso práctico - Combinaciones de turnos y salas
Escenario: La biblioteca tiene 3 salas de lectura y 4 turnos horarios. Queremos generar todas las posibles combinaciones
para el planning.*/

-- Creamos tablas temporales para el ejemplo
CREATE TEMPORARY TABLE salas (
id_sala INT,
nombre_sala VARCHAR(50)
);

CREATE TEMPORARY TABLE turnos (
id_turno INT,
horario VARCHAR(20)
);
INSERT INTO salas VALUES
(1, 'Sala Cervantes'),
(2, 'Sala Borges'),
(3, 'Sala García Márquez');
INSERT INTO turnos VALUES
(1, '09:00-11:00'),
(2, '11:00-13:00'),
(3, '15:00-17:00'),
(4, '17:00-19:00');
-- CROSS JOIN para generar planning completo
SELECT s.nombre_sala, t.horario FROM salas s CROSS JOIN turnos t
ORDER BY s.nombre_sala, t.id_turno;

/*Ejemplo 25: CROSS JOIN implícito (sintaxis antigua)*/
-- Sintaxis moderna (explícita)
SELECT u.nombre_usuario, l.titulo FROM usuarios u CROSS JOIN libros l;
-- Sintaxis antigua (implícita) - SIN condición ON/WHERE
SELECT u.nombre_usuario, l.titulo FROM usuarios u, libros l;

/*Ejemplo 26: Libros del mismo autor
Objetivo: Encontrar pares de libros escritos por el mismo autor.*/
SELECT l1.titulo AS libro1, l2.titulo AS libro2, a.nombre_autor
FROM libros l1
INNER JOIN libros l2 ON l1.id_autor = l2.id_autor AND l1.id_libro < l2.id_libro
INNER JOIN autores a ON l1.id_autor = a.id_autor
ORDER BY a.nombre_autor, l1.titulo;

/*Ejemplo 27: Usuarios que leyeron el mismo libro*/
SELECT DISTINCT u1.nombre_usuario AS usuario1,
u2.nombre_usuario AS usuario2,
l.titulo AS libro_en_comun
FROM prestamos p1
INNER JOIN prestamos p2 ON p1.id_libro = p2.id_libro AND p1.id_usuario < p2.id_usuario
INNER JOIN usuarios u1 ON p1.id_usuario = u1.id_usuario
INNER JOIN usuarios u2 ON p2.id_usuario = u2.id_usuario
INNER JOIN libros l ON p1.id_libro = l.id_libro
ORDER BY l.titulo, u1.nombre_usuario;

/*Ejemplo 28: Estructura jerárquica simulada - Secciones y subsecciones de biblioteca

Escenario: La biblioteca tiene secciones (ej: «Literatura») y subsecciones (ej: «Literatura española», «Literatura latino-
americana») en la misma tabla.*/
-- Tabla con relación jerárquica (un campo apunta a su propio ID)
CREATE TEMPORARY TABLE secciones_biblioteca (
id_seccion INT PRIMARY KEY,
nombre_seccion VARCHAR(100),
id_seccion_padre INT -- apunta a secciones_biblioteca.id_seccion
);
INSERT INTO secciones_biblioteca VALUES
(1, 'Literatura', NULL),
(2, 'Literatura española', 1),
(3, 'Literatura latinoamericana', 1),
(4, 'Ciencia', NULL),
(5, 'Física', 4),
(6, 'Química', 4),
(7, 'Historia', NULL);
-- SELF JOIN: mostrar secciones padre e hijas
SELECT padre.nombre_seccion AS seccion_padre,
hija.nombre_seccion AS subseccion
FROM secciones_biblioteca padre
INNER JOIN secciones_biblioteca hija ON padre.id_seccion = hija.id_seccion_padre
ORDER BY padre.nombre_seccion, hija.nombre_seccion;

/*Ejemplo 29: Tabla de eventos y asistencias con doble clave*/
-- Escenario: eventos de biblioteca (charlas, talleres) y asistencias
CREATE TEMPORARY TABLE eventos (
fecha_evento DATE,
hora_evento TIME,
nombre_evento VARCHAR(100),
PRIMARY KEY (fecha_evento, hora_evento)
);
CREATE TEMPORARY TABLE asistencias (
fecha_evento DATE,
hora_evento TIME,
id_usuario INT,
asistio BOOLEAN
);
INSERT INTO eventos VALUES
('2024-12-01', '10:00:00', 'Taller de escritura creativa'),
('2024-12-01', '16:00:00', 'Charla: García Márquez'),
('2024-12-05', '10:00:00', 'Club de lectura');
INSERT INTO asistencias VALUES
('2024-12-01', '10:00:00', 1, TRUE),
('2024-12-01', '10:00:00', 2, TRUE),
('2024-12-01', '16:00:00', 1, FALSE),
('2024-12-05', '10:00:00', 3, TRUE);
-- JOIN con condición compuesta (2 columnas)
SELECT e.nombre_evento,
u.nombre_usuario,
a.asistio
FROM asistencias a
INNER JOIN eventos e ON a.fecha_evento = e.fecha_evento
AND a.hora_evento = e.hora_evento
INNER JOIN usuarios u ON a.id_usuario = u.id_usuario;

-- Ejemplo 30: Usuarios que se registraron el mismo mes
SELECT u1.nombre_usuario AS usuario1,
u2.nombre_usuario AS usuario2,
DATE_FORMAT(u1.fecha_registro, '%Y-%m') AS mes_registro
FROM usuarios u1
INNER JOIN usuarios u2 ON YEAR(u1.fecha_registro) = YEAR(u2.fecha_registro)
AND MONTH(u1.fecha_registro) = MONTH(u2.fecha_registro)
AND u1.id_usuario < u2.id_usuario
ORDER BY mes_registro, u1.nombre_usuario;

/*Ejemplo 31: Préstamos con rango de fechas superpuestas*/
-- Préstamos que se superponen en el tiempo (mismo libro prestado simultáneamente -␣
-- ↪ERROR de gestión)
SELECT p1.id_prestamo AS prestamo1,
p2.id_prestamo AS prestamo2,
l.titulo,
p1.fecha_prestamo AS inicio1,
p1.fecha_devolucion AS fin1,
p2.fecha_prestamo AS inicio2,
p2.fecha_devolucion AS fin2
FROM prestamos p1
INNER JOIN prestamos p2 ON p1.id_libro = p2.id_libro
AND p1.id_prestamo < p2.id_prestamo
AND p1.fecha_prestamo <= p2.fecha_devolucion
AND p2.fecha_prestamo <= p1.fecha_devolucion

INNER JOIN libros l ON p1.id_libro = l.id_libro
WHERE p1.fecha_devolucion IS NOT NULL
AND p2.fecha_devolucion IS NOT NULL;

-- Ejemplo 32: Número de préstamos por usuario
SELECT u.nombre_usuario,
COUNT(p.id_prestamo) AS total_prestamos,
COUNT(CASE WHEN p.devuelto = FALSE THEN 1 END) AS prestamos_activos
FROM usuarios u
LEFT JOIN prestamos p ON u.id_usuario = p.id_usuario
GROUP BY u.id_usuario, u.nombre_usuario
ORDER BY total_prestamos DESC;

-- Ejemplo 33: Libros más populares (por número de préstamos)
SELECT l.titulo,
a.nombre_autor,
COUNT(p.id_prestamo) AS veces_prestado,
MIN(p.fecha_prestamo) AS primer_prestamo,
MAX(p.fecha_prestamo) AS ultimo_prestamo
FROM libros l
INNER JOIN autores a ON l.id_autor = a.id_autor
LEFT JOIN prestamos p ON l.id_libro = p.id_libro
GROUP BY l.id_libro, l.titulo, a.nombre_autor
HAVING COUNT(p.id_prestamo) > 0
ORDER BY veces_prestado DESC
LIMIT 5;

-- Ejemplo 34: Autores más valorados (promedio de puntuaciones)
SELECT a.nombre_autor,
COUNT(DISTINCT l.id_libro) AS libros_publicados,
COUNT(v.id_valoracion) AS num_valoraciones,
ROUND(AVG(v.puntuacion), 2) AS puntuacion_media,
MIN(v.puntuacion) AS peor_valoracion,
MAX(v.puntuacion) AS mejor_valoracion
FROM autores a
LEFT JOIN libros l ON a.id_autor = l.id_autor
LEFT JOIN valoraciones v ON l.id_libro = v.id_libro
GROUP BY a.id_autor, a.nombre_autor
HAVING num_valoraciones > 0
ORDER BY puntuacion_media DESC, num_valoraciones DESC;

-- Ejemplo 35: Usuarios con más préstamos que el promedio
SELECT u.nombre_usuario,
COUNT(p.id_prestamo) AS total_prestamos
FROM usuarios u
INNER JOIN prestamos p ON u.id_usuario = p.id_usuario
GROUP BY u.id_usuario, u.nombre_usuario
HAVING COUNT(p.id_prestamo) > (
SELECT AVG(prestamos_por_usuario)
FROM ( SELECT COUNT(*) AS prestamos_por_usuario
FROM prestamos GROUP BY id_usuario
) AS subconsulta
)
ORDER BY total_prestamos DESC;


-- Ejemplo 36: Libros nunca prestados de autores populares
SELECT l.titulo,
a.nombre_autor,
l.año_publicacion
FROM libros l
INNER JOIN autores a ON l.id_autor = a.id_autor
INNER JOIN (
-- Autores con al menos 2 libros prestados
SELECT DISTINCT l2.id_autor
FROM prestamos p
INNER JOIN libros l2 ON p.id_libro = l2.id_libro
GROUP BY l2.id_autor
HAVING COUNT(DISTINCT p.id_libro) >= 2
) AS autores_populares ON l.id_autor = autores_populares.id_autor
LEFT JOIN prestamos p ON l.id_libro = p.id_libro
WHERE p.id_prestamo IS NULL;

-- Ejemplo 37: Informe completo de préstamos con todas las relaciones
SELECT u.nombre_usuario, l.titulo,
a.nombre_autor, e.nombre_editorial,
p.fecha_prestamo, p.fecha_devolucion,
DATEDIFF(COALESCE(p.fecha_devolucion, CURDATE()), p.fecha_prestamo) AS dias_prestamo,
m.importe AS multa,
v.puntuacion AS valoracion_usuario
FROM prestamos p
INNER JOIN usuarios u ON p.id_usuario = u.id_usuario
INNER JOIN libros l ON p.id_libro = l.id_libro
INNER JOIN autores a ON l.id_autor = a.id_autor
INNER JOIN editoriales e ON l.id_editorial = e.id_editorial
LEFT JOIN multas m ON p.id_prestamo = m.id_prestamo
LEFT JOIN valoraciones v ON p.id_usuario = v.id_usuario AND p.id_libro = v.id_libro
ORDER BY p.fecha_prestamo DESC;

-- Ejemplo 38: Comparación de técnicas de conteo
SELECT u.nombre_usuario,
COUNT(*) AS filas_totales, -- cuenta TODAS las filas (incluye NULL)
COUNT(p.id_prestamo) AS prestamos_reales, -- cuenta solo préstamos(excluye NULL)
COUNT(DISTINCT p.id_libro) AS libros_diferentes,
SUM(CASE WHEN p.devuelto = FALSE THEN 1 ELSE 0 END) AS activos
FROM usuarios u
LEFT JOIN prestamos p ON u.id_usuario = p.id_usuario
GROUP BY u.id_usuario, u.nombre_usuario;

-- Ejemplo 39: Libros con valoración promedio (incluyendo libros sin valoraciones)
SELECT l.titulo,
COUNT(v.id_valoracion) AS num_valoraciones,
ROUND(AVG(v.puntuacion), 2) AS puntuacion_media,
CASE
WHEN COUNT(v.id_valoracion) = 0 THEN 'Sin valorar'
WHEN AVG(v.puntuacion) >= 4.5 THEN 'Excelente'
WHEN AVG(v.puntuacion) >= 3.5 THEN 'Bueno'
ELSE 'Regular'
END AS categoria
FROM libros l
LEFT JOIN valoraciones v ON l.id_libro = v.id_libro
GROUP BY l.id_libro, l.titulo
ORDER BY num_valoraciones DESC, puntuacion_media DESC;