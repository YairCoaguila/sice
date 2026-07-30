-- Migración: Vincular usuario con docente
ALTER TABLE usuario ADD COLUMN IF NOT EXISTS id_docente INT REFERENCES docente(id);

-- Vincular los usuarios seed con docentes existentes (por orden de creación)
UPDATE usuario SET id_docente = (SELECT id FROM docente ORDER BY id LIMIT 1 OFFSET 0) WHERE username = 'docente01' AND id_docente IS NULL;
