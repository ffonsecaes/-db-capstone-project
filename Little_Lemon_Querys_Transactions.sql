INSERT INTO bookings(booking_id, date, table_number, customer_id)
VALUES
(1, '2022-10-10', 5, 1),
(2, '2022-11-12', 3, 3),
(3, '2022-10-11', 2, 2),
(4, '2022-10-13', 2, 1);

SELECT * FROM bookings;

DELIMITER $
CREATE PROCEDURE CheckBoxing(
	IN date_to_check DATE, 
	IN table_to_check INT)
	BEGIN
	DECLARE is_booked BOOLEAN DEFAULT FALSE;

	SELECT EXISTS(
		SELECT 1 
		FROM bookings
		WHERE date = date_to_check AND
		table_number = table_to_check
	) INTO is_booked;

	SELECT CASE 
		WHEN is_booked THEN CONCAT('Table ', table_to_check, ' is already booked')
		ELSE CONCAT('Table ', table_to_check, ' is available')
	END AS 'Booking Status';
END $
DELIMITER ;

CALL CheckBoxing('2022-11-12', 3);


DROP PROCEDURE IF EXISTS AddValidBooking;

DELIMITER $
CREATE PROCEDURE AddValidBooking(
	IN booking_date DATE, 
    IN booking_table INT)
    BEGIN
		DECLARE is_booked BOOLEAN DEFAULT FALSE;        
        DECLARE next_booking_id INT;
        DECLARE next_customer_id INT;
        
        START TRANSACTION;
        
        SELECT COALESCE(MAX(booking_id), 0) + 1 INTO next_booking_id FROM bookings;
        SELECT COALESCE(FLOOR(RAND() * (MAX(customer_id)) + 1), 0) INTO next_customer_id FROM customers;
        
        SELECT EXISTS(
			SELECT 1 
            FROM bookings
			WHERE date = booking_date AND
            table_number = booking_table) INTO is_booked;
		
        IF is_booked THEN 
        ROLLBACK;
        SELECT CONCAT('Table ', booking_table, ' is already booked - booking cancelled') AS 'Booking Status';
        
        ELSE 
			INSERT INTO bookings VALUES (next_booking_id, booking_date, booking_table, next_customer_id);
            COMMIT;
			SELECT CONCAT('Table ', booking_table, ' successfully booked on ', booking_date) AS 'Booking Status';
        END IF;
    END $
DELIMITER ;


CALL AddValidBooking('2022-12-17', 8);

SELECT * FROM bookings;

SELECT * FROM bookings;
SELECT * FROM customers;

DROP PROCEDURE AddBooking;
DELIMITER $
CREATE PROCEDURE AddBooking(
	IN input_booking_id INT,
    IN input_customer_id INT,
    IN input_table_number INT,
    IN input_booking_date DATE
    )
    
    proc: BEGIN
		DECLARE customer_exists BOOLEAN DEFAULT FALSE;
        DECLARE max_booking_id INT;
        DECLARE is_booked BOOLEAN DEFAULT FALSE;
        
        START TRANSACTION;
        SELECT EXISTS(
			SELECT 1 FROM bookings
            WHERE table_number = input_table_number AND date = input_booking_date		
		) INTO is_booked;
                
        IF is_booked = TRUE THEN
			ROLLBACK;
			SELECT CONCAT('Table ', input_table_number, ' is already booked on ', input_booking_date, ' please select another date or table') AS 'Confirmation';
            LEAVE proc;
		END IF;
        
        SELECT COALESCE(MAX(booking_id), 0) INTO max_booking_id FROM bookings;
    
		SELECT EXISTS(
			SELECT 1 FROM customers
            WHERE customer_id = input_customer_id
		) INTO customer_exists;
        
        IF input_booking_id <= max_booking_id THEN
			ROLLBACK;
			SELECT CONCAT('Booking_id already exists, please use a number greater than ', max_booking_id) AS 'Confirmation';
            LEAVE proc;
		END IF;
        
        IF customer_exists THEN
			INSERT INTO bookings(booking_id, customer_id, date, table_number)
            VALUES(input_booking_id, input_customer_id, input_booking_date, input_table_number);
            COMMIT;
			SELECT 'New booking added' AS 'Confirmation';
		ELSE
			ROLLBACK;
            SELECT 'No changes in database, customer does not exists' AS 'Confirmation';
		END IF;
	END $
DELIMITER ;

CALL AddBooking(29,2,5, "2022-12-31");

SELECT * FROM bookings;

DROP PROCEDURE IF EXISTS UpdateBookings;

DELIMITER $
CREATE PROCEDURE UpdateBookings(
	IN input_booking_id INT,
    IN input_booking_date DATE)
proc: BEGIN
	DECLARE is_booked BOOLEAN DEFAULT FALSE;
    
    SELECT EXISTS (
		SELECT 1 from bookings
        WHERE booking_id = input_booking_id) INTO is_booked;
    
    IF is_booked = TRUE THEN
		UPDATE bookings 
        SET date = input_booking_date
        WHERE booking_id = input_booking_id;
        SELECT CONCAT('Booking ID ', input_booking_id, ' updated to ', input_booking_date) AS 'Confirmation';
	ELSE
		SELECT 'Booking ID does not exists' AS 'Confirmation';
	END IF;

END $
DELIMITER ;

CALL UpdateBookings(1, '2022-11-30');
SELECT * FROM bookings;

DROP PROCEDURE IF EXISTS CancelBooking;

DELIMITER $
CREATE PROCEDURE CancelBooking(
	IN input_booking_id INT)	
proc: BEGIN
	DECLARE is_booked BOOLEAN DEFAULT FALSE;

START TRANSACTION;
    SELECT EXISTS(
		SELECT 1 FROM bookings
        WHERE booking_id =  input_booking_id
    ) INTO is_booked;
    
    IF is_booked THEN
		DELETE FROM bookings
        WHERE booking_id = input_booking_id;
        COMMIT;
        SELECT CONCAT('Booking id: ', input_booking_id, ' cancelled') AS 'Confirmation';
        LEAVE proc;
	ELSE
		ROLLBACK;
		SELECT CONCAT('Booking id: ', input_booking_id, ' does not exist');
        LEAVE proc;
	END IF;
END $
DELIMITER ;

CALL CancelBooking(25);



