-- Migración: Cambiar examen.id_carrera → examen.id_area
-- Ejecutar SOLO si ya existen datos en la tabla examen

ALTER TABLE examen DROP CONSTRAINT IF EXISTS examen_id_carrera_fkey;
ALTER TABLE examen RENAME COLUMN id_carrera TO id_area;
ALTER TABLE examen ADD CONSTRAINT examen_id_area_fkey FOREIGN KEY (id_area) REFERENCES area(id);
