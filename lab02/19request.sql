-- 19. Инструкция UPDATE со скалярным подзапросом в предложении SET. 

SELECT *
FROM employees 
WHERE fio = 'James James';

UPDATE employees
SET salary = ( SELECT MAX(salary)
               FROM employees )
WHERE fio = 'James James';

SELECT *
FROM employees 
WHERE fio = 'James James';