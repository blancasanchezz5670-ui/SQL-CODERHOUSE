--Consulta 1 RESUMEN EJECUTIVO MENSUAL

Select 
MONTH(fecha_venta) AS Mes,
SUM(cantidad * precio_unitario) AS Total_facturado,
COUNT(*) AS Cantidad_de_pedido,
AVG (cantidad * precio_unitario) AS Ticket_promedio
FROM VENTAS
GROUP BY MONTH(fecha_venta);

--Consulta 2 Ranking de productos

SELECT TOP 5
id_producto,
SUM(cantidad) AS Unidades_vendidas,
SUM(cantidad * precio_unitario) AS Total_generado
FROM VENTAS
GROUP BY id_producto
ORDER BY Total_generado DESC;

--Consulta 3 Clientes recurrentes 

SELECT
id_cliente,
SUM(cantidad) AS Cant_pedidos,
SUM(cantidad * precio_unitario) AS Total_gastado
FROM VENTAS
GROUP BY id_cliente HAVING COUNT (*) > 1

--Consulta 4 Meses por encima/debajo del promedio

SELECT 
    Mes,
    Total_facturado,
    CASE 
        WHEN Total_facturado > (
            SELECT AVG(Total_Mes) 
            FROM (
                SELECT SUM(cantidad * precio_unitario) AS Total_Mes 
                FROM VENTAS 
                GROUP BY MONTH(fecha_venta)
            ) AS PromediosMensuales
        ) THEN 'Por encima'
        ELSE 'Por debajo'
    END AS Categoria_Promedio
FROM (
    SELECT MONTH(fecha_venta) AS Mes, SUM(cantidad * precio_unitario) AS Total_facturado 
    FROM VENTAS 
    GROUP BY MONTH(fecha_venta)
) AS VentasMensuales;

-- Hallazgos: 
-- 1. La facturación total del periodo registró un monto de $6.444,00.
-- 2. En términos de ingresos por producto, el ID 1 lideró el ranking de ventas, seguido por el ID 3 y 5.
-- 3. La base de clientes recurrentes está concentrada en los usuarios ID 1, 2 y 3, siendo el ID 1 quien operó con los mayores precios unitarios.