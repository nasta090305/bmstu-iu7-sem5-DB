-- Из таблиц базы данных, созданной в первой лабораторной работе, извлечь данные в JSON.

COPY (SELECT JSON_AGG(ROW_TO_JSON(p)) FROM pharmacies p) TO 'D:\5sem\bd\lab5\json_data\pharmacies.json';
COPY (SELECT JSON_AGG(ROW_TO_JSON(m)) FROM medicines m) TO 'D:\5sem\bd\lab5\json_data\medicines.json';
COPY (SELECT JSON_AGG(ROW_TO_JSON(a)) FROM availability a) TO 'D:\5sem\bd\lab5\json_data\availability.json';
COPY (SELECT JSON_AGG(ROW_TO_JSON(e)) FROM employees e) TO 'D:\5sem\bd\lab5\json_data\employees.json';
