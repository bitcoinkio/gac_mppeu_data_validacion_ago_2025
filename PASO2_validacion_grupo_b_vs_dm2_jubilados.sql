SELECT 'GRUPO_B_DEL_PASO_1' as tabla, COUNT(*) as cantidad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
WHERE dm1.cedula IS NULL
UNION ALL
SELECT 'TOTAL_DM2_JUBILADOS' as tabla, COUNT(*) as cantidad
FROM dm2_jubilados_mppe;
-- COINCIDENCIAS (GRUPO_B ∩ DM2)
SELECT 'COINCIDENCIAS_GRUPO_B_DM2' as categoria, COUNT(*) as cantidad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
INNER JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
WHERE dm1.cedula IS NULL;

-- GRUPO 2A (Jubilados sin afiliación)
SELECT 'GRUPO_2A_JUBILADOS_SIN_AFILIACION' as categoria, COUNT(*) as cantidad
FROM dm2_jubilados_mppe dm2
LEFT JOIN data_ipasme ipasme ON dm2.cedula = ipasme.cedula
WHERE ipasme.cedula IS NULL;

-- GRUPO 2B (Pendientes para DM3)
SELECT 'GRUPO_2B_AFILIADOS_NO_JUBILADOS' as categoria, COUNT(*) as cantidad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
LEFT JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
WHERE dm1.cedula IS NULL AND dm2.cedula IS NULL;
-- LISTA DETALLADA DE COINCIDENCIAS GRUPO_B ∩ DM2
SELECT 
    'COINCIDENCIA_JUBILADO' as tipo_registro,
    ipasme.cedula,
    ipasme.nombres as nombres_ipasme,
    ipasme.apellidos as apellidos_ipasme,
    dm2.nombre_apellido as nombre_completo_dm2,
    ipasme.estado as estado_residencia_ipasme,
    dm2.estado as estado_jubilacion_dm2,
    dm2.tipo_personal as tipo_jubilado,
    dm2.fecha_nacimiento,
    dm2.sexo,
    ipasme.cant_beneficiarios,
    ipasme.email,
    ipasme.celular,
    'AFILIACION_CORRECTA_EMPLEADO_JUBILADO' as observacion,
    'MANTENER_AFILIACION' as accion_requerida
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
INNER JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
WHERE dm1.cedula IS NULL
ORDER BY ipasme.estado, ipasme.apellidos, ipasme.nombres;
-- LISTA DETALLADA GRUPO 2A - Jubilados MPPE sin afiliación IPASME
SELECT 
    'GRUPO_2A' as tipo_registro,
    dm2.cedula,
    dm2.nombre_apellido as nombre_completo,
    dm2.estado as entidad_jubilacion,
    dm2.tipo_personal as tipo_jubilado,
    dm2.fecha_nacimiento,
    dm2.sexo,
    'JUBILADO_SIN_AFILIACION_IPASME' as problema_identificado,
    'EVALUAR_AFILIACION_JUBILADO' as accion_requerida,
    'ALTA' as prioridad,
    'Jubilado MPPE con derecho a IPASME no afiliado' as descripcion
FROM dm2_jubilados_mppe dm2
LEFT JOIN data_ipasme ipasme ON dm2.cedula = ipasme.cedula
WHERE ipasme.cedula IS NULL
ORDER BY dm2.estado, dm2.nombre_apellido;
-- LISTA DETALLADA GRUPO 2B - Afiliados que no son ni activos ni jubilados
SELECT 
    'GRUPO_2B' as tipo_registro,
    ipasme.cedula,
    ipasme.nombres,
    ipasme.apellidos,
    ipasme.sexo,
    ipasme.edad,
    ipasme.estado as estado_residencia,
    ipasme.municipio,
    ipasme.parroquia_localidad,
    ipasme.cant_beneficiarios,
    ipasme.email,
    ipasme.celular,
    'AFILIADO_NO_ES_NI_ACTIVO_NI_JUBILADO' as situacion,
    'VALIDAR_CONTRA_DM3_PENSIONADOS' as siguiente_paso,
    'MEDIA' as prioridad,
    'Verificar si es pensionado MPPE en PASO 3' as descripcion
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
LEFT JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
WHERE dm1.cedula IS NULL AND dm2.cedula IS NULL
ORDER BY ipasme.estado, ipasme.apellidos, ipasme.nombres;
-- Contar COINCIDENCIAS GRUPO_B ∩ DM2
SELECT 'COINCIDENCIAS_GRUPO_B_DM2' as categoria, COUNT(*) as cantidad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
INNER JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
WHERE dm1.cedula IS NULL;

-- Contar GRUPO 2A
SELECT 'GRUPO_2A_JUBILADOS_SIN_AFILIACION' as categoria, COUNT(*) as cantidad
FROM dm2_jubilados_mppe dm2
LEFT JOIN data_ipasme ipasme ON dm2.cedula = ipasme.cedula
WHERE ipasme.cedula IS NULL;

-- Contar GRUPO 2B
SELECT 'GRUPO_2B_AFILIADOS_NO_JUBILADOS' as categoria, COUNT(*) as cantidad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
LEFT JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
WHERE dm1.cedula IS NULL AND dm2.cedula IS NULL;