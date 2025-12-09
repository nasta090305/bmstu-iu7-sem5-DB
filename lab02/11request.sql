-- 11. Создание новои? временнои? локальнои? таблицы из результирующего набора данных инструкции SELECT. 

DROP TABLE IF EXISTS MedsAvailable;
CREATE TEMP TABLE IF NOT EXISTS MedsAvailable as
SELECT m.name, m.price, a.pharm_id, qnt
FROM medicines m JOIN availability a ON m.med_id = a.med_id;

SELECT name, qnt
FROM MedsAvailable
WHERE qnt > 0;