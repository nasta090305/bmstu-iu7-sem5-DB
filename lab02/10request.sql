-- 10. Инструкция SELECT, использующая поисковое выражение CASE.

SELECT name, 
 CASE 
 WHEN price < 100 THEN 'Super cheap' 
 WHEN price < 500 THEN 'Cheap'
 WHEN price < 1000 THEN 'Normal' 
 WHEN price < 2000 THEN 'Expensive' 
 ELSE 'Super expensive'
 END AS cost
FROM medicines;
