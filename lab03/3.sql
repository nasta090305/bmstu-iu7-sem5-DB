-- Многооператорную табличную функцию

DROP FUNCTION IF EXISTS max_stock_pharmacies();

CREATE OR REPLACE FUNCTION max_stock_pharmacies()
RETURNS TABLE (ID INT,
               Pharm_City TEXT,
               Pharm_Street TEXT,
               Pharm_House INT) AS $$
DECLARE
  max_pharm_stock INT;
BEGIN

  SELECT MAX(cnt) INTO max_pharm_stock
  FROM (SELECT COUNT(a.med_id) as cnt
        FROM availability a 
        GROUP BY a.pharm_id);

  RETURN QUERY SELECT *
               FROM pharmacies p
               WHERE p.pharm_id IN (SELECT a.pharm_id
                                    FROM availability a
                                    GROUP BY a.pharm_id
                                    HAVING COUNT(a.med_id) = max_pharm_stock);
END;
$$ LANGUAGE plpgsql;

SELECT *
FROM max_stock_pharmacies();