-- Для каждого дня в таблице orders рассчитайте следующие показатели:
-- Выручку, полученную в этот день.
-- Суммарную выручку на текущий день.
-- Прирост выручки, полученной в этот день, относительно значения выручки за предыдущий день.
-- Колонки с показателями назовите соответственно revenue, total_revenue, revenue_change. Колонку с датами назовите date.
-- Прирост выручки рассчитайте в процентах и округлите значения до двух знаков после запятой.
-- Результат должен быть отсортирован по возрастанию даты.

SELECT date,
       revenue,
       sum(revenue) OVER(ORDER BY date) as total_revenue,
       round((revenue - lag(revenue) OVER(ORDER BY date))::decimal / lag(revenue) OVER(ORDER BY date) * 100,
             2) as revenue_change
FROM   (SELECT DISTINCT date,
                        sum(price) as revenue
        FROM   (SELECT creation_time::date as date,
                       order_id,
                       unnest(product_ids) as product_id
                FROM   orders
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order')) t
            LEFT JOIN products using(product_id)
        GROUP BY date) t1
ORDER BY date
