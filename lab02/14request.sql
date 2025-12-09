-- 14. Инструкция SELECT, консолидирующая данные с помощью предложения GROUP BY, но без предложения HAVING. 

SELECT a.pharm_id, MIN(m.price) AS min_price
FROM medicines m JOIN availability a ON m.med_id = a.med_id
GROUP BY a.pharm_id;