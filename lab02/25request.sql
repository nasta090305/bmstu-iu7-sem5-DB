--25. Оконные фнкции для устранения дублей
--Придумать запрос, в результате которого в данных появляются полные дубли. 
--Устранить дублирующиеся строки с использованием функции ROW_NUMBER().

WITH dubles AS
(
	SELECT *
	FROM medicines
	UNION ALL
	SELECT *
	FROM medicines 
),
num_dubles AS
(
  SELECT *, ROW_NUMBER() OVER (PARTITION BY med_id) AS num FROM dubles
)


SELECT med_id, name, distributor, price, exp_date
FROM num_dubles
WHERE num = 1