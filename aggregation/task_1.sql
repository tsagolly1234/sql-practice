-- Рассчитайте время, когда были совершены первая и последняя доставки заказов в таблице courier_actions.
-- Колонку с временем первой доставки назовите first_delivery, а колонку с временем последней — last_delivery.
SELECT min(time) as first_delivery, max(time) as last_delivery
FROM courier_actions
WHERE action = 'deliver_order'
