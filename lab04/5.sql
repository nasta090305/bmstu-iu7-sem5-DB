-- Триггер

CREATE OR REPLACE FUNCTION py_del_info()
RETURNS TRIGGER
AS $$
    plpy.notice(f"Deleted element: id = {TD['old']['med_id']}, name = {TD['old']['name']}");
$$ LANGUAGE plpython3u;

CREATE OR REPLACE TRIGGER py_delete_info AFTER DELETE
  ON medicines
  FOR EACH ROW
  EXECUTE FUNCTION py_del_info();

INSERT INTO medicines
VALUES (1001, 'name', 'distr', 1000, '02.12.2025');

DELETE FROM medicines
WHERE med_id = 1001;