DROP PROCEDURE IF EXISTS GetMaxQuantity;

DELIMITER $$
CREATE PROCEDURE GetMaxQuantity()
BEGIN
SELECT MAX(quantity) AS 'Max Quantity in Order' 
FROM orders;
END $$
DELIMITER ;

CALL GetMaxQuantity();

PREPARE GetOrderDetail FROM 
'SELECT customer_id, order_id, quantity, total_cost 
FROM orders 
WHERE customer_id = ?';

SET @id = 1;
EXECUTE GetOrderDetail USING @id;

DROP PROCEDURE IF EXISTS CancelOrder;

DELIMITER $$
CREATE PROCEDURE CancelOrder(IN order_param INT)
BEGIN
DELETE FROM orders
WHERE order_id = order_param;
END $$
DELIMITER ;

CALL CancelOrder(10);

SELECT * FROM orders;

