--Добавить атрибут с типом JSON к уже существующей таблице. 
--Заполнить атрибут правдоподобными данными с помощью команд INSERT или UPDATE. 

ALTER TABLE lab4_medicines
  DROP COLUMN IF EXISTS json_data;

ALTER TABLE lab4_medicines
  ADD COLUMN json_data JSONB;

UPDATE lab4_medicines m1
SET json_data = (SELECT JSONB_BUILD_OBJECT('name', m.name, 'distributor', m.distributor, 
                                           'price', m.price, 'exp_date', m.exp_date) 
                        FROM lab4_medicines m
                        WHERE m.med_id = m1.med_id);


SELECT * FROM lab4_medicines;