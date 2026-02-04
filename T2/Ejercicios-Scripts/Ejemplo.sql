-- =============================================
-- BASE DE DATOS TECHSTORE - PostgreSQL
-- Actividad Evaluable RA3: Control de Acceso
-- =============================================
-- INSTRUCCIONES:
-- 1. Conectar a PostgreSQL como superusuario (postgres)
-- 2. Ejecutar este script completo
-- =============================================

-- Eliminar la base de datos si existe (desconectar sesiones activas)
DROP DATABASE IF EXISTS techstore;


-- Crear la base de datos
-- NOTA: En Windows, usar la configuración por defecto (sin LC_COLLATE/LC_CTYPE)
-- En Linux/Mac con locale español: descomentar las líneas de LC_COLLATE y LC_CTYPE
CREATE DATABASE techstore
    WITH ENCODING = 'UTF8';
    -- LC_COLLATE = 'es_ES.UTF-8'
    -- LC_CTYPE = 'es_ES.UTF-8'
    -- TEMPLATE = template0;

-- Conectar a la base de datos techstore
\c techstore

-- =============================================
-- CREACIÓN DE TABLAS
-- =============================================

-- Tabla: departamentos
CREATE TABLE departamentos (
    id_dept SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    ubicacion VARCHAR(100),
    presupuesto DECIMAL(12, 2) DEFAULT 0.00,
    fecha_creacion DATE DEFAULT CURRENT_DATE
);

COMMENT ON TABLE departamentos IS 'Departamentos de la empresa TechStore';
COMMENT ON COLUMN departamentos.presupuesto IS 'Dato sensible: presupuesto anual del departamento';

-- Tabla: empleados
CREATE TABLE empleados (
    id_emp SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    fecha_contratacion DATE NOT NULL DEFAULT CURRENT_DATE,
    salario DECIMAL(10, 2) NOT NULL,
    id_dept INTEGER REFERENCES departamentos(id_dept) ON DELETE SET NULL,
    activo BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE empleados IS 'Personal de la empresa TechStore';
COMMENT ON COLUMN empleados.salario IS 'Dato sensible: salario mensual del empleado';

-- Tabla: productos
CREATE TABLE productos (
    id_prod SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    precio DECIMAL(10, 2) NOT NULL CHECK (precio >= 0),
    coste DECIMAL(10, 2) NOT NULL CHECK (coste >= 0),
    categoria VARCHAR(50) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0 CHECK (stock >= 0),
    stock_minimo INTEGER DEFAULT 5,
    fecha_alta DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE productos IS 'Catálogo de productos de TechStore';
COMMENT ON COLUMN productos.coste IS 'Dato interno: coste de adquisición (no visible para ventas)';

-- Tabla: clientes
CREATE TABLE clientes (
    id_cliente SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    telefono VARCHAR(15),
    direccion VARCHAR(200),
    ciudad VARCHAR(50),
    codigo_postal VARCHAR(10),
    fecha_registro DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE clientes IS 'Clientes de TechStore';
COMMENT ON COLUMN clientes.direccion IS 'Dato sensible: dirección personal del cliente';
COMMENT ON COLUMN clientes.telefono IS 'Dato sensible: teléfono personal del cliente';

-- Tabla: pedidos
CREATE TABLE pedidos (
    id_pedido SERIAL PRIMARY KEY,
    id_cliente INTEGER NOT NULL REFERENCES clientes(id_cliente),
    id_empleado INTEGER REFERENCES empleados(id_emp),
    fecha_pedido TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    fecha_envio TIMESTAMP,
    estado VARCHAR(20) DEFAULT 'pendiente' CHECK (estado IN ('pendiente', 'procesando', 'enviado', 'entregado', 'cancelado')),
    total DECIMAL(12, 2) DEFAULT 0.00,
    observaciones TEXT
);

COMMENT ON TABLE pedidos IS 'Pedidos realizados por los clientes';

-- Tabla: detalle_pedidos
CREATE TABLE detalle_pedidos (
    id_detalle SERIAL PRIMARY KEY,
    id_pedido INTEGER NOT NULL REFERENCES pedidos(id_pedido) ON DELETE CASCADE,
    id_prod INTEGER NOT NULL REFERENCES productos(id_prod),
    cantidad INTEGER NOT NULL CHECK (cantidad > 0),
    precio_unitario DECIMAL(10, 2) NOT NULL,
    subtotal DECIMAL(12, 2) GENERATED ALWAYS AS (cantidad * precio_unitario) STORED
);

COMMENT ON TABLE detalle_pedidos IS 'Líneas de detalle de cada pedido';

-- Tabla: nominas (CONFIDENCIAL)
CREATE TABLE nominas (
    id_nomina SERIAL PRIMARY KEY,
    id_emp INTEGER NOT NULL REFERENCES empleados(id_emp) ON DELETE CASCADE,
    mes INTEGER NOT NULL CHECK (mes BETWEEN 1 AND 12),
    anio INTEGER NOT NULL CHECK (anio >= 2020),
    salario_base DECIMAL(10, 2) NOT NULL,
    complementos DECIMAL(10, 2) DEFAULT 0.00,
    deducciones DECIMAL(10, 2) DEFAULT 0.00,
    irpf DECIMAL(5, 2) DEFAULT 15.00,
    seguridad_social DECIMAL(10, 2) DEFAULT 0.00,
    neto DECIMAL(10, 2),
    fecha_pago DATE,
    pagada BOOLEAN DEFAULT FALSE,
    UNIQUE(id_emp, mes, anio)
);

COMMENT ON TABLE nominas IS 'CONFIDENCIAL: Nóminas mensuales de los empleados';

-- Tabla: proveedores
CREATE TABLE proveedores (
    id_proveedor SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(100),
    email VARCHAR(100),
    telefono VARCHAR(15),
    direccion VARCHAR(200),
    ciudad VARCHAR(50),
    activo BOOLEAN DEFAULT TRUE
);

COMMENT ON TABLE proveedores IS 'Proveedores de TechStore';

-- Tabla: stock_movimientos (Auditoría de stock)
CREATE TABLE stock_movimientos (
    id_movimiento SERIAL PRIMARY KEY,
    id_prod INTEGER NOT NULL REFERENCES productos(id_prod),
    tipo_movimiento VARCHAR(20) NOT NULL CHECK (tipo_movimiento IN ('entrada', 'salida', 'ajuste')),
    cantidad INTEGER NOT NULL,
    stock_anterior INTEGER NOT NULL,
    stock_nuevo INTEGER NOT NULL,
    motivo VARCHAR(200),
    id_empleado INTEGER REFERENCES empleados(id_emp),
    fecha_movimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE stock_movimientos IS 'Registro de auditoría de movimientos de stock';

-- =============================================
-- ÍNDICES PARA MEJORAR RENDIMIENTO
-- =============================================

CREATE INDEX idx_empleados_dept ON empleados(id_dept);
CREATE INDEX idx_productos_categoria ON productos(categoria);
CREATE INDEX idx_pedidos_cliente ON pedidos(id_cliente);
CREATE INDEX idx_pedidos_empleado ON pedidos(id_empleado);
CREATE INDEX idx_pedidos_estado ON pedidos(estado);
CREATE INDEX idx_pedidos_fecha ON pedidos(fecha_pedido);
CREATE INDEX idx_nominas_empleado ON nominas(id_emp);
CREATE INDEX idx_stock_mov_prod ON stock_movimientos(id_prod);
CREATE INDEX idx_stock_mov_fecha ON stock_movimientos(fecha_movimiento);

-- =============================================
-- INSERCIÓN DE DATOS DE EJEMPLO
-- =============================================

-- Departamentos
INSERT INTO departamentos (nombre, ubicacion, presupuesto) VALUES
('Ventas', 'Planta 1 - Zona A', 150000.00),
('Almacén', 'Nave Industrial', 80000.00),
('Recursos Humanos', 'Planta 2 - Zona B', 120000.00),
('Gerencia', 'Planta 3 - Dirección', 250000.00),
('Auditoría', 'Planta 2 - Zona C', 60000.00),
('Informática', 'Planta 1 - Zona B', 200000.00);

-- Empleados
INSERT INTO empleados (nombre, apellidos, email, telefono, fecha_contratacion, salario, id_dept) VALUES
('Ana', 'García López', 'ana.garcia@techstore.es', '612345678', '2022-03-15', 2200.00, 1),
('Carlos', 'Martínez Ruiz', 'carlos.martinez@techstore.es', '623456789', '2021-06-01', 2000.00, 2),
('María', 'Fernández Sánchez', 'maria.fernandez@techstore.es', '634567890', '2020-09-10', 2800.00, 3),
('Pedro', 'López Hernández', 'pedro.lopez@techstore.es', '645678901', '2019-01-20', 4500.00, 4),
('Laura', 'Sánchez Díaz', 'laura.sanchez@techstore.es', '656789012', '2023-02-01', 2400.00, 5),
('David', 'Rodríguez Pérez', 'david.rodriguez@techstore.es', '667890123', '2022-07-15', 2100.00, 1),
('Elena', 'Gómez Torres', 'elena.gomez@techstore.es', '678901234', '2021-11-20', 1900.00, 2),
('Javier', 'Díaz Moreno', 'javier.diaz@techstore.es', '689012345', '2023-05-10', 3200.00, 6),
('Carmen', 'Moreno Jiménez', 'carmen.moreno@techstore.es', '690123456', '2020-04-01', 2500.00, 3),
('Miguel', 'Jiménez Navarro', 'miguel.jimenez@techstore.es', '601234567', '2022-01-10', 2000.00, 2);

-- Productos
INSERT INTO productos (nombre, descripcion, precio, coste, categoria, stock, stock_minimo) VALUES
('Portátil HP Pavilion 15', 'Portátil 15.6" Intel i5, 8GB RAM, 512GB SSD', 699.99, 520.00, 'Portátiles', 25, 5),
('Portátil Lenovo ThinkPad', 'Portátil empresarial 14" Intel i7, 16GB RAM', 1199.99, 890.00, 'Portátiles', 15, 3),
('Monitor Samsung 27"', 'Monitor LED 27" Full HD, 75Hz', 249.99, 180.00, 'Monitores', 40, 10),
('Monitor LG UltraWide 34"', 'Monitor curvo 34" WQHD, 144Hz', 549.99, 400.00, 'Monitores', 12, 3),
('Teclado Logitech MX Keys', 'Teclado inalámbrico retroiluminado', 119.99, 75.00, 'Periféricos', 60, 15),
('Ratón Logitech MX Master 3', 'Ratón ergonómico inalámbrico', 99.99, 60.00, 'Periféricos', 80, 20),
('Webcam Logitech C920', 'Webcam Full HD 1080p', 79.99, 50.00, 'Periféricos', 35, 10),
('Auriculares Sony WH-1000XM4', 'Auriculares Bluetooth con cancelación de ruido', 299.99, 210.00, 'Audio', 20, 5),
('Disco SSD Samsung 1TB', 'SSD NVMe M.2, lectura 3500MB/s', 129.99, 85.00, 'Almacenamiento', 50, 15),
('Disco HDD Seagate 4TB', 'Disco duro externo USB 3.0', 99.99, 65.00, 'Almacenamiento', 30, 10),
('Router ASUS RT-AX86U', 'Router WiFi 6 Gaming, 5700Mbps', 299.99, 220.00, 'Redes', 18, 5),
('Impresora HP LaserJet Pro', 'Impresora láser monocromo, WiFi', 199.99, 140.00, 'Impresoras', 22, 5),
('Tablet Samsung Galaxy Tab S8', 'Tablet 11" 128GB WiFi', 649.99, 480.00, 'Tablets', 0, 3),
('iPad Air 2024', 'Tablet Apple 10.9" 64GB WiFi', 699.99, 550.00, 'Tablets', 8, 3),
('Memoria RAM Kingston 16GB', 'DDR4 3200MHz, kit 2x8GB', 69.99, 45.00, 'Componentes', 100, 25);

-- Clientes
INSERT INTO clientes (nombre, apellidos, email, telefono, direccion, ciudad, codigo_postal) VALUES
('Roberto', 'Alonso Vega', 'roberto.alonso@email.com', '611111111', 'Calle Mayor 15, 2º A', 'Madrid', '28001'),
('Isabel', 'Martín Blanco', 'isabel.martin@email.com', '622222222', 'Avenida Diagonal 234', 'Barcelona', '08015'),
('Francisco', 'García Ruiz', 'francisco.garcia@email.com', '633333333', 'Plaza España 8', 'Sevilla', '41001'),
('Lucía', 'Hernández López', 'lucia.hernandez@email.com', '644444444', 'Calle San Fernando 45', 'Valencia', '46001'),
('Antonio', 'Pérez Sánchez', 'antonio.perez@email.com', '655555555', 'Gran Vía 123, 5º B', 'Bilbao', '48001'),
('Marta', 'Rodríguez Gómez', 'marta.rodriguez@email.com', '666666666', 'Calle Princesa 78', 'Zaragoza', '50001'),
('José', 'Sánchez Fernández', 'jose.sanchez@email.com', '677777777', 'Paseo Marítimo 56', 'Málaga', '29001'),
('Paula', 'Díaz Torres', 'paula.diaz@email.com', '688888888', 'Avenida de la Constitución 89', 'Granada', '18001'),
('Carlos', 'López Moreno', 'carlos.lopez.cli@email.com', '699999999', 'Calle Real 34', 'Valladolid', '47001'),
('Sara', 'Gómez Jiménez', 'sara.gomez@email.com', '600000000', 'Plaza del Carmen 12', 'Murcia', '30001');

-- Proveedores
INSERT INTO proveedores (nombre, contacto, email, telefono, direccion, ciudad) VALUES
('Tech Distribución S.L.', 'Juan Ramírez', 'comercial@techdist.es', '912345678', 'Polígono Industrial Norte, Nave 5', 'Madrid'),
('Electro Import S.A.', 'María Vidal', 'pedidos@electroimport.es', '932345678', 'Zona Franca, Edificio B', 'Barcelona'),
('Global PC Components', 'Pedro Soto', 'ventas@globalpc.es', '962345678', 'Parque Empresarial Sur, 23', 'Valencia'),
('Periféricos Online S.L.', 'Ana Ruiz', 'info@perifericosol.es', '942345678', 'Centro Logístico, Módulo 12', 'Santander'),
('MegaStock Informática', 'David Mora', 'compras@megastock.es', '952345678', 'Polígono Guadalhorce, Nave 8', 'Málaga');

-- Pedidos
INSERT INTO pedidos (id_cliente, id_empleado, fecha_pedido, fecha_envio, estado, total, observaciones) VALUES
(1, 1, '2024-01-10 10:30:00', '2024-01-12 09:00:00', 'entregado', 1019.97, 'Entrega urgente'),
(2, 1, '2024-01-15 14:45:00', '2024-01-17 11:30:00', 'entregado', 699.99, NULL),
(3, 6, '2024-01-20 09:15:00', '2024-01-22 16:00:00', 'entregado', 369.97, 'Dejar en portería'),
(4, 1, '2024-01-25 16:00:00', '2024-01-27 10:00:00', 'enviado', 1199.99, NULL),
(5, 6, '2024-02-01 11:20:00', NULL, 'procesando', 549.99, 'Cliente preferente'),
(6, 1, '2024-02-05 13:30:00', NULL, 'pendiente', 219.98, NULL),
(7, 6, '2024-02-08 10:00:00', NULL, 'pendiente', 899.97, 'Regalo empresa'),
(8, 1, '2024-02-10 15:45:00', NULL, 'procesando', 129.99, NULL),
(9, 6, '2024-02-12 09:30:00', NULL, 'pendiente', 1399.98, 'Factura a nombre de empresa'),
(10, 1, '2024-02-14 17:00:00', NULL, 'cancelado', 299.99, 'Cliente canceló el pedido');

-- Detalle de pedidos
INSERT INTO detalle_pedidos (id_pedido, id_prod, cantidad, precio_unitario) VALUES
-- Pedido 1
(1, 1, 1, 699.99),
(1, 5, 1, 119.99),
(1, 6, 2, 99.99),
-- Pedido 2
(2, 1, 1, 699.99),
-- Pedido 3
(3, 5, 1, 119.99),
(3, 3, 1, 249.99),
-- Pedido 4
(4, 2, 1, 1199.99),
-- Pedido 5
(5, 4, 1, 549.99),
-- Pedido 6
(6, 5, 1, 119.99),
(6, 6, 1, 99.99),
-- Pedido 7
(7, 8, 3, 299.99),
-- Pedido 8
(8, 9, 1, 129.99),
-- Pedido 9
(9, 1, 2, 699.99),
-- Pedido 10
(10, 8, 1, 299.99);

-- Nóminas (CONFIDENCIAL)
INSERT INTO nominas (id_emp, mes, anio, salario_base, complementos, deducciones, irpf, seguridad_social, neto, fecha_pago, pagada) VALUES
-- Nóminas de Enero 2024
(1, 1, 2024, 2200.00, 150.00, 0.00, 15.00, 147.50, 1850.13, '2024-01-31', TRUE),
(2, 1, 2024, 2000.00, 100.00, 0.00, 14.00, 131.25, 1674.75, '2024-01-31', TRUE),
(3, 1, 2024, 2800.00, 200.00, 0.00, 18.00, 187.50, 2272.50, '2024-01-31', TRUE),
(4, 1, 2024, 4500.00, 500.00, 0.00, 24.00, 312.50, 3487.50, '2024-01-31', TRUE),
(5, 1, 2024, 2400.00, 100.00, 0.00, 16.00, 156.25, 1943.75, '2024-01-31', TRUE),
(6, 1, 2024, 2100.00, 120.00, 0.00, 15.00, 138.75, 1748.25, '2024-01-31', TRUE),
(7, 1, 2024, 1900.00, 80.00, 0.00, 13.00, 123.75, 1598.55, '2024-01-31', TRUE),
(8, 1, 2024, 3200.00, 300.00, 0.00, 20.00, 218.75, 2581.25, '2024-01-31', TRUE),
-- Nóminas de Febrero 2024
(1, 2, 2024, 2200.00, 180.00, 50.00, 15.00, 147.50, 1830.13, '2024-02-29', TRUE),
(2, 2, 2024, 2000.00, 100.00, 0.00, 14.00, 131.25, 1674.75, '2024-02-29', TRUE),
(3, 2, 2024, 2800.00, 250.00, 0.00, 18.00, 187.50, 2313.50, '2024-02-29', TRUE),
(4, 2, 2024, 4500.00, 600.00, 0.00, 24.00, 312.50, 3563.50, '2024-02-29', TRUE);

-- Movimientos de stock
INSERT INTO stock_movimientos (id_prod, tipo_movimiento, cantidad, stock_anterior, stock_nuevo, motivo, id_empleado) VALUES
(1, 'entrada', 30, 0, 30, 'Recepción inicial de mercancía', 2),
(2, 'entrada', 20, 0, 20, 'Recepción inicial de mercancía', 2),
(1, 'salida', 5, 30, 25, 'Venta a clientes', 1),
(2, 'salida', 5, 20, 15, 'Venta a clientes', 1),
(3, 'entrada', 50, 0, 50, 'Recepción inicial de mercancía', 7),
(3, 'salida', 10, 50, 40, 'Ventas del mes', 6),
(5, 'entrada', 80, 0, 80, 'Pedido proveedor Tech Distribución', 2),
(5, 'salida', 20, 80, 60, 'Ventas Enero', 1),
(9, 'entrada', 60, 0, 60, 'Recepción almacén', 7),
(9, 'salida', 10, 60, 50, 'Ventas varias', 6),
(13, 'ajuste', -8, 8, 0, 'Productos defectuosos devueltos al proveedor', 2);

-- =============================================
-- VERIFICACIÓN DE DATOS
-- =============================================

-- Mostrar resumen de datos insertados
SELECT 'departamentos' AS tabla, COUNT(*) AS registros FROM departamentos
UNION ALL SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'pedidos', COUNT(*) FROM pedidos
UNION ALL SELECT 'detalle_pedidos', COUNT(*) FROM detalle_pedidos
UNION ALL SELECT 'nominas', COUNT(*) FROM nominas
UNION ALL SELECT 'proveedores', COUNT(*) FROM proveedores
UNION ALL SELECT 'stock_movimientos', COUNT(*) FROM stock_movimientos
ORDER BY tabla;

-- =============================================
-- NOTA PARA EL ALUMNO
-- =============================================
-- A partir de este punto, el alumno debe:
-- 1. Crear las vistas de seguridad
-- 2. Crear los roles de grupo
-- 3. Asignar privilegios a los roles
-- 4. Crear los usuarios
-- 5. Asignar roles a usuarios
-- 6. Verificar los accesos
-- 7. Practicar revocación y reasignación
-- =============================================

CREATE OR REPLACE VIEW v_contactoEmpleado_rrhh AS 
SELECT id_emp, nombre|| ' ' || apellidos AS nombreCompleto, email, telefono,activo FROM empleados;



SELECT * FROM v_contactoEmpleado_rrhh;


CREATE OR REPLACE VIEW v_productosStock_almacen AS
SELECT p.id_prod,p.nombre,s.id_movimiento,s.tipo_movimiento, s.cantidad,s.motivo, s.id_empleado,s.fecha_movimiento 
FROM productos p INNER JOIN stock_movimientos s ON s.id_prod=p.id_prod;

select * from v_productosStock_almacen;

CREATE OR REPLACE VIEW v_departamentosEmpleados_auditor AS 
SELECT  d.nombre AS nombreDepartamento, d.presupuesto AS presupuestoDepartamento, 
COUNT(e.id_emp) AS cantidadEmpleadosDepartamentos,SUM(e.salario) AS conjuntoSalarios
FROM departamentos d INNER JOIN empleados e ON e.id_dept=d.id_dept WHERE e.activo=true GROUP BY d.id_dept;

CREATE ROLE rrhh WITH LOGIN;
CREATE ROLE almacen WITH LOGIN;
CREATE ROLE auditor WITH LOGIN;

GRANT ALL PRIVILEGES ON v_contactoEmpleado_rrhh TO rrhh;
GRANT SELECT ON v_productosStock_almacen TO almacen;
GRANT SELECT ON v_departamentosEmpleados_auditor TO auditor;

CREATE USER ana_rrhh WITH PASSWORD 'RRhh1234';
CREATE USER maria_alamcen WITH PASSWORD 'maria1234';
CREATE USER lucia_auditor WITH PASSWORD 'au1234';

GRANT rrhh TO ana_rrhh;
GRANT almacen TO maria_alamcen;
GRANT auditor TO lucia_auditor;