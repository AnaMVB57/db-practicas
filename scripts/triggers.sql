
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
