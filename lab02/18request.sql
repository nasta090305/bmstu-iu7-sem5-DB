-- 18. Простая инструкция UPDATE. 

SELECT * FROM medicines 
WHERE distributor = 'Sara Petty';

UPDATE medicines
SET price = price / 2
WHERE distributor = 'Sara Petty';

SELECT * FROM medicines 
WHERE distributor = 'Sara Petty';