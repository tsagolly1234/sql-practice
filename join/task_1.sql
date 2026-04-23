-- По таблицам courier_actions , orders и products определите 10 самых популярных товаров, доставленных в сентябре 2022 года.
-- Самыми популярными товарами будем считать те, которые встречались в заказах чаще всего. 
-- Если товар встречается в одном заказе несколько раз (было куплено несколько единиц товара), то при подсчёте учитываем только одну единицу товара.
-- Выведите наименования товаров и сколько раз они встречались в заказах. Новую колонку с количеством покупок товара назовите times_purchased. 
WITH t1 as(
SELECT 
DISTINCT order_id,
UNNEST(product_ids) as product_id
FROM orders LEFT JOIN courier_actions using(order_id)
WHERE action = 'deliver_order' AND DATE_PART('month', time) = 9 AND DATE_PART('year', time) = 2022
)
SELECT
name,
COUNT(product_id) as times_purchased
FROM t1 LEFT JOIN products using(product_id)
GROUP BY name
ORDER BY times_purchased desc
LIMIT 10
