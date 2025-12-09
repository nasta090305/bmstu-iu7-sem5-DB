-- Табличная функция 

DROP FUNCTION IF EXISTS py_pharm_stock(pharmacy INT);
CREATE OR REPLACE FUNCTION py_pharm_stock(pharmacy INT)
RETURNS TABLE (med_id INT,
               name TEXT,
               distributor TEXT,
               price INT,
               exp_date DATE,
               qnt INT)
AS $$
    query = '''
            SELECT m.med_id, m.name, m.distributor, m.price, m.exp_date, a.qnt
            FROM medicines m JOIN availability a ON m.med_id = a.med_id
            WHERE a.pharm_id = $1;
            '''
    prep = plpy.prepare(query, ["INT"])
    res = plpy.execute(prep, [pharmacy])
    return res;
$$ LANGUAGE plpython3u;

SELECT *
FROM py_pharm_stock(1000);