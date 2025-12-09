DROP TABLE IF EXISTS satellite CASCADE;
DROP TABLE IF EXISTS flight CASCADE;

CREATE TABLE IF NOT EXISTS satellite
(
  id INT PRIMARY KEY,
  name TEXT,
  production_date DATE,
  country TEXT
);

CREATE TABLE IF NOT EXISTS flight
(
  satellite_id INT,
  launch_date DATE,
  launch_time TIME,
  week_day TEXT,
  type INT,
  FOREIGN KEY(satellite_id) REFERENCES satellite(id) ON DELETE CASCADE
);

INSERT INTO satellite VALUES
(1, 'SIT-2086', '2050-01-01', 'Россия'),
(2, 'Шицзян 16-02', '2049-12-01', 'Китай');


INSERT INTO flight VALUES
(1, '2050-05-11', '9:00', 'Среда', 1),
(1, '2051-06-14', '23:05', 'Среда', 0),
(1, '2051-10-10', '23:50', 'Вторник', 1),
(2, '2050-05-11', '15:15', 'Среда', 1),
(1, '2052-01-01', '12:15', 'Понедельник', 0);

/*SELECT * FROM satellite;
SELECT * FROM flight;*/

EXPLAIN
SELECT f.satellite_id
FROM flight AS f
GROUP BY f.satellite_id
ORDER BY COUNT(*) DESC
LIMIT(1);

EXPLAIN
SELECT *
FROM satellite AS s1 JOIN satellite s2 ON s1.country = s2.country
WHERE s1.id < s2.id;

SELECT id
FROM satellite
WHERE (CURRENT_DATE - production_date) < (50 * 365);

SELECT DISTINCT country
FROM satellite
WHERE (CURRENT_DATE - production_date) < (50 * 365);


--запрос1
SELECT DISTINCT country
FROM satellite
WHERE country NOT IN (SELECT DISTINCT country
                      FROM satellite
                      WHERE (CURRENT_DATE - production_date) < (50 * 365));

/*SELECT DISTINCT country
FROM satellite
WHERE id NOT IN (*/


--найти спутник который в этом году отправлен раньше всех
SELECT satellite_id 
FROM flight 
WHERE 
      DATE_PART('year', launch_date) = DATE_PART('year', now()) AND
      type = 1 AND
      launch_date = (SELECT MIN(launch_date)
                     FROM flight
                     WHERE  DATE_PART('year', launch_date) = DATE_PART('year', now()) AND
                            type = 1)
                     AND
      launch_time = (SELECT MIN(launch_time)
                     FROM flight
                     WHERE  DATE_PART('year', launch_date) = DATE_PART('year', now()) AND
                            type = 1 AND
                            launch_date = (SELECT MIN(launch_date)
                                          FROM flight));

--запрос2
SELECT *
FROM flight 
WHERE
      DATE_PART('year', launch_date) = DATE_PART('year', now()) AND
      type = 1
ORDER BY launch_date, launch_time
LIMIT(1);

--запрос3
SELECT DISTINCT s.id
FROM satellite s JOIN flight f ON s.id = f.satellite_id
WHERE s.country = 'Россия' AND f.type = 1 AND f.launch_date >= '2024-09-01' AND f.launch_date < '2025-01-01';