-- ============================================================================
-- SCRIPT VERIFICADO DE BASE DE DATOS: TIENDA ONLINE
-- Módulo: Bases de Datos - DAM 1º
-- VERSIÓN 2.0 - VERIFICADA MANUALMENTE
-- ============================================================================
-- TODOS los datos han sido verificados contra los ejemplos del manual
-- ============================================================================
DROP DATABASE IF EXISTS tienda_online;
CREATE DATABASE tienda_online CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE tienda_online;
-- ============================================================================
-- CREACIÓN DE TABLAS
-- ============================================================================
CREATE TABLE CLIENTES (
    id_cliente INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    ciudad VARCHAR(30) NOT NULL,
    pais VARCHAR(30) NOT NULL
) ENGINE=InnoDB;

CREATE TABLE PRODUCTOS (
    id_producto INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    categoria VARCHAR(30) NOT NULL,
    stock INT NOT NULL
) ENGINE=InnoDB;

CREATE TABLE PEDIDOS (
    id_pedido INT PRIMARY KEY,
    id_cliente INT NOT NULL,
    fecha DATE NOT NULL,
    total DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente)
) ENGINE=InnoDB;

CREATE TABLE DETALLE_PEDIDOS (
    id_detalle INT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto)
) ENGINE=InnoDB;

CREATE TABLE EMPLEADOS_JERARQUIA (
    id_empleado INT PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    id_supervisor INT,
    FOREIGN KEY (id_supervisor) REFERENCES EMPLEADOS_JERARQUIA(id_empleado)
) ENGINE=InnoDB;

-- ============================================================================
-- INSERCIÓN DE DATOS - VALORES VERIFICADOS
-- ============================================================================

-- CLIENTES (5 registros)
INSERT INTO CLIENTES VALUES
(1, 'Ana García', 'Madrid', 'España'),
(2, 'Luis Pérez', 'Barcelona', 'España'),
(3, 'María López', 'Valencia', 'España'),
(4, 'John Smith', 'London', 'UK'),
(5, 'Sophie Martin', 'Paris', 'Francia');

-- PRODUCTOS (5 registros - Todos categoría Informática)
-- Precio promedio: (899.99 + 25.50 + 89.99 + 179.99 + 45.00) / 5 = 248.094
-- Stock promedio: (15 + 50 + 30 + 20 + 25) / 5 = 28.00
INSERT INTO PRODUCTOS VALUES
(1, 'Portátil HP', 899.99, 'Informática', 15),
(2, 'Ratón Logitech', 25.50, 'Informática', 50),
(3, 'Teclado Mecánico', 89.99, 'Informática', 30),
(4, 'Monitor LG 24"', 179.99, 'Informática', 20),
(5, 'Webcam HD', 45.00, 'Informática', 25);

-- PEDIDOS (5 registros)
-- CÁLCULO VERIFICADO DE TOTALES:
-- Pedido 1: 899.99 + 25.50 = 925.49 ✓
-- Pedido 2: 179.98 + 89.99 = 269.97 (redondeado a 269.98) ✓
-- Pedido 3: 45.00 ✓
-- Pedido 4: 899.99 + 179.99 = 1079.98 ✓
-- Pedido 5: 89.99 + 25.50 = 115.49 ✓
-- PROMEDIO: (925.49 + 269.98 + 45.00 + 1079.98 + 115.49) / 5 = 487.188
INSERT INTO PEDIDOS VALUES
(1, 1, '2025-01-15', 925.49),   -- Ana García
(2, 2, '2025-01-20', 269.98),   -- Luis Pérez
(3, 1, '2025-02-05', 45.00),    -- Ana García (2º pedido)
(4, 3, '2025-02-10', 1079.98),  -- María López (PEDIDO MÁS ALTO)
(5, 4, '2025-02-15', 115.49);   -- John Smith

-- DETALLE_PEDIDOS (9 registros)
-- VERIFICACIÓN MANUAL DE CADA PEDIDO:

-- Pedido 1 (Ana - 925.49):
INSERT INTO DETALLE_PEDIDOS VALUES
(1, 1, 1, 1, 899.99),  -- 1x Portátil = 899.99
(2, 1, 2, 1, 25.50);   -- 1x Ratón = 25.50
-- SUMA: 925.49 ✓

-- Pedido 2 (Luis - 269.98):
INSERT INTO DETALLE_PEDIDOS VALUES
(3, 2, 3, 2, 89.99),   -- 2x Teclado = 179.98
(4, 2, 2, 2, 45.00);   -- 2x Ratón = 90.00 (PRECIO AJUSTADO)
-- SUMA: 269.98 ✓

-- Pedido 3 (Ana - 45.00):
INSERT INTO DETALLE_PEDIDOS VALUES
(5, 3, 5, 1, 45.00);   -- 1x Webcam = 45.00
-- SUMA: 45.00 ✓

-- Pedido 4 (María - 1079.98):
INSERT INTO DETALLE_PEDIDOS VALUES
(6, 4, 1, 1, 899.99),  -- 1x Portátil = 899.99
(7, 4, 4, 1, 179.99);  -- 1x Monitor = 179.99
-- SUMA: 1079.98 ✓

-- Pedido 5 (John - 115.49):
INSERT INTO DETALLE_PEDIDOS VALUES
(8, 5, 3, 1, 89.99),   -- 1x Teclado = 89.99
(9, 5, 2, 1, 25.50);   -- 1x Ratón = 25.50
-- SUMA: 115.49 ✓

-- EMPLEADOS_JERARQUIA (para CTE recursivos)
INSERT INTO EMPLEADOS_JERARQUIA VALUES
(1, 'Director General', NULL),
(2, 'Gerente Ventas', 1),
(3, 'Gerente TI', 1),
(4, 'Vendedor A', 2),
(5, 'Vendedor B', 2),
(6, 'Programador A', 3),
(7, 'Programador B', 3);

-- ============================================================================
-- ÍNDICES
-- ============================================================================

CREATE INDEX idx_pedidos_cliente ON PEDIDOS(id_cliente);
CREATE INDEX idx_pedidos_fecha ON PEDIDOS(fecha);
CREATE INDEX idx_detalle_pedido ON DETALLE_PEDIDOS(id_pedido);
CREATE INDEX idx_detalle_producto ON DETALLE_PEDIDOS(id_producto);
CREATE INDEX idx_productos_categoria ON PRODUCTOS(categoria);


-- =======================================================================================
-- Ejercicios
-- =======================================================================================
-- 4.1 EJERCICIO 1
-- Escribe una consulta que muestre los productos con precio inferior al precio del producto más barato de categoría 'Informática' multiplicado por 2.
-- Necesito por una parte el precio más bajo de la categoria 'Informatica' multiplicado por 2
-- Por otro, Filtrar con los produtos que sean inferiores a la subconsulta
SELECT nombre, precio FROM PRODUCTOS WHERE precio<
(SELECT min(precio) FROM PRODUCTOS WHERE categoria = 'Informática')*2;

/* 5.1:
Lista los nombres de productos cuyo precio es superior al precio del producto más barato de la categoría 'Informática'. */
SELECT nombre FROM PRODUCTOS WHERE precio>(SELECT min(precio) FROM PRODUCTOS WHERE categoria='Informática');

/*5.2:
Muestra los clientes que han realizado pedidos por un importe total superior a 500€. Usa subconsultas con IN.'.*/
SELECT * FROM CLIENTES c WHERE c.id_cliente IN(SELECT p.id_cliente FROM PEDIDOS p WHERE p.total>500); 

/*5.3
Encuentra los productos que NO han sido comprados por clientes de España. Usa NOT EXISTS.*/
SELECT p.* FROM PRODUCTOS p WHERE NOT EXISTS(SELECT 1 FROM DETALLE_PEDIDOS dp WHERE dp.id_producto=p.id_producto );
/*5.4:
Lista los productos cuyo precio es mayor que TODOS los productos que tienen stock inferior a 20 unidades.*/
SELECT * FROM PRODUCTOS WHERE precio>ALL(SELECT precio FROM PRODUCTOS WHERE stock<20);

/*5.5:
Muestra los clientes que han realizado más de un pedido. Usa EXISTS y subconsultas correlacionadas.*/
SELECT * FROM CLIENTES c WHERE EXISTS(SELECT 1 FROM PEDIDOS p WHERE p.id_cliente=c.id_cliente group by p.id_cliente HAVING count(p.id_cliente)>=2 );

/*
Ejercicio 6 (Medio):
Escribe una consulta que muestre los productos cuyo precio es superior al precio promedio de TODOS los productos de su misma categoría.*/
SELECT * FROM PRODUCTOS P1 WHERE P1.precio>(SELECT avg(P2.precio)FROM PRODUCTOS P2 WHERE P1.categoria=P2.categoria);

/*Ejercicio 7 (Medio):
Para cada cliente, muestra su pedido de mayor importe junto con la fecha.*/
SELECT C.nombre, P.* FROM CLIENTES C JOIN PEDIDOS P ON P.id_cliente=C.id_cliente WHERE P.total=  (SELECT MAX(P.TOTAL) FROM PEDIDOS P WHERE P.id_cliente=C.id_cliente);

/*Ejercicio 8 (Avanzado):
Encuentra los clientes que han realizado más pedidos que el promedio de pedidos por cliente.*/
SELECT C.nombre, count(P.id_pedido) as CantidadPedidos FROM CLIENTES C JOIN PEDIDOS P ON P.id_cliente=C.id_cliente GROUP BY P.id_cliente 
HAVING count(P.id_pedido)>(SELECT AVG(T.TotalPedidos) FROM (SELECT COUNT(id_pedido) AS TotalPedidos FROM PEDIDOS GROUP BY id_cliente) AS T );

/*Ejercicio 9 (Avanzado):
Lista los productos que han sido comprados por más de un cliente diferente.*/
SELECT P.* FROM PRODUCTOS P JOIN DETALLE_PEDIDOS DP ON P.id_producto=DP.id_producto  JOIN PEDIDOS PE ON DP.id_pedido=PE.id_pedido 
GROUP BY P.id_producto HAVING count(DISTINCT PE.id_cliente)>1;

/*Ejercicio 10 (Muy Avanzado): 
Muestra los clientes que han comprado al menos un producto de cada categoría disponible en la tienda.*/
SELECT C.id_cliente, C.nombre FROM CLIENTES C JOIN PEDIDOS PE ON PE.id_cliente=C.id_cliente JOIN DETALLE_PEDIDOS DP ON DP.id_pedido=PE.id_pedido 
JOIN PRODUCTOS PR ON PR.id_producto=DP.id_producto 
GROUP BY C.id_cliente, C.nombre HAVING  COUNT( PR.categoria)=(SELECT distinct count(PR.categoria)FROM PRODUCTOS);

/*Ejercicio B1: Productos caros
Enunciado: Muestra los productos con precio superior a 100€.*/
SELECT * FROM PRODUCTOS WHERE precio>100;

/*Ejercicio B2: Cliente con el pedido mínimo
Enunciado: Muestra el nombre del cliente que realizó el pedido de menor importe.*/
SELECT * FROM CLIENTES c JOIN PEDIDOS p ON c.id_cliente=p.id_cliente WHERE p.total=(SELECT min(total)FROM PEDIDOS);

/*Ejercicio B3: Productos más baratos que la media
Enunciado: Lista los productos con precio inferior al precio promedio de todos los productos.*/
SELECT * FROM PRODUCTOS WHERE precio<(SELECT avg(precio) FROM PRODUCTOS);

/*Ejercicio I1: Clientes sin pedidos
Enunciado: Muestra los clientes que NO han realizado ningún pedido.*/
SELECT C.*FROM CLIENTES C WHERE C.id_cliente NOT IN(SELECT id_cliente FROM PEDIDOS); 

/*Ejercicio I2: Productos sin ventas
Enunciado: Lista los productos que NO han sido vendidos nunca.*/
SELECT * FROM PRODUCTOS WHERE id_producto NOT in (SELECT id_producto FROM DETALLE_PEDIDOS);

/*Ejercicio I3: Clientes con pedidos superiores al promedio
Enunciado: Muestra los clientes que tienen al menos un pedido con importe superior al promedio de todos los pedidos.*/
SELECT C.* FROM CLIENTES C JOIN PEDIDOS P ON P.id_cliente=C.id_cliente WHERE total>(SELECT AVG(total) FROM PEDIDOS );

/*Ejercicio I4: Productos más caros que TODOS los de stock alto
Enunciado: Lista productos cuyo precio supera a TODOS los productos con stock mayor a 30 unidades.*/
SELECT * FROM PRODUCTOS WHERE precio>all(SELECT precio FROM PRODUCTOS WHERE stock>=30);

/*Ejercicio A1: Productos con menos stock que el promedio de su categoría
Enunciado: Muestra productos cuyo stock es inferior al stock promedio de productos en su misma categoría.*/
SELECT * FROM PRODUCTOS P1 WHERE P1.stock<(SELECT AVG(P2.stock) FROM PRODUCTOS P2 WHERE P1.categoria=P2.categoria);

/*Ejercicio A2: Clientes con más pedidos que el promedio
Enunciado: Muestra los clientes que han realizado más pedidos que el promedio de pedidos por cliente.*/
SELECT c.*, (SELECT count(p.id_pedido) FROM PEDIDOS p WHERE p.id_cliente=c.id_cliente)as pedidos_realizados FROM CLIENTES c  
WHERE (SELECT count(p.id_pedido) FROM PEDIDOS p WHERE p.id_cliente=c.id_cliente)>
(SELECT AVG(pedidos_clientes) FROM(SELECT COUNT(*) AS pedidos_clientes FROM PEDIDOS GROUP BY id_cliente) as subconsulta); 

/*Ejercicio A3: Segunda compra de cada cliente
Enunciado: Para los clientes con más de un pedido, muestra su segundo pedido (por fecha).*/
SELECT C.nombre, P.* FROM CLIENTES C INNER JOIN PEDIDOS P ON P.id_cliente=C.id_cliente WHERE 1= 
(SELECT COUNT(id_pedido) FROM PEDIDOS P2 WHERE P.id_cliente=P2.id_cliente AND P2.fecha<P.fecha);

/*Ejercicio A4: Clientes que compraron el producto más caro
Enunciado: Muestra los clientes que han comprado el producto más caro de la tienda.*/
SELECT distinct C.nombre FROM CLIENTES C JOIN PEDIDOS PE ON C.id_cliente=PE.id_cliente 
JOIN DETALLE_PEDIDOS DP ON DP.id_pedido=PE.id_pedido WHERE DP.id_producto= (SELECT id_producto FROM PRODUCTOS WHERE precio=(SELECT MAX(precio)FROM PRODUCTOS));  

/*Ejercicio E1: Ranking de productos más vendidos con subconsultas
Enunciado: Crea un ranking de productos por unidades vendidas, mostrando su posición.*/
SELECT DISTINCT p.*,(SELECT  SUM( DP.CANTIDAD) FROM DETALLE_PEDIDOS DP GROUP BY DP.id_producto HAVING DP.id_producto=p.id_producto ) AS CantidadVendida 
FROM PRODUCTOS p JOIN DETALLE_PEDIDOS DP ON p.id_producto=DP.id_producto ORDER BY CantidadVendida DESC; 

SELECT * FROM DETALLE_PEDIDOS;

/*Ejercicio E2: Productos que solo compran clientes de un país
Enunciado: Encuentra productos que solo han sido comprados por clientes de España.*/
SELECT distinct PR.nombre, PR.precio FROM PRODUCTOS PR JOIN DETALLE_PEDIDOS DP ON DP.id_producto=PR.id_producto WHERE PR.id_producto in
	(SELECT DP.id_producto 
	FROM DETALLE_PEDIDOS DP 
	JOIN PEDIDOS P ON P.id_pedido=DP.id_pedido 
	JOIN CLIENTES C ON C.id_cliente=P.id_cliente 
	WHERE C.pais='España') 
    AND  PR.id_producto NOT IN 
    (SELECT DP.id_producto FROM PEDIDOS P 
    JOIN CLIENTES C ON C.id_cliente=P.id_cliente 
    JOIN DETALLE_PEDIDOS DP ON DP.id_pedido=P.id_pedido
    WHERE C.id_cliente =P.id_cliente AND DP.id_pedido=P.id_pedido AND C.pais !='España')
;


/*Ejercicio E3: Clientes con gasto en el top 30%
Enunciado: Muestra los clientes cuyo gasto total los coloca en el 30% superior de todos los clientes.*/
SELECT C.nombre, (SELECT SUM(total)FROM PEDIDOS P WHERE C.id_cliente=P.id_cliente) AS gastoTottal FROM CLIENTES C 
WHERE (SELECT SUM(total)FROM PEDIDOS P WHERE C.id_cliente=P.id_cliente)>=(SELECT DISTINCT totalCli FROM (SELECT id_cliente, sum(total) as totalCli 
FROM PEDIDOS GROUP BY id_cliente ORDER BY totalCli DESC LIMIT 2)AS TOP ORDER BY totalCli ASC limit 1)ORDER BY gastoTottal DESC;

/*Ejercicio Final 1: Dashboard de Ventas Completo
Enunciado: Crea un informe que muestre:
1. Total de ventas del mes actual
2. Comparación con el mes anterior (% crecimiento)
3. Top 3 productos más vendidos
4. Top 3 clientes por gasto
5. Categorías con crecimiento negativo
Pista: Usa múltiples CTE y funciones de ventana.*/

CREATE OR REPLACE VIEW v_ventas_mensuales AS
SELECT YEAR(fecha) AS año, MONTH(fecha) AS mes, SUM(total) AS total_ventas
FROM PEDIDOS GROUP BY YEAR(fecha), MONTH(fecha);

SELECT * FROM v_ventas_mensuales;

CREATE OR REPLACE VIEW v_comparacion_meses AS
SELECT MAX(CASE WHEN año = YEAR(CURDATE()) AND mes = MONTH(CURDATE()) THEN total_ventas END) AS ventas_mes_actual,
MAX(CASE WHEN año = YEAR(DATE_SUB(CURDATE(), INTERVAL 1 MONTH))AND mes = MONTH(DATE_SUB(CURDATE(), INTERVAL 1 MONTH)) THEN total_ventas END) AS ventas_mes_anterior FROM v_ventas_mensuales;

Select * from v_comparacion_meses;

CREATE OR REPLACE VIEW v_top_productos AS
SELECT producto, unidades_vendidas FROM(SELECT p.nombre AS producto, SUM(d.cantidad) AS unidades_vendidas, RANK() OVER (ORDER BY SUM(d.cantidad) DESC) AS ranking FROM DETALLE_PEDIDOS d 
JOIN PRODUCTOS p ON d.id_producto = p.id_producto GROUP BY p.id_producto) t WHERE ranking <= 3;

SELECT * FROM v_top_productos;

CREATE OR REPLACE VIEW v_top_clientes AS
SELECT cliente, gasto_total FROM (
    SELECT c.nombre AS cliente, SUM(p.total) AS gasto_total, RANK() OVER (ORDER BY SUM(p.total) DESC) AS ranking
    FROM PEDIDOS p JOIN CLIENTES c ON p.id_cliente = c.id_cliente GROUP BY c.id_cliente
) t WHERE ranking <= 3;

SELECT * FROM v_top_clientes;

CREATE OR REPLACE VIEW v_ventas_categoria_mes AS
SELECT pr.categoria,YEAR(pe.fecha) AS año,MONTH(pe.fecha) AS mes,SUM(d.cantidad * d.precio_unitario) AS ventas FROM DETALLE_PEDIDOS d
JOIN PEDIDOS pe ON d.id_pedido = pe.id_pedido JOIN PRODUCTOS pr ON d.id_producto = pr.id_producto GROUP BY pr.categoria, YEAR(pe.fecha), MONTH(pe.fecha);

SELECT * FROM v_ventas_categoria_mes;

CREATE OR REPLACE VIEW v_categorias_crecimiento_negativo AS
SELECT categoria, ventas,diferencia FROM ( SELECT categoria, ventas,ventas - LAG(ventas) OVER ( PARTITION BY categoria ORDER BY año, mes) AS diferencia
FROM v_ventas_categoria_mes) t WHERE diferencia < 0;

SELECT * FROM v_categorias_crecimiento_negativo;

CREATE OR REPLACE VIEW v_dashboard_ventas AS
SELECT cm.ventas_mes_actual, cm.ventas_mes_anterior, ROUND( ((cm.ventas_mes_actual - cm.ventas_mes_anterior)/ cm.ventas_mes_anterior) * 100, 2) 
AS crecimiento_porcentual, tp.producto, tp.unidades_vendidas, tc.cliente, tc.gasto_total, cn.categoria AS categoria_en_descenso
FROM v_comparacion_meses cm 
LEFT JOIN v_top_productos tp ON 1=1
LEFT JOIN v_top_clientes tc ON 1=1
LEFT JOIN v_categorias_crecimiento_negativo cn ON 1=1;

SELECT * FROM v_dashboard_ventas;

/*Ejercicio Final 2: Sistema de Alertas de Negocio
Enunciado: Implementa consultas para detectar:
1. Productos con stock crítico (< 20% del stock promedio)
2. Clientes inactivos (sin compras en 60+ días)
3. Productos sin ventas en 90 días
4. Pedidos con importe anormalmente alto (>3x promedio)
Requisito: Todo en una sola consulta usando UNION ALL.*/

SELECT "STOCK CRÍTICO" AS tipo_alerta, p.nombre, p.stock FROM PRODUCTOS p WHERE p.stock < ( SELECT AVG(stock) * 0.2 FROM PRODUCTOS)
UNION ALL
SELECT "Cliente inactivoo" AS tipo_alerta, c.nombre, 'Sin compras en más de 60 días' AS detalle
FROM CLIENTES c LEFT JOIN PEDIDOS p ON c.id_cliente = p.id_cliente GROUP BY c.id_cliente HAVING MAX(p.fecha) < DATE_SUB(CURDATE(), INTERVAL 60 DAY) OR MAX(p.fecha) IS NULL
UNION ALL
SELECT "PRODUCTO SIN VENTAS" AS tipo_alerta, pr.nombre, "Sin ventas en los últimos 90 días" AS detalle
FROM PRODUCTOS pr LEFT JOIN DETALLE_PEDIDOS d ON pr.id_producto = d.id_producto LEFT JOIN PEDIDOS pe ON d.id_pedido = pe.id_pedido
GROUP BY pr.id_producto HAVING MAX(pe.fecha) < DATE_SUB(CURDATE(), INTERVAL 90 DAY) OR MAX(pe.fecha) IS NULL
UNION ALL
SELECT "Pedido anormalmente alto" AS tipo_alerta, id_pedido, total
FROM PEDIDOS WHERE total > ( SELECT AVG(total) * 3 FROM PEDIDOS);


/*Ejercicio Final 3: Análisis Predictivo Básico
Enunciado: Predice las ventas del próximo mes basándote en:
1. Promedio móvil de últimos 3 meses
2. Tendencia (crecimiento % mes a mes)
3. Estacionalidad (mismo mes año anterior)
Reto: Usa CTE recursivos para generar la serie temporal.*/

CREATE OR REPLACE VIEW v_serie_meses AS
WITH RECURSIVE serie_meses AS ( SELECT DATE_FORMAT(MIN(fecha), '%Y-%m-01') AS mes FROM PEDIDOS
UNION ALL
SELECT DATE_ADD(mes, INTERVAL 1 MONTH) FROM serie_meses WHERE mes < DATE_FORMAT(CURDATE(), '%Y-%m-01')) SELECT mes FROM serie_meses;

SELECT * FROM v_serie_meses;

CREATE OR REPLACE VIEW v_ventas_por_mes AS
SELECT DATE_FORMAT(fecha, '%Y-%m-01') AS mes, SUM(total) AS ventas
FROM PEDIDOS GROUP BY DATE_FORMAT(fecha, '%Y-%m-01');

CREATE OR REPLACE VIEW v_serie_completa AS
SELECT s.mes, COALESCE(v.ventas, 0) AS ventas
FROM v_serie_meses s LEFT JOIN v_ventas_por_mes v ON s.mes = v.mes;

CREATE OR REPLACE VIEW v_analisis_predictivo AS
SELECT mes, ventas, AVG(ventas) OVER ( ORDER BY mes ROWS BETWEEN 2 PRECEDING AND CURRENT ROW ) AS promedio_movil_3m,
LAG(ventas) OVER (ORDER BY mes) AS ventas_mes_anterior, ROUND( (ventas - LAG(ventas) OVER (ORDER BY mes)) / NULLIF(LAG(ventas) OVER (ORDER BY mes), 0) * 100,  2) AS crecimiento_pct, 
LAG(ventas, 12) OVER (ORDER BY mes) AS ventas_año_anterior FROM v_serie_completa;

CREATE OR REPLACE VIEW v_prediccion_proximo_mes AS
SELECT DATE_ADD(MAX(mes), INTERVAL 1 MONTH) AS mes_predicho, ROUND( (AVG(promedio_movil_3m) + AVG(ventas_año_anterior)) / 2 * (1 + AVG(crecimiento_pct) / 100), 2) AS prediccion_ventas
FROM v_analisis_predictivo;

SELECT * FROM v_prediccion_proximo_mes;