#1. Write a stored procedure that accepts the month and year as inputs and prints the ordernumber,
# orderdate and status of the orders placed in that month. 
#Example:  call order_status(2005, 11);
use assignment;
select * from orders;
drop procedure Order_status;
Delimiter //
CREATE PROCEDURE order_status (IN y_year int, IN m_month int)
Begin
SELECT orderNumber,OrderDate,status FROM orders WHERE year(orderDate)=y_year and month(orderDate)=m_month;
End //
Delimiter ;
call order_status(2003,01);
#2. Write a stored procedure to insert a record into the cancellations table for all cancelled orders.
#STEPS: 
#a.	Create a table called cancellations with the following fields id (primary key), customernumber (foreign key - Table customers), ordernumber (foreign key - Table Orders), 
#comments All values except id should be taken from the order table.
#b. Read through the orders table . If an order is cancelled, then put an entry in the cancellations table.
create table cancellations (id int auto_increment primary key,cust_no INTEGER, orderno Int,comments varchar(225),
  FOREIGN KEY(cust_no) REFERENCES customers(customerNumber), FOREIGN KEY(orderno) REFERENCES orders(orderNumber));
drop table cancellations;
Delimiter //
CREATE PROCEDURE cancelledorders ()
Begin
alter table cancellations auto_increment=1; 
insert into cancellations (cust_no,orderno,comments) select customerNumber,orderNumber,comments from orders where status='Cancelled'; 
End //
Delimiter ;
call cancelledorders();
drop procedure cancelledorders;
select * from cancellations;
#3. a. Write function that takes the customernumber as input and returns the purchase_status based on the following criteria . [table:Payments]
#if the total purchase amount for the customer is < 25000 status = Silver, amount between 25000 and 50000, status = Gold
#if amount > 50000 Platinum
DELIMITER $$
CREATE FUNCTION purchase_status(cid int) 
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE purchase_status VARCHAR(20);
    DECLARE amt numeric;
    SET amt = (select sum(amount) from payments where customerNumber = cid);
    IF amt > 50000 THEN
		SET purchase_status = 'PLATINUM';
    ELSEIF (amt >= 25000 AND 
			amt <= 50000) THEN
        SET purchase_status = 'GOLD';
    ELSEIF amt < 25000 THEN
        SET purchase_status = 'SILVER';
    END IF;
	-- return the customer level
	RETURN (purchase_status);
END$$
DELIMITER ;
#b. Write a query that displays customerNumber, customername and purchase_status from customers table.
select 121 customerNumber, purchase_status(121) as purchase_status;
select 103 customerNumber, purchase_status(103) as purchase_status;
#4. Replicate the functionality of 'on delete cascade' and 'on update cascade' using triggers on movies and rentals tables.
 #Note: Both tables - movies and rentals - don't have primary or foreign keys. Use only triggers to implement the above.
insert into movies values(11,'abc','cd');
insert into rentals values(9,'abc','cd',11);
update rentals set movieid=11 where memid=9;
#DELETE TRIGGER
DELIMITER $$
USE `assignment`$$
CREATE DEFINER = CURRENT_USER TRIGGER `assignment`.`movies_AFTER_DELETE` AFTER DELETE ON `movies` FOR EACH ROW
BEGIN
 UPDATE rentals SET movieid = id WHERE movieid = OLD.id ;
END$$
DELIMITER ;
DROP TRIGGER `assignment`.`movies_AFTER_DELETE`;
DELETE from movies where title='abc';
#UPDATE TRIGGER
DELIMITER $$
USE `assignment`$$
CREATE DEFINER = CURRENT_USER TRIGGER `assignment`.`movies_AFTER_UPDATE` AFTER UPDATE ON `movies` FOR EACH ROW
BEGIN
DELETE FROM  rentals WHERE movieid NOT IN (SELECT DISTINCT id FROM movies);
END$$
DELIMITER ;
#5. Select the first name of the employee who gets the third highest salary. [table: employee]
SELECT fname,salary FROM `employee` ORDER BY `salary` DESC LIMIT 1 OFFSET 2;
#6. Assign a rank to each employee  based on their salary. The person having the highest salary has rank 1. [table: employee]
SELECT fname, lname, salary, RANK() OVER (ORDER BY salary desc) salary_rank FROM employee;