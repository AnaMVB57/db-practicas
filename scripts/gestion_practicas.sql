CREATE TYPE "modalidad_estudio" AS ENUM (
  'VIRTUAL',
  'PRESENCIAL',
  'DISTANCIA'
);

CREATE TYPE "estado_asignatura" AS ENUM (
  'APROBADO',
  'REPROBADO',
  'PENDIENTE'
);

CREATE TYPE "tipo_materia_cursada" AS ENUM (
  'REPETIDA',
  'HOMOLOGADA'
);

CREATE TYPE "tipo_documento" AS ENUM (
  'C.C.',
  'C.E.',
  'Pasaporte'
);

CREATE TYPE "tipo_contrato_practica" AS ENUM (
  'CONTRATO_APRENDIZAJE',
  'CONVENIO_PRACTICAS'
);

CREATE TYPE "estado_practica" AS ENUM (
  'EN_CURSO',
  'APROBADA',
  'REPROBADA',
  'CANCELADA'
);

CREATE TYPE "tipo_visita" AS ENUM (
  'I',
  'II'
);

CREATE TYPE "tipo_evaluador" AS ENUM (
  'JEFE',
  'ESTUDIANTE',
  'DEP'
);

CREATE TYPE "estado_documento_practica" AS ENUM (
  'PENDIENTE',
  'APROBADO',
  'RECHAZADO'
);

CREATE TYPE "rol_usuario" AS ENUM (
  'ADMIN',
  'DOCENTE',
  'ESTUDIANTE',
  'COORDINADOR',
  'JEFE'
);

CREATE TABLE "facultad" (
  "id" bigint PRIMARY KEY,
  "nombre" text,
  "activo" boolean
);

CREATE TABLE "programa" (
  "id" bigint PRIMARY KEY,
  "nombre" text,
  "facultad_id" bigint,
  "creditos_totales" int,
  "activo" boolean
);

CREATE TABLE "responsable_sede" (
  "id" bigint PRIMARY KEY,
  "nombre" text,
  "telefono" text,
  "correo" text,
  "activo" boolean
);

CREATE TABLE "sede_facultad" (
  "id" bigint PRIMARY KEY,
  "sede_id" bigint,
  "facultad_id" bigint,
  "activo" boolean
);

CREATE TABLE "sede" (
  "id" bigint PRIMARY KEY,
  "nombre" text,
  "direccion" text,
  "responsable_id" bigint,
  "activo" boolean
);

CREATE TABLE "plan_academico" (
  "id" bigint PRIMARY KEY,
  "codigo" text,
  "anio_inicio" int,
  "programa_id" bigint,
  "activo" boolean
);

CREATE TABLE "asignatura" (
  "id" bigint PRIMARY KEY,
  "codigo" text,
  "nombre" text,
  "creditos" int,
  "activo" boolean
);

CREATE TABLE "asignatura_plan" (
  "id" bigint PRIMARY KEY,
  "plan_id" bigint,
  "asignatura_id" bigint,
  "semestre_recomendado" int,
  "obligatorio" boolean,
  "activo" boolean
);

CREATE TABLE "semestre_academico" (
  "id" bigint PRIMARY KEY,
  "estudiante_id" bigint,
  "anio" int,
  "periodo" int,
  "numero_semestre" int,
  "activo" boolean
);

CREATE TABLE "cursada_asignatura" (
  "id" bigint PRIMARY KEY,
  "semestre_id" bigint,
  "asignatura_id" bigint,
  "nota" float,
  "estado" estado_asignatura,
  "tipo_cursada" tipo_materia_cursada,
  "activo" boolean
);

CREATE TABLE "reporte_academico" (
  "id" bigint PRIMARY KEY,
  "estudiante_id" bigint,
  "sede_id" bigint,
  "programa_id" bigint,
  "modalidad_estudio" modalidad_estudio,
  "promedio_acumulado" float,
  "semestre" int,
  "creditos_aprobados" int,
  "habilitado_practica" boolean,
  "activo" boolean
);

CREATE TABLE "ciudad" (
  "id" bigint PRIMARY KEY,
  "nombre" text,
  "departamento_id" bigint,
  "activo" boolean
);

CREATE TABLE "departamento" (
  "id" bigint PRIMARY KEY,
  "nombre" text,
  "activo" boolean
);

CREATE TABLE "estudiante" (
  "id" bigint PRIMARY KEY,
  "documento" text,
  "tipo_documento" tipo_documento,
  "nombre" text,
  "apellido" text,
  "email" text,
  "telefono" text,
  "depto_residencia_id" bigint,
  "activo" boolean
);

CREATE TABLE "empresa" (
  "id" bigint PRIMARY KEY,
  "nombre" text,
  "direccion" text,
  "telefono" text,
  "email" text,
  "activo" boolean
);

CREATE TABLE "docente" (
  "id" bigint PRIMARY KEY,
  "nombre" text,
  "apellido" text,
  "email" text,
  "telefono" text,
  "activo" boolean
);

CREATE TABLE "practica" (
  "id" bigint PRIMARY KEY,
  "empresa_id" bigint,
  "estudiante_id" bigint,
  "docente_id" bigint,
  "sede_id" bigint,
  "tipo_contrato" tipo_contrato_practica,
  "fecha_inicio" date,
  "fecha_fin" date,
  "horas_totales" int,
  "calificacion_final" float,
  "activo" boolean
);

CREATE TABLE "visita_seguimiento" (
  "id" bigint PRIMARY KEY,
  "tipo" tipo_visita,
  "practica_id" bigint,
  "fecha" date,
  "observaciones" text,
  "activo" boolean
);

CREATE TABLE "evaluacion" (
  "id" bigint PRIMARY KEY,
  "visita_id" bigint,
  "evaluador" tipo_evaluador,
  "calificacion" int,
  "competencias_evaluadas" jsonb,
  "comentarios" text,
  "fecha_evaluacion" timestamp,
  "activo" boolean
);

CREATE TABLE "tipo_documento_practica" (
  "id" bigint PRIMARY KEY,
  "nombre" text,
  "activo" boolean
);

CREATE TABLE "expediente_practica" (
  "id" bigint PRIMARY KEY,
  "practica_id" bigint,
  "tipo_documento_id" bigint,
  "ruta_archivo" text,
  "fecha_subida" timestamp,
  "estado_doc" estado_documento_practica,
  "activo" boolean
);

CREATE TABLE "usuario" (
  "id" bigint PRIMARY KEY,
  "correo" varchar(150) UNIQUE NOT NULL,
  "contrasena_hash" varchar(255) NOT NULL,
  "rol" rol_usuario NOT NULL,
  "nombre_completo" varchar(150),
  "creado_en" timestamp DEFAULT (now()),
  "activo" boolean DEFAULT true
);

CREATE TABLE "documento_practica" (
  "id" bigint PRIMARY KEY,
  "practica_id" bigint,
  "tipo_documento" text,
  "nombre_archivo" text,
  "contenido" bytea,
  "url" text,
  "fecha_subida" timestamp,
  "subido_por" bigint,
  "activo" boolean
);

CREATE TABLE "auditoria" (
  "id" bigint PRIMARY KEY,
  "tabla_afectada" text,
  "id_registro" bigint,
  "operacion" text,
  "datos_anteriores" jsonb,
  "datos_nuevos" jsonb,
  "usuario_id" bigint,
  "fecha" timestamp
);

ALTER TABLE "programa" ADD FOREIGN KEY ("facultad_id") REFERENCES "facultad" ("id");

ALTER TABLE "sede_facultad" ADD FOREIGN KEY ("sede_id") REFERENCES "sede" ("id");

ALTER TABLE "sede_facultad" ADD FOREIGN KEY ("facultad_id") REFERENCES "facultad" ("id");

ALTER TABLE "sede" ADD FOREIGN KEY ("responsable_id") REFERENCES "responsable_sede" ("id");

ALTER TABLE "plan_academico" ADD FOREIGN KEY ("programa_id") REFERENCES "programa" ("id");

ALTER TABLE "asignatura_plan" ADD FOREIGN KEY ("plan_id") REFERENCES "plan_academico" ("id");

ALTER TABLE "asignatura_plan" ADD FOREIGN KEY ("asignatura_id") REFERENCES "asignatura" ("id");

ALTER TABLE "semestre_academico" ADD FOREIGN KEY ("estudiante_id") REFERENCES "estudiante" ("id");

ALTER TABLE "cursada_asignatura" ADD FOREIGN KEY ("semestre_id") REFERENCES "semestre_academico" ("id");

ALTER TABLE "cursada_asignatura" ADD FOREIGN KEY ("asignatura_id") REFERENCES "asignatura" ("id");

ALTER TABLE "reporte_academico" ADD FOREIGN KEY ("estudiante_id") REFERENCES "estudiante" ("id");

ALTER TABLE "reporte_academico" ADD FOREIGN KEY ("sede_id") REFERENCES "sede" ("id");

ALTER TABLE "reporte_academico" ADD FOREIGN KEY ("programa_id") REFERENCES "programa" ("id");

ALTER TABLE "ciudad" ADD FOREIGN KEY ("departamento_id") REFERENCES "departamento" ("id");

ALTER TABLE "estudiante" ADD FOREIGN KEY ("depto_residencia_id") REFERENCES "departamento" ("id");

ALTER TABLE "practica" ADD FOREIGN KEY ("empresa_id") REFERENCES "empresa" ("id");

ALTER TABLE "practica" ADD FOREIGN KEY ("estudiante_id") REFERENCES "estudiante" ("id");

ALTER TABLE "practica" ADD FOREIGN KEY ("docente_id") REFERENCES "docente" ("id");

ALTER TABLE "practica" ADD FOREIGN KEY ("sede_id") REFERENCES "sede" ("id");

ALTER TABLE "visita_seguimiento" ADD FOREIGN KEY ("practica_id") REFERENCES "practica" ("id");

ALTER TABLE "evaluacion" ADD FOREIGN KEY ("visita_id") REFERENCES "visita_seguimiento" ("id");

ALTER TABLE "expediente_practica" ADD FOREIGN KEY ("practica_id") REFERENCES "practica" ("id");

ALTER TABLE "expediente_practica" ADD FOREIGN KEY ("tipo_documento_id") REFERENCES "tipo_documento_practica" ("id");

ALTER TABLE "documento_practica" ADD FOREIGN KEY ("practica_id") REFERENCES "practica" ("id");

ALTER TABLE "documento_practica" ADD FOREIGN KEY ("subido_por") REFERENCES "usuario" ("id");

ALTER TABLE "auditoria" ADD FOREIGN KEY ("usuario_id") REFERENCES "usuario" ("id");


CREATE OR REPLACE FUNCTION dias_habiles(fecha_inicio DATE, fecha_fin DATE)
RETURNS INTEGER AS $$
DECLARE
    contador INTEGER := 0;
    fecha_actual DATE := fecha_inicio;
BEGIN
    WHILE fecha_actual <= fecha_fin LOOP
        IF EXTRACT(DOW FROM fecha_actual) NOT IN (0, 6) THEN 
            contador := contador + 1;
        END IF;
        fecha_actual := fecha_actual + 1;
    END LOOP;
    RETURN contador;
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION nota_final(est_id BIGINT)
RETURNS NUMERIC AS $$
DECLARE
    suma NUMERIC := 0;
    cantidad INTEGER := 0;
BEGIN
    SELECT COALESCE(SUM(nota_parcial), 0), COUNT(*)
    INTO suma, cantidad
    FROM seguimiento
    WHERE estudiante_id = est_id;

    IF cantidad = 0 THEN
        RETURN NULL;
    ELSE
        RETURN ROUND(suma / cantidad, 2);
    END IF;
END;
$$ LANGUAGE plpgsql;

-- 1. Facultades
INSERT INTO facultad (id, nombre, activo) VALUES
(1, 'Facultad de Ingeniería', true),
(2, 'Facultad de Ciencias', true),
(3, 'Facultad de Medicina', true),
(4, 'Facultad de Derecho', true),
(5, 'Facultad de Economía', true),
(6, 'Facultad de Educación', true),
(7, 'Facultad de Artes', true),
(8, 'Facultad de Psicología', true),
(9, 'Facultad de Ciencias Sociales', true),
(10, 'Facultad de Ciencias Agrarias', true);

-- 2. Responsables de sede
INSERT INTO responsable_sede (id, nombre, telefono, correo, activo) VALUES
(1, 'Carlos Mendoza', '3101234567', 'c.mendoza@universidad.edu', true),
(2, 'Ana Gutiérrez', '3202345678', 'a.gutierrez@universidad.edu', true),
(3, 'Luis Ramírez', '3003456789', 'l.ramirez@universidad.edu', true),
(4, 'María López', '3154567890', 'm.lopez@universidad.edu', true),
(5, 'Jorge Sánchez', '3185678901', 'j.sanchez@universidad.edu', true),
(6, 'Patricia Díaz', '3196789012', 'p.diaz@universidad.edu', true),
(7, 'Ricardo Torres', '3127890123', 'r.torres@universidad.edu', true),
(8, 'Sofía Castro', '3148901234', 's.castro@universidad.edu', true),
(9, 'Andrés Gómez', '3179012345', 'a.gomez@universidad.edu', true),
(10, 'Laura Herrera', '3130123456', 'l.herrera@universidad.edu', true);

-- 3. Sedes
INSERT INTO sede (id, nombre, direccion, responsable_id, activo) VALUES
(1, 'Sede Central', 'Calle 123 #45-67', 1, true),
(2, 'Sede Norte', 'Avenida 456 #78-90', 2, true),
(3, 'Sede Sur', 'Carrera 789 #12-34', 3, true),
(4, 'Sede Occidente', 'Diagonal 234 #56-78', 4, true),
(5, 'Sede Oriente', 'Transversal 567 #89-01', 5, true),
(6, 'Sede Tecnológica', 'Calle 890 #23-45', 6, true),
(7, 'Sede de Postgrados', 'Avenida 123 #45-67', 7, true),
(8, 'Sede Virtual', 'Carrera 456 #78-90', 8, true),
(9, 'Sede Internacional', 'Calle 789 #12-34', 9, true),
(10, 'Sede Experimental', 'Avenida 234 #56-78', 10, true);

-- 4. Sedes por facultad
INSERT INTO sede_facultad (id, sede_id, facultad_id, activo) VALUES
(1, 1, 1, true),
(2, 1, 2, true),
(3, 2, 3, true),
(4, 3, 4, true),
(5, 4, 5, true),
(6, 5, 6, true),
(7, 6, 7, true),
(8, 7, 8, true),
(9, 8, 9, true),
(10, 9, 10, true);

-- 5. Programas académicos
INSERT INTO programa (id, nombre, facultad_id, creditos_totales, activo) VALUES
(1, 'Ingeniería de Sistemas', 1, 160, true),
(2, 'Matemáticas', 2, 150, true),
(3, 'Medicina', 3, 200, true),
(4, 'Derecho', 4, 170, true),
(5, 'Economía', 5, 155, true),
(6, 'Licenciatura en Educación', 6, 165, true),
(7, 'Artes Plásticas', 7, 145, true),
(8, 'Psicología', 8, 175, true),
(9, 'Sociología', 9, 160, true),
(10, 'Agronomía', 10, 180, true);

-- 6. Departamentos
INSERT INTO departamento (id, nombre, activo) VALUES
(1, 'Antioquia', true),
(2, 'Bogotá D.C.', true),
(3, 'Valle del Cauca', true),
(4, 'Santander', true),
(5, 'Atlántico', true),
(6, 'Bolívar', true),
(7, 'Cundinamarca', true),
(8, 'Nariño', true),
(9, 'Córdoba', true),
(10, 'Boyacá', true);

-- 7. Ciudades
INSERT INTO ciudad (id, nombre, departamento_id, activo) VALUES
(1, 'Medellín', 1, true),
(2, 'Bogotá', 2, true),
(3, 'Cali', 3, true),
(4, 'Bucaramanga', 4, true),
(5, 'Barranquilla', 5, true),
(6, 'Cartagena', 6, true),
(7, 'Soacha', 7, true),
(8, 'Pasto', 8, true),
(9, 'Montería', 9, true),
(10, 'Tunja', 10, true);

-- 8. Usuarios
INSERT INTO usuario (id, correo, contrasena_hash, rol, nombre_completo, activo) VALUES
(1, 'admin@universidad.edu', 'hash123', 'ADMIN', 'Administrador Principal', true),
(2, 'coordinador@universidad.edu', 'hash456', 'COORDINADOR', 'Coordinador de Prácticas', true),
(3, 'docente1@universidad.edu', 'hash789', 'DOCENTE', 'Profesor Juan Pérez', true),
(4, 'docente2@universidad.edu', 'hash012', 'DOCENTE', 'Profesora María Gómez', true),
(5, 'estudiante1@universidad.edu', 'hash345', 'ESTUDIANTE', 'Carlos Rodríguez', true),
(6, 'estudiante2@universidad.edu', 'hash678', 'ESTUDIANTE', 'Ana López', true),
(7, 'jefe1@empresa.com', 'hash901', 'JEFE', 'Jorge Martínez', true),
(8, 'jefe2@empresa.com', 'hash234', 'JEFE', 'Luisa Fernández', true),
(9, 'coordinador2@universidad.edu', 'hash567', 'COORDINADOR', 'Coordinador Secundario', true),
(10, 'docente3@universidad.edu', 'hash890', 'DOCENTE', 'Profesor Andrés Ramírez', true);

-- 9. Docentes
INSERT INTO docente (id, nombre, apellido, email, telefono, activo) VALUES
(1, 'Juan', 'Pérez', 'j.perez@universidad.edu', '3101111111', true),
(2, 'María', 'Gómez', 'm.gomez@universidad.edu', '3202222222', true),
(3, 'Carlos', 'López', 'c.lopez@universidad.edu', '3003333333', true),
(4, 'Ana', 'Martínez', 'a.martinez@universidad.edu', '3154444444', true),
(5, 'Luis', 'Rodríguez', 'l.rodriguez@universidad.edu', '3185555555', true),
(6, 'Patricia', 'García', 'p.garcia@universidad.edu', '3196666666', true),
(7, 'Ricardo', 'Fernández', 'r.fernandez@universidad.edu', '3127777777', true),
(8, 'Sofía', 'Díaz', 's.diaz@universidad.edu', '3148888888', true),
(9, 'Andrés', 'Ramírez', 'a.ramirez@universidad.edu', '3179999999', true),
(10, 'Laura', 'Hernández', 'l.hernandez@universidad.edu', '3130000000', true);

-- 10. Empresas
INSERT INTO empresa (id, nombre, direccion, telefono, email, activo) VALUES
(1, 'Tech Solutions SAS', 'Calle 100 #25-30', '6011234567', 'contacto@techsolutions.com', true),
(2, 'Innovación Digital', 'Avenida 68 #12-45', '6012345678', 'info@innovaciondigital.com', true),
(3, 'Consultores Asociados', 'Carrera 45 #26-10', '6013456789', 'consultas@casociados.com', true),
(4, 'Servicios Integrales', 'Diagonal 25 #34-56', '6014567890', 'servicios@integrales.com', true),
(5, 'Desarrollo Global', 'Transversal 8 #45-67', '6015678901', 'contact@desarrolloglobal.com', true),
(6, 'Soluciones Empresariales', 'Calle 72 #12-34', '6016789012', 'soluciones@empresariales.com', true),
(7, 'Gestión Estratégica', 'Avenida 19 #56-78', '6017890123', 'gestion@estrategica.com', true),
(8, 'Tecnología Avanzada', 'Carrera 11 #22-33', '6018901234', 'info@tecnoavanzada.com', true),
(9, 'Consultoría Profesional', 'Diagonal 34 #45-56', '6019012345', 'consultoria@profesional.com', true),
(10, 'Servicios Tecnológicos', 'Calle 56 #67-78', '6010123456', 'servicios@tecnologicos.com', true);

-- 11. Estudiantes
INSERT INTO estudiante (id, documento, tipo_documento, nombre, apellido, email, telefono, depto_residencia_id, activo) VALUES
(1, '1000123456', 'C.C.', 'Carlos', 'Rodríguez', 'c.rodriguez@universidad.edu', '3101111111', 1, true),
(2, '2000234567', 'C.C.', 'Ana', 'López', 'a.lopez@universidad.edu', '3202222222', 2, true),
(3, '3000345678', 'C.C.', 'Luis', 'Gómez', 'l.gomez@universidad.edu', '3003333333', 3, true),
(4, '4000456789', 'C.C.', 'María', 'Martínez', 'm.martinez@universidad.edu', '3154444444', 4, true),
(5, '5000567890', 'C.C.', 'Jorge', 'Sánchez', 'j.sanchez@universidad.edu', '3185555555', 5, true),
(6, '6000678901', 'C.C.', 'Patricia', 'Díaz', 'p.diaz@universidad.edu', '3196666666', 6, true),
(7, '7000789012', 'C.C.', 'Ricardo', 'Torres', 'r.torres@universidad.edu', '3127777777', 7, true),
(8, '8000890123', 'C.C.', 'Sofía', 'Castro', 's.castro@universidad.edu', '3148888888', 8, true),
(9, '9000901234', 'C.E.', 'Andrés', 'Gómez', 'a.gomez@universidad.edu', '3179999999', 9, true),
(10, '1000012345', 'Pasaporte', 'Laura', 'Herrera', 'l.herrera@universidad.edu', '3130000000', 10, true);

-- 12. Planes académicos
INSERT INTO plan_academico (id, codigo, anio_inicio, programa_id, activo) VALUES
(1, 'PING-2020', 2020, 1, true),
(2, 'PMAT-2020', 2020, 2, true),
(3, 'PMED-2020', 2020, 3, true),
(4, 'PDER-2020', 2020, 4, true),
(5, 'PECO-2020', 2020, 5, true),
(6, 'PEDU-2020', 2020, 6, true),
(7, 'PART-2020', 2020, 7, true),
(8, 'PSIC-2020', 2020, 8, true),
(9, 'PSOC-2020', 2020, 9, true),
(10, 'PAGR-2020', 2020, 10, true);

-- 13. Asignaturas
INSERT INTO asignatura (id, codigo, nombre, creditos, activo) VALUES
(1, 'ING101', 'Programación Básica', 4, true),
(2, 'MAT101', 'Cálculo Diferencial', 4, true),
(3, 'MED101', 'Anatomía General', 6, true),
(4, 'DER101', 'Derecho Civil I', 4, true),
(5, 'ECO101', 'Microeconomía', 4, true),
(6, 'EDU101', 'Pedagogía General', 4, true),
(7, 'ART101', 'Dibujo Básico', 3, true),
(8, 'PSI101', 'Psicología General', 4, true),
(9, 'SOC101', 'Sociología General', 4, true),
(10, 'AGR101', 'Suelos y Fertilizantes', 4, true);

-- 14. Asignaturas por plan
INSERT INTO asignatura_plan (id, plan_id, asignatura_id, semestre_recomendado, obligatorio, activo) VALUES
(1, 1, 1, 1, true, true),
(2, 2, 2, 1, true, true),
(3, 3, 3, 1, true, true),
(4, 4, 4, 1, true, true),
(5, 5, 5, 1, true, true),
(6, 6, 6, 1, true, true),
(7, 7, 7, 1, true, true),
(8, 8, 8, 1, true, true),
(9, 9, 9, 1, true, true),
(10, 10, 10, 1, true, true);

-- 15. Semestres académicos
INSERT INTO semestre_academico (id, estudiante_id, anio, periodo, numero_semestre, activo) VALUES
(1, 1, 2023, 1, 1, true),
(2, 2, 2023, 1, 1, true),
(3, 3, 2023, 1, 1, true),
(4, 4, 2023, 1, 1, true),
(5, 5, 2023, 1, 1, true),
(6, 6, 2023, 1, 1, true),
(7, 7, 2023, 1, 1, true),
(8, 8, 2023, 1, 1, true),
(9, 9, 2023, 1, 1, true),
(10, 10, 2023, 1, 1, true);

-- 16. Cursadas de asignaturas
INSERT INTO cursada_asignatura (id, semestre_id, asignatura_id, nota, estado, tipo_cursada, activo) VALUES
(1, 1, 1, 4.5, 'APROBADO', 'REPETIDA', true),
(2, 2, 2, 3.8, 'APROBADO', NULL, true),
(3, 3, 3, 2.9, 'REPROBADO', NULL, true),
(4, 4, 4, 4.2, 'APROBADO', NULL, true),
(5, 5, 5, 3.5, 'APROBADO', NULL, true),
(6, 6, 6, 4.7, 'APROBADO', NULL, true),
(7, 7, 7, 3.0, 'APROBADO', NULL, true),
(8, 8, 8, 4.1, 'APROBADO', NULL, true),
(9, 9, 9, 2.5, 'REPROBADO', NULL, true),
(10, 10, 10, 4.8, 'APROBADO', 'HOMOLOGADA', true);

-- 17. Reportes académicos
INSERT INTO reporte_academico (id, estudiante_id, sede_id, programa_id, modalidad_estudio, promedio_acumulado, semestre, creditos_aprobados, habilitado_practica, activo) VALUES
(1, 1, 1, 1, 'PRESENCIAL', 4.2, 5, 80, true, true),
(2, 2, 2, 2, 'PRESENCIAL', 3.9, 4, 72, true, true),
(3, 3, 3, 3, 'PRESENCIAL', 3.2, 3, 60, false, true),
(4, 4, 4, 4, 'PRESENCIAL', 4.0, 6, 90, true, true),
(5, 5, 5, 5, 'PRESENCIAL', 3.7, 5, 85, true, true),
(6, 6, 6, 6, 'PRESENCIAL', 4.5, 7, 100, true, true),
(7, 7, 7, 7, 'PRESENCIAL', 3.8, 4, 70, true, true),
(8, 8, 8, 8, 'PRESENCIAL', 4.1, 6, 95, true, true),
(9, 9, 9, 9, 'PRESENCIAL', 2.9, 3, 55, false, true),
(10, 10, 10, 10, 'PRESENCIAL', 4.3, 8, 120, true, true);

-- 18. Prácticas
INSERT INTO practica (id, empresa_id, estudiante_id, docente_id, sede_id, tipo_contrato, fecha_inicio, fecha_fin, horas_totales, calificacion_final, activo) VALUES
(1, 1, 1, 1, 1, 'CONTRATO_APRENDIZAJE', '2023-01-15', '2023-06-15', 480, 4.5, true),
(2, 2, 2, 2, 2, 'CONVENIO_PRACTICAS', '2023-02-01', '2023-07-01', 400, 4.2, true),
(3, 3, 4, 3, 4, 'CONTRATO_APRENDIZAJE', '2023-03-10', '2023-08-10', 500, 4.7, true),
(4, 4, 5, 4, 5, 'CONVENIO_PRACTICAS', '2023-01-20', '2023-06-20', 450, 3.9, true),
(5, 5, 6, 5, 6, 'CONTRATO_APRENDIZAJE', '2023-02-15', '2023-07-15', 480, 4.8, true),
(6, 6, 7, 6, 7, 'CONVENIO_PRACTICAS', '2023-03-01', '2023-08-01', 420, 4.0, true),
(7, 7, 8, 7, 8, 'CONTRATO_APRENDIZAJE', '2023-01-25', '2023-06-25', 500, 4.3, true),
(8, 8, 10, 8, 10, 'CONVENIO_PRACTICAS', '2023-02-10', '2023-07-10', 400, 4.6, true),
(9, 9, 1, 9, 1, 'CONTRATO_APRENDIZAJE', '2023-03-15', '2023-08-15', 480, 4.1, true),
(10, 10, 2, 10, 2, 'CONVENIO_PRACTICAS', '2023-01-30', '2023-06-30', 450, 4.4, true);

-- 19. Visitas de seguimiento
INSERT INTO visita_seguimiento (id, tipo, practica_id, fecha, observaciones, activo) VALUES
(1, 'I', 1, '2023-03-15', 'Buen desempeño en actividades asignadas', true),
(2, 'I', 2, '2023-04-01', 'Cumple con expectativas', true),
(3, 'I', 3, '2023-05-10', 'Requiere mejorar puntualidad', true),
(4, 'I', 4, '2023-03-20', 'Excelente integración con equipo', true),
(5, 'I', 5, '2023-04-15', 'Demuestra iniciativa', true),
(6, 'I', 6, '2023-05-01', 'Buen manejo de herramientas', true),
(7, 'I', 7, '2023-03-25', 'Necesita más autonomía', true),
(8, 'I', 8, '2023-04-10', 'Destaca en solución de problemas', true),
(9, 'II', 1, '2023-05-15', 'Mejoró en áreas señaladas', true),
(10, 'II', 2, '2023-06-01', 'Listo para evaluación final', true);

-- 20. Evaluaciones
INSERT INTO evaluacion (id, visita_id, evaluador, calificacion, competencias_evaluadas, comentarios, fecha_evaluacion, activo) VALUES
(1, 1, 'JEFE', 4, '{"puntualidad":4, "responsabilidad":5}', 'Buen desempeño general', '2023-03-16 10:00:00', true),
(2, 2, 'JEFE', 5, '{"puntualidad":5, "responsabilidad":5}', 'Excelente en todas las áreas', '2023-04-02 11:00:00', true),
(3, 3, 'JEFE', 3, '{"puntualidad":2, "responsabilidad":4}', 'Debe mejorar puntualidad', '2023-05-11 09:30:00', true),
(4, 4, 'JEFE', 4, '{"puntualidad":4, "responsabilidad":5}', 'Muy buen trabajo en equipo', '2023-03-21 14:00:00', true),
(5, 5, 'JEFE', 5, '{"puntualidad":5, "responsabilidad":5}', 'Sobresale en iniciativa', '2023-04-16 10:30:00', true),
(6, 6, 'JEFE', 4, '{"puntualidad":4, "responsabilidad":4}', 'Buen manejo técnico', '2023-05-02 11:30:00', true),
(7, 7, 'JEFE', 3, '{"puntualidad":3, "responsabilidad":3}', 'Progreso aceptable', '2023-03-26 15:00:00', true),
(8, 8, 'JEFE', 5, '{"puntualidad":5, "responsabilidad":5}', 'Excelente capacidad analítica', '2023-04-11 16:00:00', true),
(9, 9, 'DEP', 4, '{"conocimientos":4, "adaptabilidad":4}', 'Cumple con lo esperado', '2023-05-16 09:00:00', true),
(10, 10, 'DEP', 5, '{"conocimientos":5, "adaptabilidad":5}', 'Supera expectativas', '2023-06-02 10:00:00', true);

-- 21. Tipos de documento de práctica
INSERT INTO tipo_documento_practica (id, nombre, activo) VALUES
(1, 'Plan de Prácticas', true),
(2, 'Informe Semanal', true),
(3, 'Evaluación del Jefe', true),
(4, 'Autoevaluación', true),
(5, 'Informe Final', true),
(6, 'Certificado de Práctica', true),
(7, 'Acta de Inicio', true),
(8, 'Encuesta de Satisfacción', true),
(9, 'Evidencias Fotográficas', true),
(10, 'Presentación de Resultados', true);

-- 22. Expedientes de práctica
INSERT INTO expediente_practica (id, practica_id, tipo_documento_id, ruta_archivo, fecha_subida, estado_doc, activo) VALUES
(1, 1, 1, '/docs/practicas/1/plan.pdf', '2023-01-16 09:00:00', 'APROBADO', true),
(2, 2, 1, '/docs/practicas/2/plan.pdf', '2023-02-02 10:00:00', 'APROBADO', true),
(3, 3, 1, '/docs/practicas/3/plan.pdf', '2023-03-11 11:00:00', 'APROBADO', true),
(4, 4, 1, '/docs/practicas/4/plan.pdf', '2023-01-21 14:00:00', 'APROBADO', true),
(5, 5, 1, '/docs/practicas/5/plan.pdf', '2023-02-16 15:00:00', 'APROBADO', true),
(6, 6, 1, '/docs/practicas/6/plan.pdf', '2023-03-02 16:00:00', 'APROBADO', true),
(7, 7, 1, '/docs/practicas/7/plan.pdf', '2023-01-26 09:30:00', 'APROBADO', true),
(8, 8, 1, '/docs/practicas/8/plan.pdf', '2023-02-11 10:30:00', 'APROBADO', true),
(9, 9, 2, '/docs/practicas/9/informe1.pdf', '2023-03-16 11:30:00', 'PENDIENTE', true),
(10, 10, 2, '/docs/practicas/10/informe1.pdf', '2023-01-31 14:30:00', 'APROBADO', true);

-- 23. Documentos de práctica (binarios)
INSERT INTO documento_practica (id, practica_id, tipo_documento, nombre_archivo, contenido, url, fecha_subida, subido_por, activo) VALUES
(1, 1, 'Plan de Prácticas', 'plan_practica_1.pdf', NULL, '/storage/plan_practica_1.pdf', '2023-01-16 09:00:00', 5, true),
(2, 2, 'Plan de Prácticas', 'plan_practica_2.pdf', NULL, '/storage/plan_practica_2.pdf', '2023-02-02 10:00:00', 6, true),
(3, 3, 'Plan de Prácticas', 'plan_practica_3.pdf', NULL, '/storage/plan_practica_3.pdf', '2023-03-11 11:00:00', 5, true),
(4, 4, 'Informe Semanal', 'informe_semanal_4.pdf', NULL, '/storage/informe_semanal_4.pdf', '2023-01-21 14:00:00', 6, true),
(5, 5, 'Informe Semanal', 'informe_semanal_5.pdf', NULL, '/storage/informe_semanal_5.pdf', '2023-02-16 15:00:00', 5, true),
(6, 6, 'Evaluación del Jefe', 'evaluacion_jefe_6.pdf', NULL, '/storage/evaluacion_jefe_6.pdf', '2023-03-02 16:00:00', 6, true),
(7, 7, 'Autoevaluación', 'autoevaluacion_7.pdf', NULL, '/storage/autoevaluacion_7.pdf', '2023-01-26 09:30:00', 5, true),
(8, 8, 'Informe Final', 'informe_final_8.pdf', NULL, '/storage/informe_final_8.pdf', '2023-02-11 10:30:00', 6, true),
(9, 9, 'Certificado de Práctica', 'certificado_9.pdf', NULL, '/storage/certificado_9.pdf', '2023-03-16 11:30:00', 5, true),
(10, 10, 'Acta de Inicio', 'acta_inicio_10.pdf', NULL, '/storage/acta_inicio_10.pdf', '2023-01-31 14:30:00', 6, true);


CREATE OR REPLACE FUNCTION porc_creditos_aprobados(est_id BIGINT)
RETURNS NUMERIC AS $$
DECLARE
    creditos_aprobados INTEGER;
    creditos_totales INTEGER;
BEGIN
    SELECT e.creditos_aprobados, e.creditos_totales
    INTO creditos_aprobados, creditos_totales
    FROM estudiante e
    WHERE e.id = est_id;

    IF creditos_totales = 0 THEN
        RETURN 0;
    END IF;

    RETURN ROUND(creditos_aprobados::NUMERIC / creditos_totales * 100, 2);
END;
$$ LANGUAGE plpgsql;


CREATE OR REPLACE FUNCTION esta_habilitado(est_id BIGINT)
RETURNS BOOLEAN AS $$
DECLARE
    porcentaje NUMERIC;
BEGIN
    porcentaje := porc_creditos_aprobados(est_id);
    RETURN porcentaje >= 70;
END;
$$ LANGUAGE plpgsql;




CREATE OR REPLACE FUNCTION fn_auditoria_general()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO auditoria(tabla_afectada, operacion, usuario, registro_anterior, registro_nuevo)
    VALUES (
        TG_TABLE_NAME,
        TG_OP,
        current_user,
        to_jsonb(OLD),
        to_jsonb(NEW)
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;


DROP TRIGGER IF EXISTS tr_auditoria_estudiante ON estudiante;
CREATE TRIGGER tr_auditoria_estudiante
AFTER INSERT OR UPDATE OR DELETE ON estudiante
FOR EACH ROW
EXECUTE FUNCTION fn_auditoria_general();

DROP TABLE IF EXISTS log_documentos;
CREATE TABLE log_documentos (
    id SERIAL PRIMARY KEY,
    documento_id INTEGER,
    tipo TEXT,
    operacion TEXT,
    usuario TEXT,
    fecha TIMESTAMP DEFAULT now()
);

CREATE OR REPLACE FUNCTION fn_log_documentos()
RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO log_documentos(documento_id, tipo, operacion, usuario)
    VALUES (
        COALESCE(NEW.id, OLD.id),
        COALESCE(NEW.tipo, OLD.tipo),
        TG_OP,
        current_user
    );
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS tr_log_documentos ON documentos;
CREATE TRIGGER tr_log_documentos
AFTER INSERT OR UPDATE ON documentos
FOR EACH ROW
EXECUTE FUNCTION fn_log_documentos();

