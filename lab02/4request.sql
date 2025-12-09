-- 4. Инструкция SELECT, использующая предикат IN с вложенным подзапросом. 

SELECT *
FROM medicines
WHERE med_id IN (SELECT med_id 
 FROM availability 
 WHERE qnt = 0); 