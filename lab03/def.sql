/*--процедура по названию препарата определяет количество аптек в разных городах, где он в наличии и 
--будет определять ту аптеку в городе, в которой этот препарат в наибольшем количестве.

CREATE OR REPLACE PROCEDURE meds_per_city(med_name TEXT)
AS $$
DECLARE 
      cur_city TEXT;
      res RECORD;
      max_pharm INT;
      max_qnt INT;
      curs CURSOR FOR
        SELECT DISTINCT city
        FROM pharmacies;
BEGIN
      OPEN curs;
    LOOP
        FETCH curs INTO cur_city;
        EXIT WHEN NOT FOUND;

        SELECT MAX(fin_qnt) INTO max_qnt
               FROM (SELECT SUM(a.qnt) AS fin_qnt
                     FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
                     WHERE m.name = med_name AND p.city = cur_city
                     GROUP BY p.pharm_id);

        SELECT MAX(p.pharm_id) INTO max_pharm
        FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
        WHERE m.name = med_name AND p.city = cur_city
        GROUP BY p.pharm_id
        HAVING SUM(a.qnt) = max_qnt; 

        SELECT m.name, p.city, COUNT(DISTINCT p.pharm_id) as pharm_cnt, max_pharm INTO res
        FROM medicines m JOIN availability a ON m.med_id = a.med_id JOIN pharmacies p ON a.pharm_id = p.pharm_id
        WHERE m.name = med_name AND p.city = cur_city
        GROUP BY p.city, m.name;

        IF (res.pharm_cnt > 0) THEN
            RAISE NOTICE 'med_name = %, city = %, pharms in city = %, max qnt pharm = %',
                     res.name, res.city, res.pharm_cnt, res.max_pharm;
        END IF;  
    END LOOP;
    CLOSE curs;
END;
$$ LANGUAGE plpgsql;

CALL meds_per_city('name');

*//*INSERT INTO pharmacies
VALUES (1010, 'Moscow', 'Lenin', 100),
(1011, 'Moscow', 'Pervomaiskya', 59),
(1012, 'Ufa', 'Oktyabrya', 178); 

INSERT INTO med_batch
VALUES (1010, 'name', 'distr1', 500, '10.12.2025', 1010, 10),
(1011, 'name', 'distr2', 700, '10.09.2026', 1011, 15),
(1012, 'name', 'distr3', 500, '10.12.2026', 1012, 10);*/

/*SELECT m.name, p.city, COUNT(DISTINCT p.pharm_id)
FROM medicines m JOIN availability a ON m.med_id = a.med_id JOIN pharmacies p ON a.pharm_id = p.pharm_id
WHERE m.name = 'name'
GROUP BY p.city, m.name;

SELECT *
FROM medicines m
where m.med_id > 1000;*/

/*SELECT p.pharm_id
FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
WHERE m.name = 'name' AND p.city = 'Moscow'
GROUP BY p.pharm_id
HAVING SUM(a.qnt) = (SELECT MAX(fin_qnt)
                     FROM (SELECT SUM(a.qnt) AS fin_qnt
                           FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
                           WHERE m.name = med_name AND p.city = res.city
                           GROUP BY p.pharm_id));*/



/*SELECT MAX(fin_qnt)
                     FROM (SELECT SUM(a.qnt) AS fin_qnt
                           FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
                           GROUP BY p.pharm_id);*/

/*SELECT p.pharm_id
FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
WHERE m.name = 'name' AND p.city = 'Moscow'
GROUP BY p.pharm_id
HAVING SUM(a.qnt) = 138;*/

/*(SELECT MAX(fin_avg)
                     FROM (SELECT SUM(a.qnt)
                           FROM pharmacies p JOIN availability a ON p.pharm_id = a.pharm_id JOIN medicines m ON a.med_id = m.med_id
                           WHERE m.name = med_name AND p.city = res.city
                           GROUP BY p.pharm_id));*/


CREATE OR REPLACE PROCEDURE def7(job TEXT)
AS $$
BEGIN
      DROP TABLE IF EXISTS res_empl;
      CREATE TABLE IF NOT EXISTS res_empl AS ( SELECT e.empl_id, e.fio, e.job_title, p.city
        FROM employees e JOIN pharmacies p ON p.pharm_id = e.pharm_id
        WHERE e.job_title = $1 AND p.city = 'Moscow');
      DROP TABLE IF EXISTS res_meds;
      CREATE TABLE IF NOT EXISTS res_meds AS ( SELECT med_id, exp_date
        FROM medicines
        ORDER BY exp_date
        LIMIT 5);
      DROP TABLE IF EXISTS res_meds_desc;
      CREATE TABLE IF NOT EXISTS res_meds_desc AS ( SELECT med_id, exp_date
        FROM medicines
        ORDER BY exp_date DESC
        LIMIT 5);
END;
$$ LANGUAGE plpgsql;

CALL def7('cashier');

SELECT * FROM employees;

SELECT * FROM res_empl;
SELECT * FROM res_meds;
SELECT * FROM res_meds_desc;