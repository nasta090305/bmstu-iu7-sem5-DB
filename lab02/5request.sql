-- 5. Инструкция SELECT, использующая предикат EXISTS с вложенным подзапросом. 

SELECT *
  FROM pharmacies
  WHERE EXISTS (
    SELECT 1
    FROM  employees  
    WHERE employees.pharm_id = pharmacies.pharm_id 
    AND employees.job_title = 'chemist'
);