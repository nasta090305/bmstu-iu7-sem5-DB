-- 16. ќднострочна€ инструкци€ INSERT, выполн€юща€ вставку в таблицу однои? строки значении?. 

/*INSERT INTO medicines 
VALUES (1002, 'nurafen', 'Sara Petty', 500, '20-12-2025');*/

INSERT INTO availability
VALUES (1001, 1, 1);

INSERT INTO availability
VALUES (1002, 1, 2);

SELECT *
FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id join medicines m ON a.med_id = m.med_id
WHERE m.name = 'nurafen';