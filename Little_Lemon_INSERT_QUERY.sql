SHOW DATABASES;

USE littlelemondb;

SHOW CREATE TABLE menu_items;

#SET SQL_SAFE_UPDATES = 0;

DELETE FROM menu_items;

#SET SQL_SAFE_UPDATES = 1;

INSERT INTO menu_items 
VALUES
(1, 'Pollo a la Brasa', 'Salad', 'Gelato'),
(2, 'Lomo Saltado', 'Tequeños', 'Apple'),
(3, 'Arroz con pollo', 'Alitas', 'Pionono'),
(4, 'Arroz Arabe', 'Sopa', 'Platano'),
(5, 'Pure de Papa', 'Tamal', 'Mandarina');

SHOW COLUMNS FROM bookings;

INSERT INTO bookings
VALUES
(1, '2025/12/16', 5),
(2, '2025/12/18', 1),
(3, '2025/12/01', 3);

SHOW COLUMNS FROM customers;

INSERT INTO customers
VALUES
(1, 'Franco', 914728217, 'ffonsecaes@gmail.com'),
(2, 'Estefania', 992019575, 'stfaniaquiroz@gmail.com'),
(3, 'Fiorella', 997467859, 'fiorella@gmail.com');

SHOW CREATE TABLE menus;

INSERT INTO menus
VALUES
(1, 5, 'Huancaina', 'Peruana'),
(2, 4, 'Cajamarquina', 'Ecuatoriana'),
(3, 3, 'Marleni', 'Boliviana'),
(4, 2, 'Charapa', 'Venezolana'),
(5, 1, 'Tarapotina', 'Limeña');

SHOW COLUMNS FROM order_delivery_status;

INSERT INTO order_delivery_status
VALUES
(1, 'In Progress', '2025-12-30', 'Av. Andrés Tinoco 369'),
(2, 'Delivered', '2025-12-30', 'Jr Reinaldo Morón 237'),
(3, 'In Transit', '2025-12-30', 'Jr Augusto Wiese 1284');

SHOW COLUMNS FROM staff;

INSERT INTO staff
VALUES
(1, 'Bryan', 'Manager', 1500.00),
(2, 'Jean Franco', 'Sub-Manager', 1000.00),
(3, 'Jazmin', 'Dish-Washer', 600.00);

SET SQL_SAFE_UPDATES = 0;
DROP TABLE orders;

CREATE TABLE IF NOT EXISTS `littlelemondb`.`orders` (
  `order_id` INT NOT NULL,
  `date` DATE NOT NULL,
  `quantity` INT NOT NULL,
  `total_cost` DECIMAL(10,2) NOT NULL,
  `order_delivery_status_id` INT NOT NULL,
  `booking_id` INT NOT NULL,
  `staff_id` INT NOT NULL,
  `customer_id` INT NOT NULL,
  `menu_id` INT NOT NULL,
  PRIMARY KEY (`order_id`),
  INDEX `order_delivery_status_idx` (`order_delivery_status_id` ASC) VISIBLE,
  INDEX `booking_idx` (`booking_id` ASC) VISIBLE,
  INDEX `staff_id_idx` (`staff_id` ASC) VISIBLE,
  INDEX `customer_id_idx` (`customer_id` ASC) VISIBLE,
  INDEX `menu_id_idx` (`menu_id` ASC) VISIBLE,
  CONSTRAINT `booking`
    FOREIGN KEY (`booking_id`)
    REFERENCES `littlelemondb`.`bookings` (`booking_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `customer_id`
    FOREIGN KEY (`customer_id`)
    REFERENCES `littlelemondb`.`customers` (`customer_id`),
  CONSTRAINT `order_delivery_status`
    FOREIGN KEY (`order_delivery_status_id`)
    REFERENCES `littlelemondb`.`order_delivery_status` (`delivery_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `staff_id`
    FOREIGN KEY (`staff_id`)
    REFERENCES `littlelemondb`.`staff` (`staff_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `menu_id`
    FOREIGN KEY (`menu_id`)
    REFERENCES `littlelemondb`.`Menus` (`menu_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4;

INSERT INTO orders
VALUES
(1, '2025-12-29', 1, 150.00, 1, 1, 3, 2, 2),
(2, '2025-12-28', 2, 300.00, 2, 1, 3, 2, 1),
(3, '2025-12-30', 5, 1500.00, 2, 2, 2, 3, 4),
(4, '2025-12-31', 7, 2000.00, 3, 3, 1, 1, 5),
(5, '2025-12-27', 3, 500.00, 1, 3, 2, 3, 5),
(6, '2025-12-29', 1, 150.00, 1, 1, 3, 2, 5),
(7, '2025-12-28', 2, 300.00, 2, 1, 3, 2, 4),
(8, '2025-12-30', 5, 1500.00, 2, 2, 2, 3, 4),
(9, '2025-12-31', 7, 2000.00, 3, 3, 1, 1, 5),
(10, '2025-12-27', 3, 500.00, 1, 3, 2, 3, 4),
(11, '2025-12-29', 1, 150.00, 1, 1, 3, 2, 5),
(12, '2025-12-28', 2, 300.00, 2, 1, 3, 2, 5),
(13, '2025-12-30', 5, 1500.00, 2, 2, 2, 3, 3),
(14, '2025-12-31', 7, 2000.00, 3, 3, 1, 1, 1),
(15, '2025-12-27', 3, 500.00, 1, 3, 2, 3, 4);

SELECT * FROM orders;


SET SQL_SAFE_UPDATES = 0;
#DELETE FROM bookings WHERE 1=1;
DELETE FROM bookings;
SELECT * FROM bookings;

ALTER TABLE bookings 
ADD COLUMN customer_id INT;

ALTER TABLE bookings
ADD FOREIGN KEY (customer_id) 
REFERENCES customers(customer_id);

SHOW COLUMNS FROM bookings;

INSERT INTO bookings(booking_id, date, table_number, customer_id)
VALUES
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);

SELECT * FROM bookings;

