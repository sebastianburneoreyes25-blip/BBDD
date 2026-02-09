-- =====================================================
-- Script: 02_schema.sql
-- Descripcion: Esquema de base de datos para RA4
-- Modulo: 0484 - Bases de Datos
-- RA: RA4 - Tratamiento de Datos
-- =====================================================
CREATE DATABASE POSTGRESCOSAS;
SET client_encoding = 'UTF8';

BEGIN;

-- =====================================================
-- 1. ELIMINAR TABLAS EXISTENTES
-- =====================================================

DROP TABLE IF EXISTS auditoria CASCADE;
DROP TABLE IF EXISTS movimientos CASCADE;
DROP TABLE IF EXISTS asignaciones CASCADE;
DROP TABLE IF EXISTS proyectos CASCADE;
DROP TABLE IF EXISTS empleados CASCADE;
DROP TABLE IF EXISTS departamentos CASCADE;
DROP TABLE IF EXISTS cuentas CASCADE;
DROP TABLE IF EXISTS productos CASCADE;
DROP TABLE IF EXISTS categorias CASCADE;
DROP TABLE IF EXISTS logs CASCADE;

-- =====================================================
-- 2. CREAR TABLAS
-- =====================================================

-- Tabla departamentos
CREATE TABLE departamentos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    ubicacion VARCHAR(100),
    presupuesto DECIMAL(12,2) DEFAULT 0 CHECK (presupuesto >= 0),
    activo BOOLEAN DEFAULT true,
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE departamentos IS 'Departamentos de la empresa';
COMMENT ON COLUMN departamentos.presupuesto IS 'Presupuesto anual en euros';

-- Tabla empleados
CREATE TABLE empleados (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    apellido VARCHAR(50) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    salario DECIMAL(10,2) CHECK (salario >= 0),
    departamento_id INTEGER REFERENCES departamentos(id) ON DELETE SET NULL,
    fecha_contratacion DATE DEFAULT CURRENT_DATE,
    activo BOOLEAN DEFAULT true,
    fecha_modificacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE empleados IS 'Empleados de la empresa';
COMMENT ON COLUMN empleados.salario IS 'Salario anual bruto en euros';

-- Tabla proyectos
CREATE TABLE proyectos (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE DEFAULT CURRENT_DATE,
    fecha_fin DATE,
    presupuesto DECIMAL(12,2) CHECK (presupuesto >= 0),
    estado VARCHAR(20) DEFAULT 'planificado'
        CHECK (estado IN ('planificado', 'en_curso', 'completado', 'cancelado')),
    CONSTRAINT chk_fechas CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio)
);

COMMENT ON TABLE proyectos IS 'Proyectos activos de la empresa';

-- Tabla asignaciones (relacion M:N empleados-proyectos)
CREATE TABLE asignaciones (
    id SERIAL PRIMARY KEY,
    empleado_id INTEGER NOT NULL REFERENCES empleados(id) ON DELETE CASCADE,
    proyecto_id INTEGER NOT NULL REFERENCES proyectos(id) ON DELETE CASCADE,
    fecha_asignacion DATE DEFAULT CURRENT_DATE,
    rol VARCHAR(50),
    horas_asignadas INTEGER DEFAULT 0,
    UNIQUE (empleado_id, proyecto_id)
);

COMMENT ON TABLE asignaciones IS 'Asignacion de empleados a proyectos';

-- Tabla cuentas (para ejercicios de transacciones)
CREATE TABLE cuentas (
    id SERIAL PRIMARY KEY,
    titular VARCHAR(100) NOT NULL,
    saldo DECIMAL(12,2) DEFAULT 0 CHECK (saldo >= 0),
    tipo VARCHAR(20) DEFAULT 'corriente' CHECK (tipo IN ('corriente', 'ahorro', 'nomina')),
    activa BOOLEAN DEFAULT true
);

COMMENT ON TABLE cuentas IS 'Cuentas bancarias para ejercicios de transacciones';

-- Tabla movimientos
CREATE TABLE movimientos (
    id SERIAL PRIMARY KEY,
    cuenta_origen INTEGER REFERENCES cuentas(id),
    cuenta_destino INTEGER REFERENCES cuentas(id),
    monto DECIMAL(12,2) NOT NULL CHECK (monto > 0),
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    descripcion VARCHAR(200)
);

COMMENT ON TABLE movimientos IS 'Registro de movimientos bancarios';

-- Tabla categorias
CREATE TABLE categorias (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL UNIQUE,
    descripcion TEXT
);

-- Tabla productos
CREATE TABLE productos (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    precio DECIMAL(10,2) CHECK (precio > 0),
    stock INTEGER DEFAULT 0 CHECK (stock >= 0),
    categoria_id INTEGER REFERENCES categorias(id),
    activo BOOLEAN DEFAULT true
);

-- Tabla logs
CREATE TABLE logs (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(50),
    operacion VARCHAR(10),
    registro_id INTEGER,
    datos JSONB,
    usuario VARCHAR(50) DEFAULT CURRENT_USER,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE logs IS 'Registro de operaciones para auditoria';

-- Tabla auditoria
CREATE TABLE auditoria (
    id SERIAL PRIMARY KEY,
    tabla VARCHAR(50),
    operacion VARCHAR(10),
    datos_anteriores JSONB,
    datos_nuevos JSONB,
    usuario VARCHAR(50) DEFAULT CURRENT_USER,
    fecha TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

COMMENT ON TABLE auditoria IS 'Tabla de auditoria detallada';

-- =====================================================
-- 3. CREAR INDICES
-- =====================================================

CREATE INDEX idx_empleados_departamento ON empleados(departamento_id);
CREATE INDEX idx_empleados_email ON empleados(email);
CREATE INDEX idx_empleados_activo ON empleados(activo);
CREATE INDEX idx_asignaciones_empleado ON asignaciones(empleado_id);
CREATE INDEX idx_asignaciones_proyecto ON asignaciones(proyecto_id);
CREATE INDEX idx_productos_categoria ON productos(categoria_id);
CREATE INDEX idx_productos_codigo ON productos(codigo);
CREATE INDEX idx_logs_fecha ON logs(fecha);
CREATE INDEX idx_auditoria_fecha ON auditoria(fecha);

COMMIT;

DO $$ BEGIN RAISE NOTICE 'Esquema de base de datos creado correctamente'; END $$;

-- =====================================================
-- Script: 03_data.sql
-- Descripcion: Datos de ejemplo para RA4
-- Modulo: 0484 - Bases de Datos
-- RA: RA4 - Tratamiento de Datos
-- =====================================================

SET client_encoding = 'UTF8';

BEGIN;

-- =====================================================
-- DATOS DE EJEMPLO
-- =====================================================

-- Departamentos
INSERT INTO departamentos (nombre, ubicacion, presupuesto) VALUES
    ('Tecnologia', 'Planta 3', 500000),
    ('Recursos Humanos', 'Planta 1', 200000),
    ('Ventas', 'Planta 2', 350000),
    ('Marketing', 'Planta 2', 250000),
    ('Finanzas', 'Planta 1', 300000);

-- Empleados
INSERT INTO empleados (nombre, apellido, email, salario, departamento_id) VALUES
    ('Carlos', 'Garcia', 'carlos.garcia@empresa.com', 45000, 1),
    ('Maria', 'Lopez', 'maria.lopez@empresa.com', 42000, 1),
    ('Juan', 'Martinez', 'juan.martinez@empresa.com', 38000, 2),
    ('Ana', 'Fernandez', 'ana.fernandez@empresa.com', 52000, 3),
    ('Pedro', 'Sanchez', 'pedro.sanchez@empresa.com', 35000, 1),
    ('Laura', 'Gomez', 'laura.gomez@empresa.com', 41000, 4),
    ('Miguel', 'Ruiz', 'miguel.ruiz@empresa.com', 48000, 5),
    ('Carmen', 'Diaz', 'carmen.diaz@empresa.com', 39000, 2),
    ('David', 'Torres', 'david.torres@empresa.com', 44000, 3),
    ('Sofia', 'Navarro', 'sofia.navarro@empresa.com', 36000, 4),
    ('Jorge', 'Moreno', 'jorge.moreno@empresa.com', 47000, 1),
    ('Elena', 'Jimenez', 'elena.jimenez@empresa.com', 43000, 5),
    ('Pablo', 'Hernandez', 'pablo.hernandez@empresa.com', 37000, 3),
    ('Lucia', 'Alvarez', 'lucia.alvarez@empresa.com', 40000, 2),
    ('Roberto', 'Romero', 'roberto.romero@empresa.com', 46000, 1);

-- Proyectos
INSERT INTO proyectos (nombre, descripcion, fecha_inicio, presupuesto, estado) VALUES
    ('Portal Web', 'Nuevo portal corporativo', '2025-01-15', 80000, 'en_curso'),
    ('App Movil', 'Aplicacion para clientes', '2025-02-01', 120000, 'planificado'),
    ('CRM', 'Sistema de gestion de clientes', '2024-10-01', 150000, 'en_curso'),
    ('ERP', 'Sistema de gestion empresarial', '2024-06-01', 250000, 'en_curso'),
    ('BI Dashboard', 'Panel de indicadores', '2025-03-01', 60000, 'planificado');

-- Asignaciones
INSERT INTO asignaciones (empleado_id, proyecto_id, rol, horas_asignadas) VALUES
    (1, 1, 'Lider Tecnico', 40),
    (2, 1, 'Desarrollador', 40),
    (5, 1, 'Desarrollador', 30),
    (1, 3, 'Consultor', 10),
    (11, 2, 'Lider Tecnico', 40),
    (2, 2, 'Desarrollador', 20),
    (4, 3, 'Product Owner', 20),
    (9, 3, 'Analista', 40),
    (7, 4, 'Sponsor', 5),
    (12, 4, 'Analista', 40);

-- Cuentas bancarias
INSERT INTO cuentas (titular, saldo, tipo) VALUES
    ('Juan Perez', 5000.00, 'corriente'),
    ('Maria Garcia', 12000.00, 'ahorro'),
    ('Carlos Lopez', 3500.00, 'nomina'),
    ('Ana Martinez', 8000.00, 'corriente'),
    ('Pedro Sanchez', 15000.00, 'ahorro');

-- Categorias de productos
INSERT INTO categorias (nombre, descripcion) VALUES
    ('Electronica', 'Dispositivos electronicos'),
    ('Informatica', 'Equipos y accesorios informaticos'),
    ('Oficina', 'Material de oficina'),
    ('Mobiliario', 'Muebles de oficina');

-- Productos
INSERT INTO productos (codigo, nombre, precio, stock, categoria_id) VALUES
    ('ELEC001', 'Monitor 27"', 299.99, 50, 1),
    ('ELEC002', 'Teclado Mecanico', 89.99, 100, 1),
    ('ELEC003', 'Raton Inalambrico', 29.99, 200, 1),
    ('INFO001', 'Laptop Pro', 1299.99, 25, 2),
    ('INFO002', 'Laptop Basic', 699.99, 40, 2),
    ('INFO003', 'Disco SSD 1TB', 99.99, 150, 2),
    ('OFIC001', 'Papel A4 (500 hojas)', 4.99, 500, 3),
    ('OFIC002', 'Boligrafos (pack 10)', 2.99, 300, 3),
    ('MOBI001', 'Silla Ergonomica', 249.99, 30, 4),
    ('MOBI002', 'Mesa Escritorio', 199.99, 20, 4);

COMMIT;

-- =====================================================
-- VERIFICACION
-- =====================================================

DO $$
DECLARE
    v_departamentos INTEGER;
    v_empleados INTEGER;
    v_proyectos INTEGER;
    v_asignaciones INTEGER;
    v_cuentas INTEGER;
    v_productos INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_departamentos FROM departamentos;
    SELECT COUNT(*) INTO v_empleados FROM empleados;
    SELECT COUNT(*) INTO v_proyectos FROM proyectos;
    SELECT COUNT(*) INTO v_asignaciones FROM asignaciones;
    SELECT COUNT(*) INTO v_cuentas FROM cuentas;
    SELECT COUNT(*) INTO v_productos FROM productos;

    RAISE NOTICE '============================================';
    RAISE NOTICE 'Datos cargados correctamente:';
    RAISE NOTICE '  - Departamentos: %', v_departamentos;
    RAISE NOTICE '  - Empleados: %', v_empleados;
    RAISE NOTICE '  - Proyectos: %', v_proyectos;
    RAISE NOTICE '  - Asignaciones: %', v_asignaciones;
    RAISE NOTICE '  - Cuentas: %', v_cuentas;
    RAISE NOTICE '  - Productos: %', v_productos;
    RAISE NOTICE '============================================';
END $$;



-- 1.1 Concatenacion de cadenas
SELECT 
    id,
    nombre || ' ' || apellido AS nombre_completo,
    email,
    salario
FROM empleados
ORDER BY apellido, nombre
LIMIT 10;

--1.2 Funciones de fecha PostgreSQL
SELECT nombre||' '||apellido AS nombre_completo, fecha_contratacion, EXTRACT(YEAR FROM fecha_contratacion) AS anio_contratacion, 
AGE(CURRENT_DATE, fecha_contratacion) AS antiguedad ,
EXTRACT(MONTH FROM fecha_contratacion) AS mes_contratacion, TO_CHAR(fecha_contratacion, 'DD "de" TMmonth "de" YYYY')FROM empleados;

--1.3 Sintaxis FETCH (estandar SQL)
SELECT 
    nombre || ' ' || apellido AS empleado,
    salario
FROM empleados
ORDER BY salario DESC
FETCH FIRST 5 ROWS ONLY;--FETCH FIRST es como limit

--2.1 INSERT con RETURNING
INSERT INTO departamentos (nombre, ubicacion, presupuesto)
VALUES ('Logistica', 'Almacen Central', 180000)
RETURNING id, nombre, ubicacion, presupuesto, fecha_creacion;
/*Inserta datos y el returning es un select de lo que acabas de insertar
(compruebas que se inserta bien y ademas te sirve para si necesitas el id o otro dato 
para relacionarlo)*/

--2.2 UPDATE con RETURNING
UPDATE departamentos
SET presupuesto = presupuesto * 1.10
WHERE nombre = 'Logistica'
RETURNING 
    id, 
    nombre, 
    presupuesto AS nuevo_presupuesto,
    presupuesto / 1.10 AS presupuesto_anterior;

--2.3 DELETE con RETURNING
DELETE FROM departamentos
WHERE nombre = 'Logistica'
RETURNING id, nombre, presupuesto, 'ELIMINADO' AS estado;

--3.1 Insertar o actualizar producto
INSERT INTO productos (codigo, nombre, precio, stock, categoria_id)
VALUES ('NUEVO001', 'Producto Nuevo', 49.99, 100, 1)
ON CONFLICT (codigo) DO UPDATE SET--Cuando haya conflicto se actualiza
    precio = EXCLUDED.precio,--EXCLUDED es lo que esytamos intentando insertar
    stock = productos.stock + EXCLUDED.stock  -- Suma al stock existente
RETURNING id, codigo, nombre, precio, stock, 'INSERTADO/ACTUALIZADO' AS operacion;

INSERT INTO productos (codigo, nombre, precio, stock, categoria_id)
VALUES ('NUEVO001', 'Producto Nuevo Mejorado', 59.99, 50, 1)
ON CONFLICT (codigo) DO UPDATE SET
    precio = EXCLUDED.precio,
    stock = productos.stock + EXCLUDED.stock
RETURNING id, codigo, nombre, precio, stock, 'ACTUALIZADO' AS operacion;

--3.2 Insertar ignorando duplicados
INSERT INTO productos (codigo, nombre, precio, stock, categoria_id)
VALUES 
    ('ELEC001', 'Monitor Existente', 399.99, 10, 1),  -- Ya existe, se ignora
    ('NUEVO002', 'Producto Nuevo 2', 29.99, 50, 2),   -- Nuevo, se inserta
    ('INFO001', 'Laptop Existente', 1499.99, 5, 2)    -- Ya existe, se ignora
ON CONFLICT (codigo) DO NOTHING--aqui lo que hay entre parentesis es el campo a comparar.
RETURNING id, codigo, nombre;
-- Limpiar productos de prueba
DELETE FROM productos WHERE codigo IN ('NUEVO001', 'NUEVO002');

--4.1 CTE simple
WITH salarios_medios AS (
    SELECT 
        departamento_id,
        AVG(salario) AS salario_medio
    FROM empleados
    GROUP BY departamento_id
)
--Crea una tabla volatil para poder usar sus campos en la consulta.
SELECT 
    e.nombre || ' ' || e.apellido AS empleado,
    d.nombre AS departamento,
    e.salario,
    ROUND(sm.salario_medio::NUMERIC, 2) AS salario_medio_dept,
    ROUND((e.salario - sm.salario_medio)::NUMERIC, 2) AS diferencia
	--::NUMERIC declara el tipo de campo y sus decimales en este caso
FROM empleados e
JOIN departamentos d ON e.departamento_id = d.id
JOIN salarios_medios sm ON e.departamento_id = sm.departamento_id
WHERE e.salario > sm.salario_medio
ORDER BY diferencia DESC;

--4.2 CTEs multiples
/*Crea un informe que muestre:

Total de empleados por departamento

Presupuesto por empleado

Ranking de departamentos
*/
WITH empleados_por_dept AS (
    SELECT 
        departamento_id,
        COUNT(*) AS num_empleados,
        SUM(salario) AS masa_salarial
    FROM empleados
    WHERE activo = true
    GROUP BY departamento_id
),
--Total de empleados por dep
metricas AS (
    SELECT 
        d.id,
        d.nombre,
        d.presupuesto,
		--
        COALESCE(e.num_empleados, 0) AS num_empleados,
        COALESCE(e.masa_salarial, 0) AS masa_salarial,
		
        CASE 
            WHEN COALESCE(e.num_empleados, 0) > 0 
			--Cuando se den las condiciones
            THEN ROUND((d.presupuesto / e.num_empleados)::NUMERIC, 2)
			--haz esto
            ELSE 0
        END AS presupuesto_por_empleado
		--Guardalo en presupuesto por empleado
    FROM departamentos d
    LEFT JOIN empleados_por_dept e ON d.id = e.departamento_id
)
--presupuesto
SELECT 
    nombre AS departamento,
    num_empleados,
    presupuesto,
    masa_salarial,
    presupuesto_por_empleado,
    ROW_NUMBER() OVER (ORDER BY presupuesto_por_empleado DESC) AS ranking
	--
FROM metricas
ORDER BY ranking;


--5.1 Ranking de empleados

--Muestra un ranking de empleados por salario dentro de cada departamento.
SELECT 
    d.nombre AS departamento,
    e.nombre || ' ' || e.apellido AS empleado,
    e.salario,
	--3 formas de sacar el ranking
    ROW_NUMBER() OVER (PARTITION BY d.id ORDER BY e.salario DESC) AS ranking,
	RANK() OVER (PARTITION BY d.id ORDER BY e.salario DESC) AS rank,
    DENSE_RANK() OVER (PARTITION BY d.id ORDER BY e.salario DESC) AS dense_rank
	
FROM empleados e
JOIN departamentos d ON e.departamento_id = d.id
ORDER BY d.nombre, ranking;
