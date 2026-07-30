-- ================================================================
-- SICE - Datos de prueba completos
-- Ejecutar en pgAdmin conectado a la BD de Render
-- ================================================================

-- Limpiar datos existentes (orden inverso a dependencias)
UPDATE usuario SET id_docente = NULL;
TRUNCATE TABLE resultado, inscripcion, examen_asignacion, examen_aula,
  examen, pregunta, alumno, docente_aula, carrera, periodo, seccion,
  area, aula, grado, docente, respuesta_alumno RESTART IDENTITY CASCADE;

-- Migración: agregar columna id_aula a inscripcion si no existe
ALTER TABLE inscripcion ADD COLUMN IF NOT EXISTS id_aula INT REFERENCES aula(id);

-- ── USUARIOS ─────────────────────────────────────────────────────
INSERT INTO usuario (username,password,rol,estado) VALUES
('admin',    'PZOzxndJrcQZClsNMdVE9g==:6CC2jIeX9/saIGrBE37vihN29MvF+pDWE+tg7Ubg1DE=', 'administrador','ACTIVO'),
('docente01','e8hb1mi/DawyQR2b4vlbTQ==:kg0z7IF9erWd+yDhlA1Yxlkc+whWRh6Wvm9YcvnsipA=', 'docente',     'ACTIVO'),
('digitador01','tiGyFpyECUHAhuPFlqpU+A==:ppXuY4ELej+fU6vrEvvU4rVx8d6garS1UN1bF0vo6Rs=', 'digitador',   'ACTIVO')
ON CONFLICT (username) DO NOTHING;

-- ── GRADOS ───────────────────────────────────────────────────────
INSERT INTO grado (nombre,nivel,participa) VALUES
('1ro Secundaria',1,FALSE),
('2do Secundaria',2,TRUE),
('3ro Secundaria',3,TRUE),
('4to Secundaria',4,TRUE),
('5to Secundaria',5,TRUE)
ON CONFLICT (nombre) DO NOTHING;

-- ── SECCIONES ────────────────────────────────────────────────────
DO $$ BEGIN
  INSERT INTO seccion (nombre,id_grado) SELECT 'A',id FROM grado WHERE nombre='2do Secundaria'   AND NOT EXISTS(SELECT 1 FROM seccion WHERE nombre='A' AND id_grado=(SELECT id FROM grado WHERE nombre='2do Secundaria'));
  INSERT INTO seccion (nombre,id_grado) SELECT 'B',id FROM grado WHERE nombre='2do Secundaria'   AND NOT EXISTS(SELECT 1 FROM seccion WHERE nombre='B' AND id_grado=(SELECT id FROM grado WHERE nombre='2do Secundaria'));
  INSERT INTO seccion (nombre,id_grado) SELECT 'A',id FROM grado WHERE nombre='3ro Secundaria'   AND NOT EXISTS(SELECT 1 FROM seccion WHERE nombre='A' AND id_grado=(SELECT id FROM grado WHERE nombre='3ro Secundaria'));
  INSERT INTO seccion (nombre,id_grado) SELECT 'B',id FROM grado WHERE nombre='3ro Secundaria'   AND NOT EXISTS(SELECT 1 FROM seccion WHERE nombre='B' AND id_grado=(SELECT id FROM grado WHERE nombre='3ro Secundaria'));
  INSERT INTO seccion (nombre,id_grado) SELECT 'A',id FROM grado WHERE nombre='4to Secundaria'   AND NOT EXISTS(SELECT 1 FROM seccion WHERE nombre='A' AND id_grado=(SELECT id FROM grado WHERE nombre='4to Secundaria'));
  INSERT INTO seccion (nombre,id_grado) SELECT 'A',id FROM grado WHERE nombre='5to Secundaria'   AND NOT EXISTS(SELECT 1 FROM seccion WHERE nombre='A' AND id_grado=(SELECT id FROM grado WHERE nombre='5to Secundaria'));
  INSERT INTO seccion (nombre,id_grado) SELECT 'B',id FROM grado WHERE nombre='5to Secundaria'   AND NOT EXISTS(SELECT 1 FROM seccion WHERE nombre='B' AND id_grado=(SELECT id FROM grado WHERE nombre='5to Secundaria'));
END $$;

-- ── ÁREAS ────────────────────────────────────────────────────────
INSERT INTO area (nombre,descripcion) VALUES
('Ciencias de la Salud', 'Medicina, enfermería y afines'),
('Ingeniería y Arquitectura', 'Ingenierías, arquitectura y afines'),
('Ciencias Sociales', 'Derecho, educación, psicología'),
('Humanidades', 'Letras, filosofía, artes')
ON CONFLICT (nombre) DO NOTHING;

-- ── CARRERAS ─────────────────────────────────────────────────────
DO $$ DECLARE
  v_salud INT; v_ing INT; v_sociales INT;
BEGIN
  SELECT id INTO v_salud    FROM area WHERE nombre='Ciencias de la Salud';
  SELECT id INTO v_ing      FROM area WHERE nombre='Ingeniería y Arquitectura';
  SELECT id INTO v_sociales FROM area WHERE nombre='Ciencias Sociales';
  IF NOT EXISTS (SELECT 1 FROM carrera WHERE nombre='Medicina Humana') THEN
    INSERT INTO carrera (nombre,id_area,descripcion) VALUES
      ('Medicina Humana', v_salud, 'Carrera de medicina'),
      ('Enfermería', v_salud, 'Carrera de enfermería'),
      ('Ingeniería Civil', v_ing, 'Carrera de ingeniería civil'),
      ('Ingeniería de Sistemas', v_ing, 'Carrera de ingeniería de sistemas'),
      ('Derecho', v_sociales, 'Carrera de derecho');
  END IF;
END $$;

-- ── PERIODOS ─────────────────────────────────────────────────────
INSERT INTO periodo (nombre,anio,activo) VALUES
('Periodo 1', 2026, TRUE),
('Periodo 2', 2026, FALSE)
ON CONFLICT (nombre,anio) DO NOTHING;

-- ── DOCENTES ─────────────────────────────────────────────────────
INSERT INTO docente (nombres,apellido_paterno,apellido_materno,dni,celular,correo,especialidad,estado) VALUES
('Carlos Alberto','Quispe','Mamani','40123456','951234567','cquispe@colegio.edu.pe','Matemáticas','ACTIVO'),
('María Elena','Huanca','Flores','40234567','952345678','mhuanca@colegio.edu.pe','Biología','ACTIVO'),
('Jorge Luis','Condori','Apaza','40345678','953456789','jcondori@colegio.edu.pe','Química','ACTIVO')
ON CONFLICT (dni) DO NOTHING;

-- Vincular docente01 con el primer docente
UPDATE usuario SET id_docente = (SELECT id FROM docente ORDER BY id LIMIT 1) WHERE username = 'docente01' AND id_docente IS NULL;

-- ── AULAS ────────────────────────────────────────────────────────
INSERT INTO aula (codigo,capacidad,descripcion) VALUES
('A-101', 30, 'Aula principal - Primer piso'),
('A-102', 30, 'Aula principal - Primer piso'),
('B-201', 25, 'Aula secundaria - Segundo piso'),
('B-202', 25, 'Aula secundaria - Segundo piso'),
('C-301', 20, 'Laboratorio - Tercer piso')
ON CONFLICT (codigo) DO NOTHING;

-- ── ALUMNOS ──────────────────────────────────────────────────────
DO $$ DECLARE
  v_g2 INT; v_g3 INT; v_g4 INT; v_g5 INT;
  v_s2a INT; v_s2b INT; v_s3a INT; v_s3b INT; v_s4a INT; v_s5a INT; v_s5b INT;
  v_med INT; v_enf INT; v_civil INT; v_sistemas INT; v_der INT;
BEGIN
  SELECT id INTO v_g2 FROM grado WHERE nombre='2do Secundaria';
  SELECT id INTO v_g3 FROM grado WHERE nombre='3ro Secundaria';
  SELECT id INTO v_g4 FROM grado WHERE nombre='4to Secundaria';
  SELECT id INTO v_g5 FROM grado WHERE nombre='5to Secundaria';
  SELECT id INTO v_s2a FROM seccion WHERE nombre='A' AND id_grado=v_g2;
  SELECT id INTO v_s2b FROM seccion WHERE nombre='B' AND id_grado=v_g2;
  SELECT id INTO v_s3a FROM seccion WHERE nombre='A' AND id_grado=v_g3;
  SELECT id INTO v_s3b FROM seccion WHERE nombre='B' AND id_grado=v_g3;
  SELECT id INTO v_s4a FROM seccion WHERE nombre='A' AND id_grado=v_g4;
  SELECT id INTO v_s5a FROM seccion WHERE nombre='A' AND id_grado=v_g5;
  SELECT id INTO v_s5b FROM seccion WHERE nombre='B' AND id_grado=v_g5;
  SELECT id INTO v_med  FROM carrera WHERE nombre='Medicina Humana';
  SELECT id INTO v_enf  FROM carrera WHERE nombre='Enfermería';
  SELECT id INTO v_civil FROM carrera WHERE nombre='Ingeniería Civil';
  SELECT id INTO v_sistemas FROM carrera WHERE nombre='Ingeniería de Sistemas';
  SELECT id INTO v_der  FROM carrera WHERE nombre='Derecho';

  INSERT INTO alumno (nombres,apellido_paterno,apellido_materno,dni,celular,direccion,fecha_nacimiento,id_grado,id_seccion,id_carrera,colegio) VALUES
    ('José Miguel','Apaza','Quispe','70123456','961111111','Jr. Los Olivos 123','2009-03-15',v_g5,v_s5a,v_med,'San José'),
    ('Lucía Fernanda','Coa','Llanque','70234567','962222222','Av. Central 456','2009-07-22',v_g5,v_s5a,v_med,'San José'),
    ('Kevin Alexander','Flores','Mamani','70345678','963333333','Calle Real 789','2009-11-10',v_g5,v_s5b,v_med,'San José'),
    ('Diana Sofía','Mamani','Condori','70456789','964444444','Jr. Puno 321','2010-01-05',v_g5,v_s5a,v_sistemas,'San José'),
    ('Anderson Raúl','Ticona','Chura','70567890','965555555','Av. Perú 654','2009-09-30',v_g4,v_s4a,v_civil,'San José'),
    ('Valeria Nicole','Calsin','Yana','70678901','966666666','Jr. Arequipa 987','2011-04-18',v_g3,v_s3a,v_der,'San José'),
    ('Jhon Brayan','Quispe','Huanca','70789012','967777777','Calle Lima 147','2011-08-25',v_g3,v_s3b,v_der,'San José'),
    ('Camila Belén','Cruz','Mamani','70890123','968888888','Av. Cusco 258','2012-02-14',v_g2,v_s2a,v_med,'San José'),
    ('Luis Ángel','Yucra','Estrada','70901234','969999999','Jr. Huánuco 369','2012-06-01',v_g2,v_s2b,v_sistemas,'San José'),
    ('Nikol Araceli','Huanca','Flores','71012345','961010101','Calle Tacna 741','2010-12-20',v_g4,v_s4a,v_civil,'San José')
  ON CONFLICT (dni) DO NOTHING;
END $$;

-- ── EXÁMENES ─────────────────────────────────────────────────────
DO $$ DECLARE
  v_g5 INT; v_salud INT;
BEGIN
  SELECT id INTO v_g5   FROM grado WHERE nombre='5to Secundaria';
  SELECT id INTO v_salud FROM area WHERE nombre='Ciencias de la Salud';
  INSERT INTO examen (nombre,fecha,anio,periodo,id_grado,id_area,cantidad_preguntas,puntaje_total,estado) VALUES
    ('Simulacro 01 - Periodo 1 2026','2026-04-15',2026,'Periodo 1',v_g5,v_salud,100,100.00,'ACTIVO'),
    ('Simulacro 02 - Periodo 1 2026','2026-05-20',2026,'Periodo 1',v_g5,v_salud,100,100.00,'ACTIVO')
  ON CONFLICT DO NOTHING;
END $$;

-- ── ASIGNACIÓN DE DOCENTES Y AULAS A EXÁMENES ────────────────────
DO $$ DECLARE
  v_ex1 INT; v_ex2 INT; v_doc INT; v_aula101 INT; v_aula102 INT;
BEGIN
  SELECT id INTO v_ex1 FROM examen WHERE nombre='Simulacro 01 - Periodo 1 2026';
  SELECT id INTO v_ex2 FROM examen WHERE nombre='Simulacro 02 - Periodo 1 2026';
  SELECT id INTO v_doc FROM docente ORDER BY id LIMIT 1;
  SELECT id INTO v_aula101 FROM aula WHERE codigo='A-101';
  SELECT id INTO v_aula102 FROM aula WHERE codigo='A-102';

  INSERT INTO examen_asignacion (id_examen,id_docente,id_aula) VALUES
    (v_ex1, v_doc, v_aula101),
    (v_ex2, v_doc, v_aula102)
  ON CONFLICT DO NOTHING;
END $$;

-- ── INSCRIPCIONES (alumnos al examen 1) ──────────────────────────
DO $$ DECLARE
  v_ex1 INT; v_carreras INT[];
  v_counter INT := 0;
BEGIN
  SELECT id INTO v_ex1 FROM examen WHERE nombre='Simulacro 01 - Periodo 1 2026';
  SELECT ARRAY_AGG(id) INTO v_carreras FROM carrera;
  INSERT INTO inscripcion (codigo_inscripcion, id_alumno, id_examen, id_carrera, anio, periodo, estado)
  SELECT 'INS-' || TO_CHAR(NOW(), 'YYYYMMDD') || '-' || LPAD((row_number() OVER () + 100)::text, 4, '0'),
         a.id, v_ex1,
         COALESCE(a.id_carrera, v_carreras[1]), 2026, 'Periodo 1', 'ACTIVO'
  FROM alumno a
  WHERE a.id_grado = (SELECT id FROM grado WHERE nombre='5to Secundaria')
    AND NOT EXISTS (SELECT 1 FROM inscripcion i WHERE i.id_alumno=a.id AND i.id_examen=v_ex1);
END $$;

-- ── RESULTADOS (para los inscritos, con puntajes variados) ───────
DO $$ DECLARE
  v_ex1 INT;
  v_alumnos INT[];
  v_puntajes NUMERIC(5,2)[] := ARRAY[82.50, 91.00, 75.25, 68.00, 95.50];
  v_correctas INT[] := ARRAY[45, 50, 38, 35, 52];
  v_total INT;
  i INT;
BEGIN
  SELECT id INTO v_ex1 FROM examen WHERE nombre='Simulacro 01 - Periodo 1 2026';
  SELECT ARRAY_AGG(a.id) INTO v_alumnos FROM alumno a
    JOIN inscripcion i ON i.id_alumno=a.id AND i.id_examen=v_ex1;
  v_total := array_length(v_alumnos, 1);

  FOR i IN 1..least(v_total, 5) LOOP
    INSERT INTO resultado (id_alumno,id_examen,puntaje,correctas,incorrectas,en_blanco,porcentaje)
    VALUES (
      v_alumnos[i], v_ex1,
      v_puntajes[i],
      v_correctas[i],
      20 - v_correctas[i],
      0,
      (v_puntajes[i] / 100.0) * 100.0
    )
    ON CONFLICT (id_alumno, id_examen) DO NOTHING;
  END LOOP;
END $$;

-- Actualizar vista vw_inscripciones para incluir aula
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

-- ================================================================
-- FIN - Datos de prueba insertados
-- ================================================================
