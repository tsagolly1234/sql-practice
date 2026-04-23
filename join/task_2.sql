-- Произведите замену списков с id товаров из таблицы orders на списки с наименованиями товаров. 
-- Наименования возьмите из таблицы products. Колонку с новыми списками наименований назовите product_names. 
-- Добавьте в запрос оператор LIMIT и выведите только первые 1000 строк результирующей таблицы.
-- Сортировать список не нужно.

SELECT 
order_id,
array_agg(name) as product_names
FROM (
SELECT 
order_id,
name
FROM (SELECT 
order_id,
UNNEST(product_ids) as product_id
FROM orders) t1 LEFT JOIN products using(product_id)) t2
GROUP BY order_id
LIMIT 1000
