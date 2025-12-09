-- Для каждой валюты выводит информацию дешевле она или дороже рубля (простое выражение CASE)
SELECT c.name, CASE
                 WHEN e.buy > 1 THEN 'Дороже рубля'
                 ELSE 'Дешевле рубля'
               END AS exch_rate
FROM exchange_rate e JOIN currency c ON e.cur_id = c.cur_id;

-- Выводит среднюю сумму и суммарную сумму обмена, произведенного каждым сотрудником (оконная функция)
SELECT DISTINCT e.empl_id, e.fio, SUM(t.sum) OVER (PARTITION BY t.empl_id, t.empl_id) AS sum_by_cur,
AVG(t.sum) OVER (PARTITION BY t.empl_id, t.empl_id) AS avg_sum
FROM exch_employees e JOIN transactions t ON t.empl_id = e.empl_id;

-- Выводит валюты, операции обмена с которыми были произведены более одного раза (GROUP BY + HAVING)
SELECT er.cur_id
FROM transactions t JOIN exchange_rate er ON t.exch_id = er.exch_id
GROUP BY er.cur_id
HAVING COUNT(t.exch_ID) > 1;