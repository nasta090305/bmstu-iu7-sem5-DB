--Хранимую процедуру с курсором

CREATE OR REPLACE PROCEDURE availability_by_name(med_name TEXT)
AS $$
DECLARE 
    avlbl RECORD;
    curs CURSOR FOR
        SELECT m.med_id, m.name, m.price, m.exp_date, a.pharm_id, a.qnt
        FROM medicines m JOIN availability a ON m.med_id = a.med_id 
        WHERE m.name = med_name;
BEGIN
    OPEN curs;
    LOOP
        FETCH curs INTO avlbl;
        EXIT WHEN NOT FOUND;
        RAISE NOTICE 'med_id = %, price = %, exp_date = %, pharm_id = %, quantity = %',
                     avlbl.med_id, avlbl.price, avlbl.exp_date, avlbl.pharm_id, avlbl.qnt;
                     
    END LOOP;
    CLOSE curs;
END;
$$ LANGUAGE PLPGSQL;

CALL availability_by_name('nurafen');