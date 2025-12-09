-- Хранимую процедуру
INSERT INTO medicines
VALUES (1005, 'adds', 'dsew', 546, '09.11.2024');

INSERT INTO medicines
VALUES (1015, 'adds', 'dsew', 546, '07.11.2024');

SELECT * 
FROM medicines m
ORDER BY m.exp_date;

CREATE OR REPLACE PROCEDURE delete_expired_meds (expiration_date DATE)
AS $$
BEGIN
  DELETE FROM medicines m
  WHERE m.exp_date <= expiration_date;
END;
$$ LANGUAGE plpgsql;

CALL delete_expired_meds('09.11.2024');

SELECT * 
FROM medicines m
ORDER BY m.exp_date;
