-- На основе информации в таблицах orders и products рассчитайте стоимость каждого заказа, 
-- ежедневную выручку сервиса и долю стоимости каждого заказа в ежедневной выручке, выраженную в процентах. 
-- В результат включите следующие колонки: id заказа, время создания заказа, стоимость заказа, выручку за день, в который был совершён заказ, 
-- а также долю стоимости заказа в выручке за день, выраженную в процентах.
-- При расчёте долей округляйте их до трёх знаков после запятой.
-- Результат отсортируйте сначала по убыванию даты совершения заказа (именно даты, а не времени), 
-- потом по убыванию доли заказа в выручке за день, затем по возрастанию id заказа.
-- При проведении расчётов отменённые заказы не учитывайте.

with t1 as(SELECT order_id,
                  creation_time,
                  sum(price) as total_order_price
           FROM   (SELECT order_id,
                          creation_time,
                          unnest(product_ids) as product_id
                   FROM   orders) t
               LEFT JOIN products using(product_id)
           WHERE  order_id not in (SELECT order_id
                                   FROM   user_actions
                                   WHERE  action = 'cancel_order')
           GROUP BY order_id, creation_time)
SELECT order_id,
       creation_time,
       total_order_price as order_price,
       sum(total_order_price) OVER (PARTITION BY creation_time::date) as daily_revenue,
       round(total_order_price / sum(total_order_price) OVER (PARTITION BY creation_time::date)*100,
             3) as percentage_of_daily_revenue
FROM   t1
ORDER BY creation_time::date desc, percentage_of_daily_revenue desc, order_id
