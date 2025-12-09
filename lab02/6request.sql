-- 6. Инструкция SELECT, использующая предикат сравнения с квантором. 

SELECT *
FROM employees
WHERE salary >= ALL (SELECT salary
 FROM employees  
 WHERE job_title = 'cleaner');