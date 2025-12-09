-- Триггер AFTER

CREATE OR REPLACE FUNCTION del_info()
RETURNS TRIGGER
AS $$
BEGIN
    RAISE NOTICE 'Deleted element: id = %, name = %', OLD.med_id, OLD.name;
    RETURN OLD;
END;
$$ LANGUAGE PLPGSQL;

CREATE OR REPLACE TRIGGER delete_info AFTER DELETE
  ON medicines
  FOR EACH ROW
  EXECUTE FUNCTION del_info();

DELETE FROM medicines
WHERE med_id = 21;