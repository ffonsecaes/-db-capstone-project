DROP VIEW IF EXISTS ordersview;

CREATE VIEW OrdersView AS
SELECT order_id AS 'OrderID', 
quantity AS 'Quantity', 
total_cost AS 'TotalCost'
FROM Orders
WHERE quantity > 2;

SELECT * FROM ordersview;

SELECT customers.customer_id, customers.name,
orders.order_id, orders.total_cost,
menus.menu_name,
menu_items.course_name
FROM customers
INNER JOIN orders
ON customers.customer_id = orders.customer_id
INNER JOIN menus
ON orders.menu_id = menus.menu_id
INNER JOIN menu_items
ON menus.menu_items_id = menu_items.menu_item_id
ORDER BY orders.total_cost ASC;


SELECT menu_items.course_name AS 'MenuName'
FROM menu_items
INNER JOIN menus
ON menu_items.menu_item_id = menus.menu_items_id
WHERE menus.menu_items_id = ANY (
SELECT menu_id 
FROM orders
GROUP BY menu_id
HAVING COUNT(menu_id) > 2);

