-- QUERY WAREHOUSE
SELECT
  Warehouse.id_deposito,
  CONCAT(Warehouse.estado, ': ', Warehouse.alias_deposito) AS warehouse_name,
  COUNT(Orders.id_pedido) AS number_of_orders,
  (SELECT
    COUNT(*)
  FROM `warehouse_orders.Orders`) AS total_orders,
    CASE
      WHEN COUNT(Orders.id_pedido)/(SELECT COUNT(*) FROM `warehouse_orders.Orders`) <= 0.20
      THEN "Fulfilled 0-20% of Orders"
      WHEN COUNT(Orders.id_pedido)/(SELECT COUNT(*) FROM `warehouse_orders.Orders`) > 0.20
      AND COUNT(Orders.id_pedido)/(SELECT COUNT(*) FROM `warehouse_orders.Orders`) > 0.60
      THEN "Fulfilled 21-60% of Orders"
    ELSE "Fullfilled more than 60% of Orders"
    END AS fulfillment_summary
FROM `warehouse_orders.Warehouse` AS Warehouse
LEFT JOIN `warehouse_orders.Orders` AS Orders
  ON Orders.id_deposito = Warehouse.id_deposito
GROUP BY
  Warehouse.id_deposito,
  warehouse_name
HAVING
  COUNT(Orders.id_pedido) > 0 

  