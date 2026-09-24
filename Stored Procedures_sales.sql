-- 1. Basic store procedure
SELECT * FROM sales_db1.customers;
SELECT * FROM sales_db1.orders;

DELIMITER $$
CREATE PROCEDURE GetHydCustomer()
BEGIN
select * from customers
where city = 'Hyderabad';
END $$
DELIMITER ;

call GetHydCustomer();

-- 2. Stored Procedure with IN Parameter : You can pass a value to the procedure.

DELIMITER $$
CREATE PROCEDURE GetCity(IN P_City varchar(50))
BEGIN
SELECT * FROM sales_db1.customers 
where P_City = city
;
END $$
DELIMITER ;

call GetCity('Hyderabad');
call GetCity('Bangalore');
call GetCity('Pune');
call GetCity('Chennai');




-- 3. Multiple Parameters (Order table, )

USE `sales_db1`;
DROP procedure IF EXISTS `Electronics`;

DELIMITER $$
USE `sales_db1`$$
CREATE PROCEDURE `Electronics` (in parameter_custID INT, in o_status varchar(25))
BEGIN
SELECT * FROM sales_db1.orders
where category = 'Electronics'
and parameter_custID = customer_id
and o_status = order_status
;
END$$

DELIMITER ;

call Electronics(101, 'Delivered');
call Electronics(102, 'Delivered');
call category('Electronics', '2024-01-20');
-- ----------------------------------------------------------------------

USE `sales_db1`;
DROP procedure IF EXISTS `category`;

USE `sales_db1`;
DROP procedure IF EXISTS `sales_db1`.`category`;
;

DELIMITER $$
USE `sales_db1`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `category`(parameter_category varchar(50), o_month varchar(2))
BEGIN
SELECT *, DATE_FORMAT(order_date, '%m') AS month
 FROM sales_db1.orders
where order_status = 'Delivered'
and category = parameter_category
and DATE_FORMAT(order_date, '%m') = o_month;
END$$

DELIMITER ;
;

call sales_db1.category('electronics', '08'); -- category - Electronics, Order date - August


-- ==================================== ------------------------------------
DELIMITER $$

CREATE PROCEDURE category2(
IN parameter_category VARCHAR(50),
IN o_month INT
)
BEGIN
SELECT *
FROM orders
WHERE category = parameter_category
AND MONTH(order_date) = o_month;
END$$
 
DELIMITER ;


call category2('electronics',3); -- no orders
call category2('electronics',1); -- 1 orders
call category2('electronics',8); -- 2 orders
call category2('furniture',8); -- no data
call category2('furniture',3); -- 2 orders
-- =======================================

-- CTE and windows functions

WITH monthly_sales AS (
SELECT
DATE_FORMAT(order_date, '%Y-%m') AS month,
SUM(unit_price * quantity) AS sales
FROM sales_db1.orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
)
SELECT
month,
ROUND(sales, 0) AS sales,
DENSE_RANK() OVER (ORDER BY sales DESC) AS rating
FROM monthly_sales;



-- =============================================================================
-- 4. IF...ELSE Inside Stored Procedure : This is very useful for business rules.


SELECT * FROM parks_and_recreation.employee_salary;

DELIMITER //

CREATE PROCEDURE Che(
    IN p_salary DECIMAL(10,2)
)
BEGIN

    IF p_salary >= 100000 THEN
        SELECT 'High Salary' AS salary_category;

    ELSEIF p_salary >= 50000 THEN
        SELECT 'Medium Salary' AS salary_category;

    ELSE
        SELECT 'Low Salary' AS salary_category;

    END IF;

END //

DELIMITER ;

DELIMITER $$
create procedure checksalary(IN p_sal decimal(10,2))
BEGIN 
IF p_sal >= 100000 THEN
select 'High salary' AS salary_category;
ELSEIF p_sal >= 50000 THEN
select 'Medium salary' AS salary_category;
ELSE
select 'Low salary' AS salary_category;
END IF;
END $$
DELIMITER ;

call checksalary(75004);
