#Retrieve the first name and last name of all employees. 
SELECT first_name, last_name
FROM employees;


#2Find the department numbers and names.
select dept_no,dept_name from departments;


#Get the total number of employees.
SELECT COUNT(*) AS total_employees
FROM employees;


#Find the average salary of all employees.
SELECT AVG(salary) AS average_salary
FROM salaries;


#Retrieve the birth date and hire date of employee with emp_no 10003.
SELECT
birth_date,
hire_date
FROM
employees
WHERE
emp_no = 10003;


#Find the titles of all employees. 
SELECT
emp_no,
title
FROM
employees_titles;


#Get the total number of departments
SELECT
COUNT(*) AS total_departments
FROM
departments;


#Retrieve the department number and name where employee with emp_no 10004 works.
SELECT
d.dept_no,
d.dept_name
FROM
dept_emp de
JOIN
departments d ON de.dept_no = d.dept_no
WHERE
de.emp_no = 10004;


#Find the gender of employee with emp_no 10007. 
SELECT
gender
FROM
employees
WHERE
emp_no = 10007;


#Get the highest salary among all employees. 
SELECT
MAX(salary) AS highest_salary
FROM
salaries;






