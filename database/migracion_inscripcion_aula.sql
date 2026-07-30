-- Migración: Agregar asignación de aula por inscripción
ALTER TABLE inscripcion ADD COLUMN IF NOT EXISTS id_aula INT REFERENCES aula(id);

-- Recrear vista (DROP + CREATE porque OR REPLACE no permite cambiar columnas existentes)
DROP VIEW IF EXISTS vw_inscripciones;
CREATE VIEW vw_inscripciones AS
SELECT i.id, i.codigo_inscripcion, i.id_alumno, i.id_examen, i.id_carrera,
    i.anio, i.periodo, i.fecha_inscripcion, i.estado, i.id_aula,
    a.apellido_paterno||' '||a.apellido_materno||', '||a.nombres AS alumno_nombre,
    a.dni AS alumno_dni,
    g.nombre AS grado_nombre, g.id AS id_grado,
    s.nombre AS seccion_nombre, s.id AS id_seccion,
    c.nombre AS carrera_nombre,
    ar.nombre AS area_nombre,
    e.nombre AS examen_nombre,
    e.fecha  AS examen_fecha,
    e.periodo AS examen_periodo,
    au.codigo AS aula_codigo
FROM inscripcion i
JOIN alumno  a ON i.id_alumno  = a.id
JOIN examen  e ON i.id_examen  = e.id
JOIN carrera c ON i.id_carrera = c.id
JOIN area    ar ON c.id_area    = ar.id
JOIN grado   g ON a.id_grado   = g.id
JOIN seccion s ON a.id_seccion = s.id
LEFT JOIN aula au ON i.id_aula  = au.id;
