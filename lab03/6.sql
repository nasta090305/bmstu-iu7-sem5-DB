--Рекурсивная хранимая процедура


CREATE OR REPLACE PROCEDURE my_factorial(fin_num INT, cur_num INT = 1, cur_num_fact INT = 1)
AS $$
BEGIN
    IF cur_num < fin_num THEN
        CALL my_factorial(fin_num, cur_num + 1, cur_num_fact * (cur_num + 1));
    ELSE
        RAISE NOTICE '%! = %', 
            cur_num, cur_num_fact;
    END IF; 
END;
$$ LANGUAGE PLPGSQL;

CALL my_factorial(5);