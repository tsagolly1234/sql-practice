-- Выведите id всех курьеров и их годы рождения, только к извлеченному году примените функцию COALESCE. 
-- Укажите параметры функции так, чтобы вместо NULL значений в результат попадало текстовое значение unknown. 
-- Названия полей оставьте прежними.
-- Отсортируйте итоговую таблицу сначала по убыванию года рождения курьера, затем по возрастанию id курьера.

SELECT
  courier_id,
  COALESCE(DATE_PART('year', birth_date)::VARCHAR, 'unknown') as birth_year
FROM
  couriers
ORDER BY
  birth_year DESC,
  courier_id
