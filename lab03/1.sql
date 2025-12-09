--Скалярная функция

DROP FUNCTION IF EXISTS avg_salary(e_job_title TEXT);

CREATE OR REPLACE FUNCTION avg_salary(e_job_title TEXT) RETURNS INT AS $$
DECLARE 
  res INT;
BEGIN 
  SELECT AVG(salary) INTO res
  FROM employees e
  WHERE e_job_title = e.job_title;
  RETURN res;
END;
$$ LANGUAGE plpgsql;

SELECT avg_salary('cashier');