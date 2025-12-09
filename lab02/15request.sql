-- 15. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY и предложения HAVING. 

SELECT distributor, AVG(price)
FROM medicines
GROUP BY distributor
HAVING AVG(price) > ( SELECT AVG(price) 
                      FROM medicines );