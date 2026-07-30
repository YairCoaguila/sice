-- ================================================================
-- SICE - Sistema Integral de Calificación de Exámenes
-- Script PostgreSQL completo
-- ================================================================

-- CREATE DATABASE simulacro_db ENCODING='UTF8';
-- \c simulacro_db

-- ── TABLAS ───────────────────────────────────────────────────────

CREATE TABLE IF NOT EXISTS usuario (
    id SERIAL PRIMARY KEY,
    username VARCHAR(60) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    rol VARCHAR(30) NOT NULL CHECK (rol IN ('administrador','docente','digitador')),
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO' CHECK (estado IN ('ACTIVO','INACTIVO')),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS grado (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(60) NOT NULL UNIQUE,
    nivel INT NOT NULL,
    participa BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS seccion (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(10) NOT NULL,
    id_grado INT NOT NULL REFERENCES grado(id),
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (nombre, id_grado)
);

CREATE TABLE IF NOT EXISTS area (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE,
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS carrera (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(150) NOT NULL,
    id_area INT NOT NULL REFERENCES area(id),
    descripcion TEXT,
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS periodo (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(50) NOT NULL,
    anio INT NOT NULL,
    descripcion TEXT,
    activo BOOLEAN NOT NULL DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (nombre, anio)
);

CREATE TABLE IF NOT EXISTS docente (
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(60) NOT NULL,
    apellido_materno VARCHAR(60) NOT NULL,
    dni VARCHAR(15) NOT NULL UNIQUE,
    celular VARCHAR(20),
    correo VARCHAR(120),
    especialidad VARCHAR(100),
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS alumno (
    id SERIAL PRIMARY KEY,
    nombres VARCHAR(100) NOT NULL,
    apellido_paterno VARCHAR(60) NOT NULL,
    apellido_materno VARCHAR(60) NOT NULL,
    dni VARCHAR(15) NOT NULL UNIQUE,
    fecha_nacimiento DATE,
    celular VARCHAR(20),
    direccion VARCHAR(200),
    colegio VARCHAR(200),
    id_grado INT NOT NULL REFERENCES grado(id),
    id_seccion INT NOT NULL REFERENCES seccion(id),
    id_carrera INT NOT NULL REFERENCES carrera(id),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS docente_aula (
    id SERIAL PRIMARY KEY,
    id_docente INT NOT NULL REFERENCES docente(id),
    id_grado INT NOT NULL REFERENCES grado(id),
    id_seccion INT NOT NULL REFERENCES seccion(id),
    anio INT NOT NULL,
    periodo VARCHAR(30) NOT NULL,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (id_grado, id_seccion, anio, periodo)
);

CREATE TABLE IF NOT EXISTS examen (
    id SERIAL PRIMARY KEY,
    nombre VARCHAR(200) NOT NULL,
    fecha DATE,
    anio INT NOT NULL,
    periodo VARCHAR(30) NOT NULL,
    id_grado INT NOT NULL REFERENCES grado(id),
    id_area INT NOT NULL REFERENCES area(id),
    cantidad_preguntas INT NOT NULL DEFAULT 100,
    puntaje_total NUMERIC(8,2) NOT NULL DEFAULT 100,
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO',
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS pregunta (
    id SERIAL PRIMARY KEY,
    id_examen INT NOT NULL REFERENCES examen(id) ON DELETE CASCADE,
    numero INT NOT NULL,
    enunciado TEXT,
    respuesta_correcta CHAR(1) NOT NULL CHECK (respuesta_correcta IN ('A','B','C','D','E')),
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (id_examen, numero)
);

CREATE TABLE IF NOT EXISTS respuesta_alumno (
    id SERIAL PRIMARY KEY,
    id_alumno INT NOT NULL REFERENCES alumno(id),
    id_examen INT NOT NULL REFERENCES examen(id),
    numero_pregunta INT NOT NULL,
    respuesta_marcada CHAR(1) CHECK (respuesta_marcada IN ('A','B','C','D','E')),
    es_correcta BOOLEAN NOT NULL DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT NOW(),
    UNIQUE (id_alumno, id_examen, numero_pregunta)
);

CREATE TABLE IF NOT EXISTS resultado (
    id SERIAL PRIMARY KEY,
    id_alumno INT NOT NULL REFERENCES alumno(id),
    id_examen INT NOT NULL REFERENCES examen(id),
    puntaje NUMERIC(8,2) NOT NULL DEFAULT 0,
    correctas INT NOT NULL DEFAULT 0,
    incorrectas INT NOT NULL DEFAULT 0,
    en_blanco INT NOT NULL DEFAULT 0,
    porcentaje NUMERIC(6,2) NOT NULL DEFAULT 0,
    fecha_registro TIMESTAMP DEFAULT NOW(),
    UNIQUE (id_alumno, id_examen)
);

CREATE TABLE IF NOT EXISTS inscripcion (
    id SERIAL PRIMARY KEY,
    codigo_inscripcion VARCHAR(30) NOT NULL UNIQUE,
    id_alumno INT NOT NULL REFERENCES alumno(id),
    id_examen INT NOT NULL REFERENCES examen(id),
    id_carrera INT NOT NULL REFERENCES carrera(id),
    anio INT NOT NULL,
    periodo VARCHAR(30) NOT NULL,
    fecha_inscripcion TIMESTAMP NOT NULL DEFAULT NOW(),
    estado VARCHAR(20) NOT NULL DEFAULT 'ACTIVO'
        CHECK (estado IN ('ACTIVO','CANCELADO','PENDIENTE')),
    UNIQUE (id_alumno, id_examen)
);

-- ── ÍNDICES ───────────────────────────────────────────────────────
CREATE INDEX IF NOT EXISTS idx_alumno_dni     ON alumno(dni);
CREATE INDEX IF NOT EXISTS idx_alumno_grado   ON alumno(id_grado);
CREATE INDEX IF NOT EXISTS idx_alumno_seccion ON alumno(id_seccion);
CREATE INDEX IF NOT EXISTS idx_resultado_examen  ON resultado(id_examen);
CREATE INDEX IF NOT EXISTS idx_resultado_alumno  ON resultado(id_alumno);
CREATE INDEX IF NOT EXISTS idx_resultado_puntaje ON resultado(puntaje DESC);
CREATE INDEX IF NOT EXISTS idx_inscripcion_codigo ON inscripcion(codigo_inscripcion);
CREATE INDEX IF NOT EXISTS idx_inscripcion_alumno ON inscripcion(id_alumno);

-- ── VISTAS ────────────────────────────────────────────────────────

CREATE OR REPLACE VIEW vw_alumnos AS
SELECT a.id, a.nombres, a.apellido_paterno, a.apellido_materno,
    a.apellido_paterno||' '||a.apellido_materno||', '||a.nombres AS nombre_completo,
    a.dni, a.fecha_nacimiento, a.celular, a.direccion, a.colegio,
    a.id_grado, a.id_seccion, a.id_carrera, a.created_at,
    g.nombre AS grado_nombre, g.nivel AS grado_nivel,
    s.nombre AS seccion_nombre,
    c.nombre AS carrera_nombre
FROM alumno a
JOIN grado   g ON a.id_grado   = g.id
JOIN seccion s ON a.id_seccion = s.id
JOIN carrera c ON a.id_carrera = c.id;

CREATE OR REPLACE VIEW vw_resultados AS
SELECT r.id, r.id_alumno, r.id_examen,
    r.puntaje, r.correctas, r.incorrectas, r.en_blanco, r.porcentaje, r.fecha_registro,
    a.apellido_paterno||' '||a.apellido_materno||', '||a.nombres AS alumno_nombre,
    a.dni AS alumno_dni,
    g.nombre AS grado_nombre, g.id AS id_grado,
    s.nombre AS seccion_nombre, s.id AS id_seccion,
    c.nombre AS carrera_nombre, c.id AS id_carrera,
    e.nombre AS examen_nombre, e.anio AS examen_anio, e.periodo AS examen_periodo
FROM resultado r
JOIN alumno  a ON r.id_alumno  = a.id
JOIN examen  e ON r.id_examen  = e.id
JOIN grado   g ON a.id_grado   = g.id
JOIN seccion s ON a.id_seccion = s.id
JOIN carrera c ON a.id_carrera = c.id;

CREATE OR REPLACE VIEW vw_ranking_general AS
SELECT vr.*,
    RANK() OVER (PARTITION BY vr.id_examen ORDER BY vr.puntaje DESC) AS ranking_general
FROM vw_resultados vr;

CREATE OR REPLACE VIEW vw_ranking_grado AS
SELECT vr.*,
    RANK() OVER (PARTITION BY vr.id_examen, vr.id_grado ORDER BY vr.puntaje DESC) AS ranking_grado
FROM vw_resultados vr;

CREATE OR REPLACE VIEW vw_ranking_seccion AS
SELECT vr.*,
    RANK() OVER (PARTITION BY vr.id_examen, vr.id_seccion ORDER BY vr.puntaje DESC) AS ranking_seccion
FROM vw_resultados vr;

CREATE OR REPLACE VIEW vw_docente_aula AS
SELECT da.id, da.id_docente, da.id_grado, da.id_seccion, da.anio, da.periodo, da.created_at,
    d.apellido_paterno||' '||d.apellido_materno||', '||d.nombres AS docente_nombre,
    d.dni AS docente_dni,
    g.nombre AS grado_nombre,
    s.nombre AS seccion_nombre
FROM docente_aula da
JOIN docente d ON da.id_docente = d.id
JOIN grado   g ON da.id_grado   = g.id
JOIN seccion s ON da.id_seccion = s.id;

CREATE OR REPLACE VIEW vw_inscripciones AS
SELECT i.id, i.codigo_inscripcion, i.id_alumno, i.id_examen, i.id_carrera,
    i.anio, i.periodo, i.fecha_inscripcion, i.estado,
    a.apellido_paterno||' '||a.apellido_materno||', '||a.nombres AS alumno_nombre,
    a.dni AS alumno_dni,
    g.nombre AS grado_nombre, g.id AS id_grado,
    s.nombre AS seccion_nombre, s.id AS id_seccion,
    c.nombre AS carrera_nombre,
    ar.nombre AS area_nombre,
    e.nombre AS examen_nombre,
    e.fecha  AS examen_fecha,
    e.periodo AS examen_periodo
FROM inscripcion i
JOIN alumno  a ON i.id_alumno  = a.id
JOIN examen  e ON i.id_examen  = e.id
JOIN carrera c ON i.id_carrera = c.id
JOIN area    ar ON c.id_area    = ar.id
JOIN grado   g ON a.id_grado   = g.id
JOIN seccion s ON a.id_seccion = s.id;

CREATE OR REPLACE VIEW vw_inscritos_por_carrera AS
SELECT c.nombre AS carrera_nombre, COUNT(i.id) AS total
FROM inscripcion i JOIN carrera c ON i.id_carrera = c.id
WHERE i.estado <> 'CANCELADO'
GROUP BY c.id, c.nombre ORDER BY total DESC;

CREATE OR REPLACE VIEW vw_inscritos_por_grado AS
SELECT g.nombre AS grado_nombre, COUNT(i.id) AS total
FROM inscripcion i JOIN alumno a ON i.id_alumno = a.id JOIN grado g ON a.id_grado = g.id
WHERE i.estado <> 'CANCELADO'
GROUP BY g.id, g.nombre, g.nivel ORDER BY g.nivel;

CREATE OR REPLACE VIEW vw_dashboard AS
SELECT
    (SELECT COUNT(*) FROM alumno) AS total_alumnos,
    (SELECT COUNT(*) FROM docente WHERE estado='ACTIVO') AS total_docentes,
    (SELECT COUNT(*) FROM examen) AS total_examenes,
    (SELECT COUNT(*) FROM inscripcion WHERE estado<>'CANCELADO') AS total_inscritos,
    (SELECT ROUND(AVG(puntaje),2) FROM resultado) AS promedio_puntaje,
    (SELECT s.nombre FROM seccion s JOIN alumno a ON a.id_seccion=s.id JOIN resultado r ON r.id_alumno=a.id GROUP BY s.id,s.nombre ORDER BY AVG(r.puntaje) DESC LIMIT 1) AS mejor_seccion,
    (SELECT c.nombre FROM carrera c JOIN alumno a ON a.id_carrera=c.id JOIN resultado r ON r.id_alumno=a.id GROUP BY c.id,c.nombre ORDER BY AVG(r.puntaje) DESC LIMIT 1) AS mejor_carrera;

-- ── DATOS DE PRUEBA ───────────────────────────────────────────────

INSERT INTO usuario (username,password,rol,estado) VALUES
('admin','admin123','administrador','ACTIVO'),
('docente01','doc123','docente','ACTIVO'),
('digitador01','dig123','digitador','ACTIVO')
ON CONFLICT (username) DO NOTHING;

INSERT INTO grado (nombre,nivel,participa) VALUES
('1ro Secundaria',1,FALSE),('2do Secundaria',2,TRUE),
('3ro Secundaria',3,TRUE),('4to Secundaria',4,TRUE),('5to Secundaria',5,TRUE)
ON CONFLICT (nombre) DO NOTHING;

DO $$ DECLARE g2 INT; g3 INT; g4 INT; g5 INT;
BEGIN
  SELECT id INTO g2 FROM grado WHERE nombre='2do Secundaria';
  SELECT id INTO g3 FROM grado WHERE nombre='3ro Secundaria';
  SELECT id INTO g4 FROM grado WHERE nombre='4to Secundaria';
  SELECT id INTO g5 FROM grado WHERE nombre='5to Secundaria';
  INSERT INTO seccion(nombre,id_grado) VALUES('A',g2),('B',g2),('A',g3),('B',g3),('A',g4),('A',g5),('B',g5) ON CONFLICT DO NOTHING;
END $$;

INSERT INTO area (nombre,descripcion) VALUES
('Ciencias de la Salud','Medicina, Enfermería, Farmacia, Odontología'),
('Ingeniería y Tecnología','Ingeniería Civil, Sistemas, Industrial'),
('Ciencias Sociales','Derecho, Economía, Administración'),
('Humanidades','Educación, Literatura, Psicología'),
('Ciencias Puras','Matemáticas, Física, Química, Biología')
ON CONFLICT (nombre) DO NOTHING;

DO $$ DECLARE a1 INT; a2 INT; a3 INT; a4 INT; a5 INT;
BEGIN
  SELECT id INTO a1 FROM area WHERE nombre='Ciencias de la Salud';
  SELECT id INTO a2 FROM area WHERE nombre='Ingeniería y Tecnología';
  SELECT id INTO a3 FROM area WHERE nombre='Ciencias Sociales';
  SELECT id INTO a4 FROM area WHERE nombre='Humanidades';
  SELECT id INTO a5 FROM area WHERE nombre='Ciencias Puras';
  INSERT INTO carrera(nombre,id_area) VALUES
    ('Medicina Humana',a1),('Enfermería',a1),('Odontología',a1),
    ('Ingeniería de Sistemas',a2),('Ingeniería Civil',a2),
    ('Derecho',a3),('Administración',a3),
    ('Psicología',a4),('Educación',a4),('Matemáticas',a5)
  ON CONFLICT DO NOTHING;
END $$;

INSERT INTO periodo(nombre,anio,descripcion,activo) VALUES
('Periodo 1',2026,'Primer simulacro 2026',TRUE),
('Periodo 2',2026,'Segundo simulacro 2026',FALSE)
ON CONFLICT (nombre,anio) DO NOTHING;

INSERT INTO docente(nombres,apellido_paterno,apellido_materno,dni,celular,correo,especialidad,estado) VALUES
('Carlos Alberto','Quispe','Mamani','40123456','951234567','cquispe@colegio.edu.pe','Matemáticas','ACTIVO'),
('María Elena','Huanca','Flores','40234567','952345678','mhuanca@colegio.edu.pe','Biología','ACTIVO'),
('Jorge Luis','Condori','Apaza','40345678','953456789','jcondori@colegio.edu.pe','Química','ACTIVO')
ON CONFLICT (dni) DO NOTHING;

DO $$ DECLARE g5 INT; s5a INT; cm INT;
BEGIN
  SELECT id INTO g5 FROM grado WHERE nombre='5to Secundaria';
  SELECT s.id INTO s5a FROM seccion s WHERE s.nombre='A' AND s.id_grado=g5;
  SELECT id INTO cm FROM area WHERE nombre='Ciencias de la Salud';
  INSERT INTO alumno(nombres,apellido_paterno,apellido_materno,dni,celular,id_grado,id_seccion,id_carrera)
  VALUES
    ('José Miguel','Apaza','Quispe','70123456','961111111',g5,s5a,cm),
    ('Lucía Fernanda','Coa','Llanque','70234567','962222222',g5,s5a,cm),
    ('Kevin Alexander','Flores','Mamani','70345678','963333333',g5,s5a,cm)
  ON CONFLICT (dni) DO NOTHING;
  INSERT INTO examen(nombre,fecha,anio,periodo,id_grado,id_area,cantidad_preguntas,puntaje_total,estado)
  VALUES('Simulacro 01 - Periodo 1 2026','2026-04-15',2026,'Periodo 1',g5,cm,100,100.00,'ACTIVO')
  ON CONFLICT DO NOTHING;
END $$;

-- Verificar:
-- SELECT * FROM vw_dashboard;
-- SELECT * FROM vw_alumnos;
