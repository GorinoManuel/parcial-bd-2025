--Punto 1
SELECT  
    YEAR(f.fact_fecha),
    p.prod_codigo,
    (SELECT COUNT(DISTINCT f3.fact_numero + f3.fact_sucursal + f3.fact_tipo) FROM Item_Factura it3 JOIN Factura f3 ON f3.fact_numero + f3.fact_sucursal + f3.fact_tipo
            = it3.item_numero + it3.item_sucursal + it3.item_tipo
        WHERE it3.item_producto = p.prod_codigo AND it3.item_cantidad = 1  AND YEAR(f3.fact_fecha) = YEAR(f.fact_fecha)
    ),
    (SELECT TOP 1 f3.fact_numero FROM Item_Factura it3 JOIN Factura f3 ON f3.fact_numero + f3.fact_sucursal + f3.fact_tipo
            = it3.item_numero + it3.item_sucursal + it3.item_tipo
        WHERE it3.item_producto = p.prod_codigo AND YEAR(f3.fact_fecha) = YEAR(f.fact_fecha)
        ORDER BY f3.fact_fecha asc
    ),
    (SELECT TOP 1 f3.fact_cliente FROM Item_Factura it3 JOIN Factura f3 ON f3.fact_numero + f3.fact_sucursal + f3.fact_tipo
            = it3.item_numero + it3.item_sucursal + it3.item_tipo
        WHERE it3.item_producto = p.prod_codigo AND YEAR(f3.fact_fecha) = YEAR(f.fact_fecha)
        GROUP BY f3.fact_cliente
        ORDER BY SUM(it3.item_cantidad) asc
    ),
    ROUND ( (SUM(it.item_cantidad) * 100)/ (SELECT sum(IT3.item_cantidad) FROM Item_Factura it3 JOIN Factura f3 ON f3.fact_numero + f3.fact_sucursal + f3.fact_tipo
            = it3.item_numero + it3.item_sucursal + it3.item_tipo
        WHERE YEAR(f3.fact_fecha) = YEAR(f.fact_fecha)
    ), 2)

FROM Producto p JOIN Item_Factura it on IT.item_producto = P.prod_codigo
JOIN Factura f on f.fact_numero + f.fact_sucursal + f.fact_tipo
= it.item_numero + it.item_sucursal + it.item_tipo
WHERE p.prod_codigo = (SELECT TOP 1 it2.item_producto FROM Item_Factura it2 JOIN Factura f2 
                    ON f2.fact_numero + f2.fact_sucursal + f2.fact_tipo
                    = it2.item_numero + it2.item_sucursal + it2.item_tipo
                    WHERE YEAR(f2.fact_fecha) = YEAR(f.fact_fecha) 
                    AND NOT EXISTS (SELECT 1 FROM Composicion comp WHERE comp.comp_producto = it2.item_producto)
                    GROUP BY it2.item_producto
                    ORDER BY SUM(it2.item_cantidad) desc   ) 
GROUP BY p.prod_codigo, YEAR(f.fact_fecha)
GO



-- Punto 2
CREATE TABLE productos_juntos(
    prod_detalle1 CHAR(50),
    prod_detalle2 CHAR(50),
    cantidad INT
)
GO

CREATE PROCEDURE llenar_tabla(@cantidad_filas INT OUTPUT)
AS
    BEGIN
        -- Por si esta ya llena la tabla, la borro
        DELETE FROM productos_juntos

        --Inserción masiva
        INSERT INTO productos_juntos(prod_detalle1, prod_detalle2, cantidad)
        SELECT FROM
    END
GO