SELECT * FROM parks_and_recreation.employee_salary ;

ALTER TABLE parks_and_recreation.employee_salary
ADD Manager_ID VARCHAR(255) ;

-- Error Code: 1175

SET SQL_SAFE_UPDATES = 0;
update parks_and_recreation.employee_salary 
SET Manager_ID = NULL
where employee_salary.employee_id =11;

update parks_and_recreation.employee_salary 
SET Manager_ID = 7
where employee_salary.employee_id in (6,9,10);

update parks_and_recreation.employee_salary 
SET Manager_ID = 11
where employee_salary.employee_id IN(1,3,5,7,12);

-- Self Join

select 
*
from employee_salary employee
JOIN
employee_salary Manager
ON Manager.employee_id = employee.manager_ID
;

----------

select 
e.employee_id, e.first_name Emp, M.first_name Manager
from employee_salary e
JOIN
employee_salary M
ON 
e.manager_ID = M.employee_id
Order by employee_id
;
