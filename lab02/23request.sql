--23. Инструкция SELECT, использующая рекурсивное обобщенное табличное выражение.

DROP TABLE IF EXISTS Nodes;

-- Создание таблицы. 
CREATE TABLE Nodes ( 
 id int,
 name text,
 next_id int,
 CONSTRAINT PK_ID PRIMARY KEY(id)
); 

-- Заполнение таблицы значениями. 
INSERT INTO Nodes(id, name, next_id) VALUES
(1, 'Node1', 2),
(2, 'Node2', 4),
(3, 'Node3', 4),
(4, 'Node4', 5),
(5, 'Node5', NULL);

-- Определение ОТВ
WITH RECURSIVE RCTE AS
(
 -- Определение якоря рекурсии
 SELECT id, name, next_id, 0 AS Level 
 FROM nodes
 WHERE id = 1

 UNION ALL 
 -- Определение шага рекурсии
 SELECT nodes.id, nodes.name, nodes.next_id, level + 1 
 FROM nodes JOIN RCTE AS r 
 ON r.next_id = nodes.id
)
 
-- Инструкция, использующая ОТВ
SELECT * 
FROM RCTE;

