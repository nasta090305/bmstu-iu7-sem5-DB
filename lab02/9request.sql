-- 9. Инструкция SELECT, использующая простое выражение CASE. 


SELECT name, 
 CASE DATE_PART('year', exp_date)
 WHEN DATE_PART('year', CURRENT_DATE) THEN 'This Year'
 WHEN DATE_PART('year', CURRENT_DATE) + 1 THEN 'Next year'
 ELSE 'in ' || CAST(DATE_PART('year', exp_date) - DATE_PART('year', CURRENT_DATE) AS varchar(5)) || ' years' 
 END AS exp_dist
FROM medicines;
