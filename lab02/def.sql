--Вывести фио кассира работающего в москве, вывести полный адрес аптеки 
--и при этом в этой аптеке количество конкретного препарата (имя) не менее 3 и вывести срок годности имеющихся препаратов.

/*SELECT p.pharm_id, a.qnt, m.exp_date
FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
WHERE m.name = 'nurafen' AND p.city = 'Moscow' AND a.qnt >= 3;*/

SELECT e.fio, p.city, p.street, p.house, m.name, a.qnt, m.exp_date
FROM employees e JOIN pharmacies p ON e.pharm_id = p.pharm_id join availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
WHERE p.pharm_id IN (SELECT p.pharm_id
                     FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
                     WHERE m.name = 'nurafen' AND p.city = 'Moscow'
                     GROUP BY p.pharm_id
                     HAVING SUM(a.qnt) >= 3)
      AND e.job_title = 'cashier' AND m.name = 'nurafen';

/*SELECT p.pharm_id
FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
WHERE m.name = 'nurafen' AND p.city = 'Moscow'
GROUP BY p.pharm_id
HAVING SUM(a.qnt) >= 3;*/