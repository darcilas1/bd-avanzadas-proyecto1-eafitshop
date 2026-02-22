-- Reescritura Query 5
EXPLAIN (ANALYZE, BUFFERS)
SELECT count(*)
FROM orders
WHERE order_date >= TIMESTAMPTZ '2023-11-15 00:00:00+00'
  AND order_date <  TIMESTAMPTZ '2023-11-16 00:00:00+00';