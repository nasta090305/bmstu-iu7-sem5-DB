-- Хранимую процедуру доступа к метаданным 
CREATE OR REPLACE PROCEDURE table_args_info(my_table TEXT)
AS $$
DECLARE 
  col_info RECORD;
  curs CURSOR FOR 
  SELECT * 
  FROM information_schema.columns
  WHERE table_name = my_table;
BEGIN
  OPEN curs;
  LOOP
    FETCH curs INTO col_info;
    IF col_info.column_name IS NOT NULL THEN
      RAISE NOTICE 'column name = %, column type = %', col_info.column_name, col_info.data_type;
    END IF;
    EXIT WHEN NOT FOUND;
  END LOOP;
  CLOSE curs;
END;
$$ LANGUAGE PLPGSQL;

CALL table_args_info('medicines');
