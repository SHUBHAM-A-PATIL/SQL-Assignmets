#1. select all employees in department 10 whose salary is greater than 3000. [table: employee]
use assignment;
select * from employee;
SELECT * FROM employee WHERE deptno=10 and salary > 3000;
#2. The grading of students based on the marks they have obtained is done as follows:
#40 to 50 -> Second Class
#50 to 60 -> First Class
#60 to 80 -> First Class
#80 to 100 -> Distinctions
Select *, case
when marks>80 then 'Distinction' 
when marks between 50 and 80  then 'Frist class' 
when marks between 40 and 50 then 'Second Class' 
when marks<40 then 'Fail' 
else 'No Grade Available' end as Grade from students ; 
select * from students;
#a. How many students have graduated with first class?
#b. How many students have obtained distinction? [table: students]
SELECT SUM(CASE WHEN marks > 50 AND marks <= 80 THEN 1 END) AS first_class_count,
SUM(CASE WHEN marks > 80 THEN 1 END) AS distinction_count FROM students;
#3. Get a list of city names from station with even ID numbers only. Exclude duplicates from your answer.[table: station]
select * from station;
SELECT DISTINCT CITY FROM STATION WHERE MOD(ID, 2) = 0;
#4. Find the difference between the total number of city entries in the table and the number of distinct city entries in the table. In other words, if N is the number of city entries in station, and N1 is the number of distinct city names in station, write a query to find the value of N-N1 from station.
#[table: station]
select (count(CITY)-  count(distinct CITY)) from station as ans;
#5. Answer the following
#a. Query the list of CITY names starting with vowels (i.e., a, e, i, o, or u) from STATION. Your result cannot contain duplicates. [Hint: Use RIGHT() / LEFT() methods ]
SELECT distinct City FROM STATION WHERE RIGHT(CITY,1) IN  ('a', 'e', 'i', 'o', 'u') ;
SELECT distinct CITY FROM STATION WHERE RIGHT(LEFT(CITY,3),1) IN ('a', 'e', 'i', 'o', 'u');
#b. Query the list of CITY names from STATION which have vowels (i.e., a, e, i, o, and u) as both their first and last characters. Your result cannot contain duplicates.
SELECT DISTINCT city FROM station WHERE city REGEXP "^[aeiou].*[aeiou]$";
#c. Query the list of CITY names from STATION that do not start with vowels. Your result cannot contain duplicates.
SELECT DISTINCT city FROM station WHERE city NOT RLIKE "^[AEIOUaeiou].*$";
#d. Query the list of CITY names from STATION that either do not start with vowels or do not end with vowels.
#  Your result cannot contain duplicates. [table: station]
SELECT DISTINCT city FROM station WHERE city NOT RLIKE '^[aeiouAEIOU].*[aeiouAEIOU]$';
#6. Write a query that prints a list of employee names having a salary greater than $2000 per month who have been employed
# for less than 36 months. Sort your result by descending order of salary. [table: emp]
SELECT * FROM emp WHERE salary > 2000 AND  Hire_Date >= DATE_SUB(CURRENT_DATE, INTERVAL 36 MONTH) ORDER BY salary desc;
#7. How much money does the company spend every month on salaries for each department? [table: employee]
SELECT deptno, SUM(SALARY) FROM employee GROUP BY deptno;
#8. How many cities in the CITY table have a Population larger than 100000. [table: city]
select count(district) from city having sum(population) > 100000;
#9. What is the total population of California? [table: city]
SELECT SUM(population) FROM city WHERE district = "California";
#10. What is the average population of the districts in each country? [table: city]
select countrycode, avg(population) as avg_population from city where countrycode in('JPN', 'USA', 'NLD') group by countrycode;
#11. Find the ordernumber, status, customernumber, customername and comments for all orders that are
# ‘Disputed=  [table: orders, customers]
SELECT a.orderNumber,a.status,a.comments,
b.customerName AS "Customer Name", b.customerNumber 
FROM orders a 
INNER JOIN customers b 
ON a.customerNumber=b.customerNumber
WHERE a.status='Disputed';

