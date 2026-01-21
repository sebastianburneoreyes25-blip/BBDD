-- Ejercicio 29: Dashboard completo de un usuario: préstamos totales, activos, multas, valoraciones dadas.
SELECT u.nombre_usuario, COUNT(p.id_prestamo) AS prestramos_totales, COUNT(CASE WHEN p.devuelto=FALSE THEN 1 ELSE 0 END) AS prestamos_activos, 
COUNT(m.id_multa) AS cantidad_multas, COUNT(v.id_valoracion) AS	valoraciones_dadas
FROM usuarios u LEFT JOIN prestamos p ON p.id_usuario=u.id_usuario LEFT JOIN multas m ON m.id_prestamo=p.id_prestamo 
INNER JOIN valoraciones v ON v.id_usuario=u.id_usuario
GROUP BY u.id_usuario;

-- Ejercicio 30: Análisis de «afinidad» de usuarios: usuarios con gustos similares basados en valoraciones comunes.
SELECT u.nombre_usuario, u2.nombre_usuario, COUNT(v.id_libro) AS libros_comun, ROUND(AVG(v.puntuacion-v2.puntuacion),2) AS diferencia_promedio FROM valoraciones v 
INNER JOIN valoraciones v2 ON v.id_libro=v2.id_libro AND v.id_usuario<v2.id_usuario
INNER JOIN usuarios u ON v.id_usuario=u.id_usuario
INNER JOIN usuarios u2 ON u2.id_usuario=v2.id_usuario
GROUP BY u.id_usuario,u2.id_usuario;

-- Ejercicio 32: Detectar préstamos sospechosos: mismo libro prestado a múltiples usuarios en fechas superpuestas.
SELECT l.titulo, p1.id_prestamo AS prestamo1, p2.id_prestamo AS prestamo2, p1.fecha_prestamo AS fechaPrestamo1, p1.fecha_devolucion AS devolucion1, p2.fecha_prestamo AS fechaPrestamo2, 
DATEDIFF( LEAST(COALESCE(p1.fecha_devolucion, CURDATE()), COALESCE(p2.fecha_devolucion, CURDATE())), GREATEST(p1.fecha_prestamo, p2.fecha_prestamo) ) AS dias_solapados
FROM prestamos p1 INNER JOIN prestamos p2 ON p1.id_libro=p2.id_libro AND p1.fecha_prestamo<p2.fecha_prestamo AND p1.id_prestamo<p2.id_prestamo 
AND p1.fecha_devolucion<=COALESCE(p2.fecha_devolucion, CURDATE()) INNER JOIN libros l ON p1.id_libro=l.id_libro;
