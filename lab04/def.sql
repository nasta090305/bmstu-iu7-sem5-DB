DROP FUNCTION IF EXISTS py_not_available();
CREATE OR REPLACE FUNCTION py_not_available()
RETURNS TABLE (med_id INT,
               name TEXT)
AS $$
    query = '''
            SELECT m.med_id, m.name
            FROM medicines m LEFT JOIN availability a ON m.med_id = a.med_id
            WHERE a.qnt is NULL
            ORDER BY m.med_id;
            '''
    res = plpy.execute(query)
    return res;
$$ LANGUAGE plpython3u;

SELECT * 
FROM py_not_available();


/*
SELECT med_id
FROM medicines
WHERE med_id NOT IN (SELECT DISTINCT med_id
FROM availability);*/
/*
SELECT m.med_id, m.name, m.distributor, m.price, m.exp_date, a.qnt
FROM medicines m LEFT JOIN availability a ON m.med_id = a.med_id
WHERE a.qnt IS NULL
ORDER BY med_id;*/

/*SELECT *
from availability a
where a.med_id = 1;*/