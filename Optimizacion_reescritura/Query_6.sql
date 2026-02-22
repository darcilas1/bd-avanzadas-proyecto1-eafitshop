-- Reescritura Query 6
EXPLAIN (ANALYZE, BUFFERS)
SELECT o.status, count(*) AS n
FROM orders o
JOIN (
  SELECT order_id
  FROM payment
  WHERE payment_status = 'APPROVED'
) p ON p.order_id = o.order_id
GROUP BY o.status
ORDER BY n DESC;