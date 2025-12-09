--1. Извлечь XML/JSON фрагмент из XML/JSON документа

/*SELECT elem
FROM json_medicines jm, JSONB_ARRAY_ELEMENTS(jm.data) AS elem
WHERE (elem->>'price')::INT > 500;
*/

SELECT json_data->'name' AS name
FROM lab4_medicines;

--2. Извлечь значения конкретных узлов или атрибутов XML/JSON документа

/*SELECT elem->>'name' AS name, (elem->>'price')::INT AS price
FROM json_medicines jm, JSONB_ARRAY_ELEMENTS(jm.data) AS elem
WHERE (elem->>'price')::INT > 500;*/

SELECT json_data->>'name' AS name
FROM lab4_medicines;

--3. Выполнить проверку существования узла или атрибута

SELECT json_data ? 'name' AS name
FROM lab4_medicines;

--4. Изменить XML/JSON документ

SELECT json_data
FROM lab4_medicines
WHERE med_id = 1;

UPDATE lab4_medicines
SET json_data = JSONB_SET(json_data, '{price}', '1000')
where med_id = 1;

SELECT json_data
FROM lab4_medicines
WHERE med_id = 1;

--5. Разделить XML/JSON документ на несколько строк по узлам

SELECT med_id, jsonb_each_text(json_data)
FROM lab4_medicines;