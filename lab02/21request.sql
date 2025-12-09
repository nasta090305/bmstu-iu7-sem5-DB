-- 21. Инструкция DELETE с вложенным коррелированным подзапросом в предложении WHERE. 

DELETE FROM medicines
WHERE med_id IN (SELECT med_id 
 FROM availability 
 WHERE qnt = 0); 
