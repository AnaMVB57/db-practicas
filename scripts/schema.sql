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
