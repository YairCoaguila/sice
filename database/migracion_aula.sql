-- Migración: Agregar aulas y asignación a exámenes

CREATE TABLE IF NOT EXISTS aula (
    id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) NOT NULL UNIQUE,
    capacidad INT NOT NULL DEFAULT 30,
    descripcion VARCHAR(150),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS examen_aula (
    id SERIAL PRIMARY KEY,
    id_examen INT NOT NULL REFERENCES examen(id) ON DELETE CASCADE,
    id_aula INT NOT NULL REFERENCES aula(id) ON DELETE CASCADE,
    UNIQUE (id_examen)
);

CREATE OR REPLACE VIEW vw_examen_aula AS
SELECT ea.id_examen, a.id AS id_aula, a.codigo AS aula_codigo, a.capacidad
FROM examen_aula ea
JOIN aula a ON ea.id_aula = a.id;

-- Datos de prueba
INSERT INTO aula (codigo, capacidad, descripcion) VALUES
('A-101', 30, 'Aula principal - Primer piso'),
('A-102', 30, 'Aula principal - Primer piso'),
('B-201', 25, 'Aula secundaria - Segundo piso'),
('B-202', 25, 'Aula secundaria - Segundo piso'),
('C-301', 20, 'Laboratorio - Tercer piso')
ON CONFLICT (codigo) DO NOTHING;

-- Asignación de docentes por examen (múltiples docentes por examen)
ALTER TABLE docente_aula DROP COLUMN IF EXISTS id_examen;
ALTER TABLE examen_asignacion DROP CONSTRAINT IF EXISTS examen_asignacion_id_examen_key;
DROP VIEW IF EXISTS vw_examen_asignacion CASCADE;
ALTER TABLE examen_asignacion DROP COLUMN IF EXISTS id_seccion;

CREATE TABLE IF NOT EXISTS examen_asignacion (
    id SERIAL PRIMARY KEY,
    id_examen INT NOT NULL REFERENCES examen(id) ON DELETE CASCADE,
    id_docente INT NOT NULL REFERENCES docente(id),
    id_aula INT NOT NULL REFERENCES aula(id),
    created_at TIMESTAMP DEFAULT NOW()
);

CREATE OR REPLACE VIEW vw_examen_asignacion AS
SELECT ea.id, ea.id_examen, ea.id_docente, ea.id_aula, ea.created_at,
    e.nombre AS examen_nombre,
    e.anio AS examen_anio, e.periodo AS examen_periodo,
    d.apellido_paterno||' '||d.apellido_materno||', '||d.nombres AS docente_nombre,
    a.codigo AS aula_codigo, a.capacidad AS aula_capacidad
FROM examen_asignacion ea
JOIN examen e ON ea.id_examen = e.id
JOIN docente d ON ea.id_docente = d.id
JOIN aula a ON ea.id_aula = a.id;
