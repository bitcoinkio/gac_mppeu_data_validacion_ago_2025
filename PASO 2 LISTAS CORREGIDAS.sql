SELECT DISTINCT
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
INNER JOIN dm2_jubilados_mppe dm2 ON ipasme.cedula = dm2.cedula
WHERE NOT EXISTS (
    SELECT 1 FROM (SELECT DISTINCT cedula FROM dm1_fijos_contratados_mppe) dm1
    WHERE dm1.cedula = ipasme.cedula
)
ORDER BY ipasme.estado, ipasme.apellidos, ipasme.nombres;