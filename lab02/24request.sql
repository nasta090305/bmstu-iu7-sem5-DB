--24. Оконные функции. Использование конструкций MIN/MAX/AVG OVER() 

SELECT empl_id, job_title, salary,
 AVG(salary) OVER(PARTITION BY job_title) AS avg_salary,
 MIN(salary) OVER(PARTITION BY job_title) AS min_salary,
 MAX(salary) OVER(PARTITION BY job_title) AS max_salary
FROM employees;