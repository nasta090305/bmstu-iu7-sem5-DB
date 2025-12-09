-- Скалярная функция

DROP FUNCTION IF EXISTS two_int_sum(a INT, b INT);
CREATE OR REPLACE FUNCTION two_int_sum(a INT, b INT)
RETURNS INT 
AS $$
    return a + b;
$$ LANGUAGE plpython3u;

SELECT two_int_sum(3, 5);