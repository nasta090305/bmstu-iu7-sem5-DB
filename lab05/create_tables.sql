-- Выполнить загрузку и сохранение JSON файла в таблицу.

DROP TABLE IF EXISTS json_medicines;
CREATE TABLE json_medicines(
  data jsonb
);

DROP TABLE IF EXISTS lab4_medicines;
CREATE TABLE lab4_medicines(
    Med_ID SERIAL,
    Name TEXT,
    Distributor TEXT,
    Price INT,
    Exp_date DATE
);

COPY json_medicines(data) FROM 'D:\5sem\bd\lab5\json_data\medicines.json';

INSERT INTO lab4_medicines
  SELECT 
      (elem->>'med_id')::INT,
      elem->>'name',
      elem->>'distributor',
      (elem->>'price')::INT,
      (elem->>'exp_date')::DATE
  FROM json_medicines, JSONB_ARRAY_ELEMENTS(data) AS elem;

SELECT * FROM lab4_medicines; 
