USE ValidacionIPASME_MPPE;
SELECT DATABASE();
SHOW TABLES;
DESCRIBE dm1_fijos_contratados_mppe;
SELECT COUNT(*) as total_registros 
FROM dm1_fijos_contratados_mppe;
SELECT 
    entidad,
    cedula,
    nombre_completo,
    cargo,
    status_empleado
FROM dm1_fijos_contratados_mppe 
LIMIT 10;
SELECT 
    entidad,
    COUNT(*) as cantidad
FROM dm1_fijos_contratados_mppe 
GROUP BY entidad
ORDER BY cantidad DESC;