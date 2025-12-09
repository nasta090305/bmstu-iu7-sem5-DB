-- 8. Инструкция SELECT, использующая скалярные подзапросы в выражениях столбцов.


SELECT *
FROM medicines 
WHERE price > ( SELECT AVG(price)
                FROM medicines );
