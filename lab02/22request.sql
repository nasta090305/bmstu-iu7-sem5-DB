-- 22. Инструкция SELECT, использующая простое обобщенное табличное выражение

WITH CTE AS ( 
  SELECT med_id, COUNT(pharm_id) as pharm_count
  FROM availability a
  GROUP BY med_id
)

SELECT *
FROM CTE
WHERE pharm_count = 0;
