-- Case Statements

-- A Case Statement allows you to add logic to your Select Statement, sort of like an if else statement in other programming languages or even things like Excel

SELECT * 
FROM employee_salary;

SELECT *,
CASE
	WHEN age <= 30 THEN 'Young' 
END Y
FROM employee_demographics;

SELECT first_name, 
last_name, age,
CASE
	WHEN age <= 30 THEN 'Young'
    WHEN age BETWEEN 31 AND 50 THEN 'Old'
    WHEN age >= 50 THEN "On Death's Door"
END category
FROM employee_demographics;

SELECT *,
CASE
WHEN age <= 35 then "Young"
WHEN age BETWEEN 36 and 50 then "Middle age"
when age > 50 then "OLD"
END Remarks
FROM employee_demographics
ORDER BY gender,age
;

SELECT *,
CASE
WHEN age <= 35 then "Young"
WHEN age BETWEEN 36 and 50 then "Middle age"
when age > 50 then "OLD"
END Remarks
FROM employee_demographics
where employee_id = 5
;
-- Poor Jerry

-- Now we don't just have to do simple labels like we did, we can also perform calculations

-- Let's look at giving bonuses to employees

SELECT * 
FROM employee_salary;

-- Pawnee Council sent out a memo of their bonus and pay increase structure so we need to follow it
-- Basically if they make less than 45k then they get a 5% raise - very generous
-- if they make more than 45k they get a 7% raise
-- they get a bonus of 10% if they work for the Finance Department

SELECT first_name, last_name, salary,
CASE
	WHEN salary > 45000 THEN salary + (salary * 0.05)
    WHEN salary < 45000 THEN salary + (salary * 0.07)
END AS new_salary
FROM employee_salary;

-- Unfortunately Pawnee Council was extremely specific in their wording and Jerry was not included in the pay increases. Maybe Next Year.

-- Now we need to also account for Bonuses, let's make a new column
SELECT first_name, last_name, salary,
CASE
	WHEN salary > 45000 THEN salary + (salary * 0.05)
    WHEN salary < 45000 THEN salary + (salary * 0.07)
END AS new_salary,
CASE
	WHEN dept_id = 6 THEN salary * .10
END AS Bonus
FROM employee_salary;



SELECT
  gender,
    COUNT(*) AS total_employees,
    SUM(CASE WHEN gender = 'Male' THEN 1 ELSE 0 END) AS male_count,
    SUM(CASE WHEN gender = 'Female' THEN 1 ELSE 0 END) AS female_count
FROM employee_demographics
GROUP BY GENDER;

-- =====================================

-- 1. Data Transformation : Convert raw values into meaningful categories.

-- Example: Categorize Age

SELECT
	first_name, age,
    
    CASE
        WHEN age < 18 THEN 'Under 18'
        WHEN age BETWEEN 18 AND 30 THEN '18-30'
        WHEN age BETWEEN 31 AND 50 THEN '31-50'
        ELSE '51+'
    END AS age_group
FROM employee_demographics;

-- 2. Business Rules --> Implement company/business logic directly in SQL.

SELECT first_name, last_name, salary,
case
when salary >40000 then salary + (salary * 0.05)
when salary <= 40000 then salary+(salary* 0.07)
end as new_salary
FROM employee_salary;

-- 3. Reporting : Create categories that make reports easier to understand.

SELECT * FROM sales_db1.orders;
select  order_date, 
round(sum(unit_price * quantity), 0) as sales, 
case
when sum(unit_price * quantity)  > 30000 then 'good'
when sum(unit_price * quantity)  < 30000 then 'average'
end as performance
from sales_db1.orders
group by order_date;

-- Month wise

SELECT
DATE_FORMAT(order_date, '%Y-%m') AS month,
ROUND(SUM(unit_price * quantity), 0) AS sales,
CASE
WHEN SUM(unit_price * quantity) >= 50000 THEN 'Excellent'
WHEN SUM(unit_price * quantity) >= 30000 THEN 'Good'
ELSE 'Average'
END AS rating
FROM sales_db1.orders
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;


-- CTE 
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



-- 4. Dashboard Datasets : CASE is very useful when preparing data that will be consumed by Power BI, Tableau, or Excel dashboards.
-- Question: Find whether each employee's salary is above or below the department average.

select * from parks_and_recreation.employee_salary;
SELECT
    employee_id, dept_id, salary, 
    Round((avg(salary) over(partition by dept_id)),2) as avg_sal_dept,
    CASE
        WHEN salary > avg(salary) over(partition by dept_id)
        THEN 'Above Average'
        ELSE 'Below Average'
    END AS salary_status
FROM parks_and_recreation.employee_salary
;
