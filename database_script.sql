CREATE DATABASE IF NOT EXISTS sistema_legal;
USE sistema_legal;

-- 1. Tabla de Usuarios (Login)
CREATE TABLE usuarios (
    id INT AUTO_INCREMENT PRIMARY KEY,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL
);

-- 2. Tabla de Aseguradoras
CREATE TABLE aseguradoras (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    contacto VARCHAR(50)
);

-- 3. Tabla de Tipos de Casos
CREATE TABLE tipos_casos (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre_tipo VARCHAR(100) NOT NULL
);

-- 4. Tabla de Abogados (Licenciados)
CREATE TABLE abogados (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    especialidad VARCHAR(100),
    num_colegiado VARCHAR(50) UNIQUE
);

-- 5. Tabla de Expedientes
CREATE TABLE expedientes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    numero_caso VARCHAR(20) NOT NULL UNIQUE,
    id_tipo_caso INT,
    id_aseguradora INT,
    id_abogado INT,
    fecha_inicio DATE,
    estado VARCHAR(20) DEFAULT 'Abierto',
    FOREIGN KEY (id_tipo_caso) REFERENCES tipos_casos(id),
    FOREIGN KEY (id_aseguradora) REFERENCES aseguradoras(id),
    FOREIGN KEY (id_abogado) REFERENCES abogados(id)
);

-- VISTAS SQL (REQUERIDAS)
-- Vista 1: Resumen detallado de expedientes
CREATE OR REPLACE VIEW vista_detalle_expedientes AS
SELECT e.numero_caso, t.nombre_tipo AS tipo, a.nombre AS abogado, i.nombre AS aseguradora, e.estado
FROM expedientes e
JOIN tipos_casos t ON e.id_tipo_caso = t.id
JOIN abogados a ON e.id_abogado = a.id
JOIN aseguradoras i ON e.id_aseguradora = i.id;

-- Vista 2: Conteo de casos por aseguradora
CREATE OR REPLACE VIEW vista_estadistica_aseguradoras AS
SELECT i.nombre, COUNT(e.id) AS total_casos
FROM aseguradoras i
LEFT JOIN expedientes e ON i.id_aseguradora = e.id
GROUP BY i.nombre;

-- Vista 3: Carga de trabajo por abogado
CREATE OR REPLACE VIEW vista_carga_abogados AS
SELECT a.nombre, COUNT(e.id) AS casos_asignados
FROM abogados a
LEFT JOIN expedientes e ON a.id_abogado = e.id
GROUP BY a.nombre;

USE sistema_legal;

-- 1. Insertar Usuarios para el módulo de Login
INSERT INTO usuarios (usuario, password_hash) VALUES 
('admin', 'pbkdf2:sha256:250000$scrypt$hash_simulado_1'),
('licenciado_perez', 'pbkdf2:sha256:250000$scrypt$hash_simulado_2');

-- 2. Insertar Aseguradoras
INSERT INTO aseguradoras (nombre, contacto) VALUES 
('Seguros Continental', '2233-4455'),
('Aseguradora del Norte', '2211-9988'),
('Seguros La Confianza', '2255-0011');

-- 3. Insertar Tipos de Casos
INSERT INTO tipos_casos (nombre_tipo) VALUES 
('Accidente de Tránsito'),
('Responsabilidad Civil'),
('Laboral'),
('Daños a Terceros');

-- 4. Insertar Abogados (Licenciados)
INSERT INTO abogados (nombre, especialidad, num_colegiado) VALUES 
('Lic. Carlos Ruiz', 'Derecho Civil', 'ABO-5544'),
('Dra. Maria Lopez', 'Derecho Laboral', 'ABO-2211'),
('Lic. Roberto Gomez', 'Derecho Mercantil', 'ABO-9988');

-- 5. Insertar Expedientes (Esto ya amarra todo lo anterior)
-- Nota: Usamos IDs 1, 2 y 3 que acabamos de crear arriba
INSERT INTO expedientes (numero_caso, id_tipo_caso, id_aseguradora, id_abogado, fecha_inicio, estado) VALUES 
('EXP-2026-001', 1, 1, 1, '2026-01-15', 'Activo'),
('EXP-2026-002', 2, 2, 2, '2026-02-10', 'En Proceso'),
('EXP-2026-003', 1, 3, 1, '2026-03-01', 'Abierto'),
('EXP-2026-004', 3, 1, 3, '2026-03-15', 'Activo');

SELECT * FROM vista_detalle_expedientes;