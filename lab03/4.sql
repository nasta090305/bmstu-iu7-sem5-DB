-- Рекурсивную функцию или функцию с рекурсивным ОТВ

DROP TABLE IF EXISTS Nodes;

CREATE TABLE Nodes ( 
 id int,
 name text,
 next_id int,
 CONSTRAINT PK_ID PRIMARY KEY(id)
); 

INSERT INTO Nodes(id, name, next_id) VALUES
(1, 'Node1', 2),
(2, 'Node2', 4),
(3, 'Node3', 4),
(4, 'Node4', 5),
(5, 'Node5', NULL);


DROP FUNCTION IF EXISTS recurs_table();
CREATE OR REPLACE FUNCTION recurs_table() 
RETURNS TABLE (node_id INT,
               node_name TEXT,
               next_node_id INT,
               lvl INT)
AS $$
BEGIN
  RETURN QUERY WITH RECURSIVE tmp AS 
  (SELECT id, name, next_id, 0 AS Level 
   FROM nodes
   WHERE id = 1

   UNION ALL 

   SELECT nodes.id, nodes.name, nodes.next_id, level + 1 
   FROM nodes JOIN tmp AS t ON t.next_id = nodes.id)
   SELECT * FROM tmp;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM recurs_table();