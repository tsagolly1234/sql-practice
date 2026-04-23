-- Для каждого дня в таблицах orders и user_actions рассчитайте следующие показатели:
-- Выручку на пользователя (ARPU) за текущий день.
-- Выручку на платящего пользователя (ARPPU) за текущий день.
-- Выручку с заказа, или средний чек (AOV) за текущий день.
-- Колонки с показателями назовите соответственно arpu, arppu, aov. Колонку с датами назовите date. 
-- При расчёте всех показателей округляйте значения до двух знаков после запятой.
-- Результат должен быть отсортирован по возрастанию даты. 

with total_revenue_by_day as (SELECT date,
                                     sum(price) as revenue,
                                     count(distinct order_id) as orders
                              FROM   (SELECT creation_time::date as date,
                                             order_id,
                                             unnest(product_ids) as product_id
                                      FROM   orders
                                      WHERE  order_id not in (SELECT order_id
                                                              FROM   user_actions
                                                              WHERE  action = 'cancel_order')) t
                                  LEFT JOIN products using(product_id)
                              GROUP BY date), users_by_day as (SELECT time::date as date,
                                        count(distinct user_id) filter(WHERE order_id not in (SELECT order_id
                                                                                       FROM   user_actions
                                                                                       WHERE  action = 'cancel_order')) as paying_users, count(distinct user_id) as users
                                 FROM   user_actions
                                 GROUP BY date)
SELECT date,
       round(revenue::decimal / users, 2) as arpu,
       round(revenue::decimal / paying_users, 2) as arppu,
       round(revenue::decimal / orders, 2) as aov
FROM   total_revenue_by_day
    LEFT JOIN users_by_day using(date)
ORDER BY date
