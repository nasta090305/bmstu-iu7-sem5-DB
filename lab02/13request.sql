-- 13. Инструкция SELECT, использующая вложенные подзапросы с уровнем вложенности 3. 
-- наиболее часто показываемые фильмы

/*SELECT tittle, COUNT(DISTINCT session_id) AS cnt
FROM sessions JOIN films ON sessions.film_id = films.film_id
GROUP BY films.tittle
HAVING COUNT(DISTINCT session_id) = 
      (SELECT MAX(cnt)
       FROM (SELECT tittle, COUNT(DISTINCT session_id) AS cnt
              FROM (sessions JOIN films ON sessions.film_id = films.film_id)
              GROUP BY tittle)
      );*/

/*SELECT *
FROM availability
WHERE qnt > 0;

SELECT MAX(meds_cnt) 
FROM (SELECT pharm_id, COUNT(DISTINCT med_id) AS meds_cnt
      FROM availability
      WHERE qnt > 0
      GROUP BY pharm_id);*/

SELECT pharm_id, COUNT(DISTINCT med_id) AS meds_cnt
FROM availability
GROUP BY pharm_id
HAVING COUNT(DISTINCT med_id) = (SELECT MAX(meds_cnt) 
                                 FROM (SELECT pharm_id, COUNT(DISTINCT med_id) AS meds_cnt
                                       FROM availability
                                       WHERE qnt > 0
                                       GROUP BY pharm_id));
