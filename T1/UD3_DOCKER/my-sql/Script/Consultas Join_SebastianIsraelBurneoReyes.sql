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