SELECT 'TOTAL_DATA_IPASME' as tabla, COUNT(*) as cantidad FROM data_ipasme
UNION ALL
SELECT 'TOTAL_DM1_ACTIVOS' as tabla, COUNT(*) as cantidad FROM dm1_fijos_contratados_mppe;
SELECT 'COINCIDENCIAS_IPASME_DM1' as categoria, COUNT(*) as cantidad
FROM data_ipasme ipasme
INNER JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula;
SELECT 'GRUPO_A_EMPLEADOS_SIN_AFILIACION' as categoria, COUNT(*) as cantidad
FROM dm1_fijos_contratados_mppe dm1
LEFT JOIN data_ipasme ipasme ON dm1.cedula = ipasme.cedula
WHERE ipasme.cedula IS NULL;
SELECT 'GRUPO_B_AFILIADOS_NO_ACTIVOS' as categoria, COUNT(*) as cantidad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
WHERE dm1.cedula IS NULL;
-- LISTA DETALLADA GRUPO A - Empleados MPPE sin afiliación IPASME
SELECT 
    'GRUPO_A' as tipo_registro,
    dm1.cedula,
    dm1.nombre_completo,
    dm1.entidad,
    dm1.cargo,
    dm1.status_empleado,
    dm1.sexo,
    dm1.fecha_nacimiento,
    'EMPLEADO_ACTIVO_SIN_AFILIACION_IPASME' as problema_identificado,
    'EVALUAR_AFILIACION_OBLIGATORIA' as accion_requerida,
    'ALTA' as prioridad
FROM dm1_fijos_contratados_mppe dm1
LEFT JOIN data_ipasme ipasme ON dm1.cedula = ipasme.cedula
WHERE ipasme.cedula IS NULL
ORDER BY dm1.entidad, dm1.nombre_completo;
-- LISTA DETALLADA GRUPO B - Afiliados IPASME que no son empleados activos
SELECT 
    'GRUPO_B' as tipo_registro,
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
    'AFILIADO_NO_ES_EMPLEADO_ACTIVO' as situacion,
    'VALIDAR_CONTRA_DM2_JUBILADOS' as siguiente_paso,
    'MEDIA' as prioridad
FROM data_ipasme ipasme
LEFT JOIN dm1_fijos_contratados_mppe dm1 ON ipasme.cedula = dm1.cedula
WHERE dm1.cedula IS NULL
ORDER BY ipasme.estado, ipasme.apellidos, ipasme.nombres;
-- LISTA DETALLADA DE COINCIDENCIAS DM1 ∩ IPASME
-- Empleados activos MPPE con afiliación IPASME correcta
SELECT 
    'COINCIDENCIA_EMPLEADO_ACTIVO' as tipo_registro,
    dm1.cedula,
    dm1.nombre_completo as nombre_completo_dm1,
    ipasme.nombres as nombres_ipasme,
    ipasme.apellidos as apellidos_ipasme,
    dm1.entidad as entidad_mppe,
    ipasme.estado as estado_residencia_ipasme,
    dm1.cargo,
    dm1.status_empleado,
    dm1.sexo,
    dm1.fecha_nacimiento,
    ipasme.cant_beneficiarios,
    ipasme.cant_beneficiarios_masculino,
    ipasme.cant_beneficiarios_femenino,
    ipasme.email,
    ipasme.celular,
    ipasme.telefono_habitacion,
    ipasme.unidad_medica,
    'AFILIACION_CORRECTA_EMPLEADO_ACTIVO' as observacion,
    'MANTENER_AFILIACION' as accion_requerida,
    'VALIDADO' as status_validacion
FROM dm1_fijos_contratados_mppe dm1
INNER JOIN data_ipasme ipasme ON dm1.cedula = ipasme.cedula
ORDER BY dm1.entidad, dm1.nombre_completo;