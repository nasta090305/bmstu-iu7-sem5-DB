-- Триггер INSTEAD OF 

DROP VIEW IF EXISTS med_batch;
CREATE VIEW med_batch AS (SELECT m.med_id, m.name, m.distributor, m.price, m.exp_date, a.pharm_id, a.qnt
                          FROM medicines m JOIN availability a ON m.med_id = a.med_id);

CREATE OR REPLACE FUNCTION insert_batch()
RETURNS TRIGGER AS
$$
BEGIN
      INSERT INTO medicines
      VALUES (NEW.med_id, NEW.name, NEW.distributor, NEW.price, NEW.exp_date);
      INSERT INTO availability
      VALUES (NEW.med_id, NEW.pharm_id, NEW.qnt);
      RETURN NULL;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE TRIGGER new_batch INSTEAD OF INSERT
  ON med_batch
  FOR EACH ROW
  EXECUTE FUNCTION insert_batch();

/*SELECT *
FROM medicines m
WHERE m.med_id = 16;

SELECT *
FROM availability a
WHERE a.med_id = 16;

INSERT INTO med_batch
VALUES (16, 'noshpa', 'Sara Petty', 700, '10.12.2025', 500, 20);

SELECT *
FROM medicines m
WHERE m.med_id = 16;

SELECT *
FROM availability a
WHERE a.med_id = 16;
*/

INSERT INTO pharmacies
VALUES (1010, 'Moscow', 'Lenin', 100),
(1011, 'Moscow', 'Pervomaiskya', 59),
(1012, 'Ufa', 'Oktyabrya', 178); 

INSERT INTO med_batch
VALUES (1010, 'name', 'distr1', 500, '10.12.2025', 1010, 10),
(1011, 'name', 'distr2', 700, '10.09.2026', 1011, 15),
(1012, 'name', 'distr3', 500, '10.12.2026', 1012, 10);