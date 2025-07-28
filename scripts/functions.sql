
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



