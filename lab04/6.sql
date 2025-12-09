-- Определяемый пользователем тип данных

DROP TYPE IF EXISTS py_pharm_cnt_stock CASCADE;
CREATE TYPE py_pharm_cnt_stock as
(
    p int,
    m_cnt int
);

CREATE OR REPLACE FUNCTION get_py_pharm_cnt_stock()
RETURNS SETOF py_pharm_cnt_stock
AS $$
  query = '''
          SELECT pharm_id as p, count(med_id) as m_cnt
          FROM availability
          GROUP BY pharm_id
          ORDER BY p
          LIMIT 10;
          '''
  res = plpy.execute(query)
  return res
$$ LANGUAGE plpython3u;

SELECT * FROM get_py_pharm_cnt_stock()

--Определить препарат, отсутствующий  в аптеках.