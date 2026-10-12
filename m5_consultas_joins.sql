-- Consulta 1 Vista base del proyecto (INNER JOIN)

SELECT 
    v.fecha_venta,
    v.id_cliente,
    c.nombre AS nombre_cliente,
    v.id_producto,
    p.nombre_preducto, --Al hacer las tablas me equivoque y en vez de producto escribi preducto
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas v
INNER JOIN clientes c ON v.id_cliente = c.id_cliente
INNER JOIN productos p ON v.id_producto = p.id_producto
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria;

-- Consulta 2 Clientes sin ventas (LEFT JOIN)

SELECT 
    c.id_cliente,
    c.nombre,
    c.email,
    c.fecha_registro
FROM clientes c
LEFT JOIN ventas v ON c.id_cliente = v.id_cliente
WHERE v.id_cliente IS NULL;

-- Consulta 3 Productos sin ventas (LEFT JOIN)

SELECT 
    p.id_producto,
    p.nombre_preducto,
    cat.nombre_categoria,
    p.precio
FROM productos p
INNER JOIN categorias cat ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas v ON p.id_producto = v.id_producto
WHERE v.id_producto IS NULL;

-- Consulta 4 Consolidado por canal (UNION ALL)

-- Actualización de los datos de canal para la actv

ALTER TABLE ventas ADD canal VARCHAR(50);

UPDATE ventas SET canal = 'Online'     WHERE id_venta = 1;
UPDATE ventas SET canal = 'Presencial' WHERE id_venta = 2;
UPDATE ventas SET canal = 'Online'     WHERE id_venta = 3;
UPDATE ventas SET canal = 'Presencial' WHERE id_venta = 4;
UPDATE ventas SET canal = 'Online'     WHERE id_venta = 5;
UPDATE ventas SET canal = 'Presencial' WHERE id_venta = 6;
UPDATE ventas SET canal = 'Online'     WHERE id_venta = 7;
UPDATE ventas SET canal = 'Presencial' WHERE id_venta = 8;
UPDATE ventas SET canal = 'Online'     WHERE id_venta = 9;
UPDATE ventas SET canal = 'Presencial' WHERE id_venta = 10;

SELECT 
    canal,
    SUM(total) AS total_canal
FROM (
    SELECT 
        id_venta,
        (cantidad * precio_unitario) AS total,
        'Online' AS canal
    FROM ventas
    WHERE id_venta IN (1, 3, 5, 7, 9)
    
    UNION ALL
    
    SELECT 
        id_venta,
        (cantidad * precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE id_venta IN (2, 4, 6, 8, 10)
) AS consolidado
GROUP BY canal;