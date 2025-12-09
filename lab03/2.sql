-- Подставляемую табличную функцию

DROP FUNCTION IF EXISTS pharm_stock(pharmacy INT);

CREATE OR REPLACE FUNCTION pharm_stock(pharmacy INT)
RETURNS TABLE (ID INT,
               med_name TEXT,
               med_distributor TEXT,
               med_price INT,
               med_exp_date DATE,
               med_qnt INT) AS $$
BEGIN
  RETURN QUERY SELECT m.med_id, m.name, m.distributor, m.price, m.exp_date, a.qnt
               FROM medicines m JOIN availability a ON m.med_id = a.med_id
               WHERE a.pharm_id = pharmacy;
END;
$$ LANGUAGE plpgsql;

SELECT * FROM pharm_stock(1);
