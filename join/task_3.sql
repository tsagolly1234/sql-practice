-- Выясните, кто заказывал и доставлял самые большие заказы. Самыми большими считайте заказы с наибольшим числом товаров.
-- Выведите id заказа, id пользователя и id курьера. Также в отдельных колонках укажите возраст пользователя и возраст курьера. 
-- Возраст измерьте числом полных лет, как мы делали в прошлых уроках. 
-- Считайте его относительно последней даты в таблице user_actions — как для пользователей, так и для курьеров. Колонки с возрастом назовите user_age и courier_age. 
-- Результат отсортируйте по возрастанию id заказа.

WITH t1 as(
SELECT
user_id,
courier_id,
order_id,
array_length(product_ids, 1) as count_product
FROM orders o LEFT JOIN user_actions ua using(order_id) LEFT JOIN courier_actions ca using(order_id)
WHERE ua.action = 'create_order' AND ca.action = 'deliver_order'
ORDER BY count_product desc
),

t2 as (
SELECT
user_id,
DATE_PART('year', AGE((SELECT max(time)::date FROM user_actions), birth_date))::VARCHAR as user_age
FROM users
GROUP BY user_id
),

t3 as (
SELECT
courier_id,
DATE_PART('year', AGE((SELECT max(time)::date FROM courier_actions), birth_date))::VARCHAR as courier_age
FROM couriers
GROUP BY courier_id
)

SELECT
order_id,
user_id,
user_age,
courier_id,
courier_age
FROM t2 JOIN t1 using(user_id) JOIN t3 using(courier_id)
WHERE count_product = (SELECT MAX(count_product) FROM t1)
ORDER BY order_id
