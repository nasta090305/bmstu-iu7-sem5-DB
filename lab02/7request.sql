-- 7. Инструкция SELECT, использующая агрегатные функции в выражениях столбцов. 

SELECT job_title, AVG(salary)
FROM employees
GROUP BY job_title;