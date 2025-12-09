-- Хранимая процедура

INSERT INTO medicines
VALUES (1005, 'adds', 'dsew', 546, '09.11.2024');

INSERT INTO medicines
VALUES (1015, 'adds', 'dsew', 546, '07.11.2024');

SELECT * 
FROM medicines m
ORDER BY m.exp_date
LIMIT 5;

CREATE OR REPLACE PROCEDURE py_delete_expired_meds (expiration_date DATE)
AS $$
    query = '''
            DELETE FROM medicines m
            WHERE m.exp_date <= $1;
            '''
    prep = plpy.prepare(query, ["DATE"])
    plpy.execute(prep, [expiration_date])
$$ LANGUAGE plpython3u;

CALL py_delete_expired_meds('09.11.2024');

SELECT * 
FROM medicines m
ORDER BY m.exp_date
LIMIT 5;