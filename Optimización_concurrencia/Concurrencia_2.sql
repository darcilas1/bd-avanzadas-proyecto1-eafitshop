---- Cuando estaba mal
-- BEGIN;

-- -- toma una orden creada
-- SELECT order_id
-- FROM orders
-- WHERE status = 'CREATED'
-- ORDER BY order_date
-- LIMIT 1;

-- -- la marca como pagada
-- UPDATE orders
-- SET status = 'PAID'
-- WHERE order_id = (
--   SELECT order_id
--   FROM orders
--   WHERE status = 'CREATED'
--   ORDER BY order_date
--   LIMIT 1
-- );

-- -- intenta insertar pago
-- INSERT INTO payment(payment_id, order_id, payment_date, payment_method, payment_status)
-- SELECT
--   (random()*9e18)::bigint,
--   (
--     SELECT order_id
--     FROM orders
--     WHERE status = 'PAID'
--     ORDER BY order_date
--     LIMIT 1
--   ),
--   now(),
--   'CARD',
--   'APPROVED';

-- COMMIT;

---- Cuando está bien
BEGIN;

WITH picked AS (
  SELECT order_id
  FROM orders
  WHERE status = 'CREATED'
  ORDER BY order_date
  FOR UPDATE skip locked
  LIMIT 1
)
UPDATE orders o
SET status = 'PAID'
FROM picked p
WHERE o.order_id = p.order_id
RETURNING o.order_id;

-- COMMIT;