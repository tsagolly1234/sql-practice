-- На основе информации в таблицах orders и products рассчитайте ежедневную выручку сервиса и отразите её в колонке daily_revenue. 
-- Затем с помощью оконных функций и функций смещения посчитайте ежедневный прирост выручки. 
-- Прирост выручки отразите как в абсолютных значениях, так и в % относительно предыдущего дня. Колонку с абсолютным приростом назовите revenue_growth_abs, 
-- а колонку с относительным — revenue_growth_percentage.
-- Для самого первого дня укажите прирост равным 0 в обеих колонках. При проведении расчётов отменённые заказы не учитывайте. 
-- Результат отсортируйте по колонке с датами по возрастанию.
-- Метрики daily_revenue, revenue_growth_abs, revenue_growth_percentage округлите до одного знака.
SELECT date,
       daily_revenue,
       coalesce(round(daily_revenue - lag(daily_revenue, 1) OVER (ORDER BY date), 1),
                0) as revenue_growth_abs,
       coalesce(round((daily_revenue - lag(daily_revenue, 1) OVER (ORDER BY date))/lag(daily_revenue, 1) OVER (ORDER BY date)*100, 1),
                0) as revenue_growth_percentage
FROM   (SELECT creation_time::date as date,
               sum(price) as daily_revenue
        FROM   (SELECT creation_time,
                       product_ids,
                       unnest(product_ids) as product_id
                FROM   orders
                WHERE  order_id not in (SELECT order_id
                                        FROM   user_actions
                                        WHERE  action = 'cancel_order'))t join products using(product_id)
        GROUP BY date)t2
ORDER BY date
