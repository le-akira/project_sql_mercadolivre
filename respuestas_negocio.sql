--Listar los usuarios que cumplan años el día de hoy cuya cantidad de ventas realizadas en enero 2020 sea superior a 1500. 

SELECT c.name, c.surname
FROM Customer c
WHERE DATE_ADD(c.date_of_birth, INTERVAL 16 YEAR) = CURDATE()
  AND EXISTS (
      SELECT 1
      FROM Order o
      WHERE o.customer_id = c.customer_id
        AND o.order_date BETWEEN '2020-01-01' AND '2020-01-31'
        AND o.quantity > 1500
  );


--Por cada mes del 2020, se solicita el top 5 de usuarios que más vendieron($) en la categoría Celulares. Se requiere el mes y año de análisis, nombre y apellido del vendedor, cantidad de ventas realizadas, cantidad de productos vendidos y el monto total transaccionado. 

SELECT
    MONTH(o.order_date) AS month,
    YEAR(o.order_date) AS year,
    c.name,
    c.surname,
    COUNT(o.order_id) AS total_orders,
    SUM(o.quantity) AS total_items_sold,
    SUM(o.total_amount) AS total_amount_transferred
FROM Order o
JOIN Customer c ON o.customer_id = c.customer_id
JOIN Item i ON o.item_id = i.item_id
JOIN Category cat ON i.category_id = cat.category_id
WHERE cat.description = 'Celular'
  AND o.order_date BETWEEN '2020-01-01' AND '2020-12-31'
GROUP BY year, month

--Se solicita poblar una nueva tabla con el precio y estado de los Ítems a fin del día. Tener en cuenta que debe ser reprocesable. Vale resaltar que en la tabla Item, vamos a tener únicamente el último estado informado por la PK definida. (Se puede resolver a través de StoredProcedure)

CREATE PROCEDURE atualizar_status_itens()
BEGIN
    DECLARE last_update_date DATE;
    DECLARE current_date DATE;

    SET last_update_date = (SELECT MAX(data_atualizacao) FROM ItemStatus);
    SET current_date = CURRENT_DATE;

    IF last_update_date IS NULL OR last_update_date < current_date THEN
        INSERT INTO ItemStatus (item_id, status, data_atualizacao)
        SELECT i.id, i.status, current_date
        FROM Item i;
    END IF;
END PROCEDURE;