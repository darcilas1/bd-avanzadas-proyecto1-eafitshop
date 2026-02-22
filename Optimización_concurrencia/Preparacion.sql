-- -- 0.1 Asegurar restricción de integridad
ALTER TABLE payment
ADD CONSTRAINT uq_payment_order UNIQUE (order_id);

-- 0.2 Crear índice útil para el claim
CREATE INDEX IF NOT EXISTS idx_orders_status_date
ON orders(status, order_date);

ANALYZE;