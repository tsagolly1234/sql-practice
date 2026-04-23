-- С помощью оконной функции рассчитайте медианную стоимость всех заказов из таблицы orders, оформленных в нашем сервисе. 
-- В качестве результата выведите одно число. Колонку с ним назовите median_price. Отменённые заказы не учитывайте.
-- Поле в результирующей таблице: median_price
-- Пояснение:
-- Запрос должен учитывать два возможных сценария: для чётного и нечётного числа заказов. Встроенные функции для расчёта квантилей применять нельзя.

WITH t1 as (
SELECT
order_id,
SUM(price) as order_price
FROM (SELECT order_id, product_ids, UNNEST(product_ids) as product_id FROM orders)t  JOIN products using(product_id)
WHERE order_id NOT IN (SELECT  order_id FROM user_actions WHERE action='cancel_order')
GROUP BY order_id
ORDER BY order_price
),

t2 as (
SELECT
order_price,
ROW_NUMBER() OVER (ORDER BY order_price) as row_rank,
COUNT(*) OVER() as total_rows
FROM t1
)

SELECT
AVG(order_price) as median_price
FROM t2
WHERE (total_rows % 2 = 0 AND row_rank IN (total_rows/2, total_rows/2 + 1)) OR (total_rows % 2 <> 0 AND row_rank = (total_rows + 1) / 2)
