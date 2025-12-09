-- 17. Многострочная инструкция INSERT, выполняющая вставку в таблицу результирующего набора данных вложенного подзапроса. 

INSERT INTO employees
SELECT (SELECT MAX(empl_id)
        FROM employees) + 1,
15, 'Ivan Ivanov', 'cashier', 80000;

SELECT * FROM employees WHERE empl_id > 1000;