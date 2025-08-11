-- Verificar tamaños de datasets
SELECT 'GRUPO_2B_DEL_PASO_2' as tabla, COUNT(*) as cantidad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
LEFT JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
WHERE dm1.cedula IS NULL AND dm2.cedula IS NULL

UNION ALL

SELECT 'TOTAL_DM3_PENSIONADOS' as tabla, COUNT(*) as cantidad
FROM dm3_pensionados_mppe;
-- LISTA DETALLADA DE COINCIDENCIAS GRUPO_2B ∩ DM3
SELECT 
    'COINCIDENCIA_PENSIONADO' as tipo_registro,
    ipasme.cedula,
    ipasme.nombres as nombres_ipasme,
    ipasme.apellidos as apellidos_ipasme,
    dm3.nombre_apellido as nombre_completo_dm3,
    ipasme.estado as estado_residencia_ipasme,
    dm3.estado as estado_pension_dm3,
    dm3.tipo_personal as tipo_pensionado,
    dm3.fecha_nacimiento,
    dm3.sexo,
    ipasme.cant_beneficiarios,
    ipasme.email,
    ipasme.celular,
    'AFILIACION_CORRECTA_EMPLEADO_PENSIONADO' as observacion,
    'MANTENER_AFILIACION' as accion_requerida
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
LEFT JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
INNER JOIN dm3_pensionados_mppe dm3 ON ipasme.cedula = dm3.cedula
WHERE dm1.cedula IS NULL AND dm2.cedula IS NULL
ORDER BY ipasme.estado, ipasme.apellidos, ipasme.nombres;
-- LISTA DETALLADA GRUPO 3A - Pensionados MPPE sin afiliación IPASME
SELECT 
    'GRUPO_3A' as tipo_registro,
    dm3.cedula,
    dm3.nombre_apellido as nombre_completo,
    dm3.estado as entidad_pension,
    dm3.tipo_personal as tipo_pensionado,
    dm3.fecha_nacimiento,
    dm3.sexo,
    'PENSIONADO_SIN_AFILIACION_IPASME' as problema_identificado,
    'EVALUAR_AFILIACION_PENSIONADO' as accion_requerida,
    'ALTA' as prioridad,
    'Pensionado MPPE con derecho a IPASME no afiliado' as descripcion
FROM dm3_pensionados_mppe dm3
LEFT JOIN data_ipasme ipasme ON dm3.cedula = ipasme.cedula
WHERE ipasme.cedula IS NULL
ORDER BY dm3.estado, dm3.nombre_apellido;
-- LISTA DETALLADA GRUPO 3B - AFILIADOS FALSOS CONFIRMADOS
SELECT 
    'AFILIADO_FALSO_CONFIRMADO' as tipo_registro,
    ipasme.cedula,
    ipasme.nombres,
    ipasme.apellidos,
    ipasme.sexo,
    ipasme.edad,
    ipasme.estado as estado_residencia,
    ipasme.municipio,
    ipasme.parroquia_localidad,
    ipasme.cant_beneficiarios,
    ipasme.cant_beneficiarios_masculino,
    ipasme.cant_beneficiarios_femenino,
    ipasme.email,
    ipasme.celular,
    ipasme.telefono_habitacion,
    ipasme.unidad_medica,
    'AFILIADO_NO_ES_EMPLEADO_MPPE' as problema_critico,
    'REVISION_OBLIGATORIA_EXCLUSION_SISTEMA' as accion_urgente,
    'CRITICA' as prioridad,
    'NO es empleado activo, jubilado ni pensionado MPPE' as justificacion_exclusion
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
LEFT JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
LEFT JOIN dm3_pensionados_mppe dm3 ON ipasme.cedula = dm3.cedula
WHERE dm1.cedula IS NULL AND dm2.cedula IS NULL AND dm3.cedula IS NULL
ORDER BY ipasme.cant_beneficiarios DESC, ipasme.estado, ipasme.apellidos;
-- Contar COINCIDENCIAS GRUPO_2B ∩ DM3
SELECT 'COINCIDENCIAS_GRUPO_2B_DM3' as categoria, COUNT(*) as cantidad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
LEFT JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
INNER JOIN dm3_pensionados_mppe dm3 ON ipasme.cedula = dm3.cedula
WHERE dm1.cedula IS NULL AND dm2.cedula IS NULL;

-- Contar GRUPO 3A
SELECT 'GRUPO_3A_PENSIONADOS_SIN_AFILIACION' as categoria, COUNT(*) as cantidad
FROM dm3_pensionados_mppe dm3
LEFT JOIN data_ipasme ipasme ON dm3.cedula = ipasme.cedula
WHERE ipasme.cedula IS NULL;

-- Contar GRUPO 3B (AFILIADOS FALSOS)
SELECT 'GRUPO_3B_AFILIADOS_FALSOS_CONFIRMADOS' as categoria, COUNT(*) as cantidad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
LEFT JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
LEFT JOIN dm3_pensionados_mppe dm3 ON ipasme.cedula = dm3.cedula
WHERE dm1.cedula IS NULL AND dm2.cedula IS NULL AND dm3.cedula IS NULL;