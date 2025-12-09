-- 12. Инструкция SELECT, использующая вложенные коррелированные подзапросы в качестве производных таблиц в предложении FROM. 


SELECT a.med_id, cheap_meds.name, cheap_meds.price, a.pharm_id, a.qnt
FROM availability a JOIN ( SELECT med_id, name, price
                           FROM medicines
                           WHERE price < 1000 ) AS cheap_meds ON cheap_meds.med_id = a.med_id;

