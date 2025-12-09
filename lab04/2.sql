-- Агрегатная функция

DROP FUNCTION IF EXISTS py_avg_salary(e_job_title TEXT);
CREATE OR REPLACE FUNCTION py_avg_salary(e_job_title TEXT)
RETURNS NUMERIC
AS $$
    query = '''
            SELECT salary
            FROM Employees
            WHERE job_title = $1;
            '''
    prep = plpy.prepare(query, ["TEXT"])
    res = plpy.execute(prep, [e_job_title])
    if res is not None :
        sum = 0
        cnt = 0
        for i in res:
            sum += i["salary"]
            cnt += 1
    return sum / cnt;
$$ LANGUAGE plpython3u;

SELECT py_avg_salary('cashier');