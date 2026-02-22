ANALYZE;

CREATE INDEX IF NOT EXISTS idx_orders_customer_id ON orders(customer_id);
CREATE INDEX IF NOT EXISTS idx_order_item_order_id ON order_item(order_id);
CREATE INDEX IF NOT EXISTS idx_order_item_product_id ON order_item(product_id);
CREATE INDEX IF NOT EXISTS idx_payment_order_id ON payment(order_id);

CREATE INDEX IF NOT EXISTS idx_orders_order_date ON orders(order_date);

CREATE INDEX IF NOT EXISTS idx_orders_customer_date_desc
ON orders(customer_id, order_date DESC);

CREATE EXTENSION IF NOT EXISTS pg_trgm;
CREATE INDEX IF NOT EXISTS idx_product_name_trgm
ON product USING gin (name gin_trgm_ops);

CREATE INDEX IF NOT EXISTS idx_payment_approved_order
ON payment(order_id)
WHERE payment_status = 'APPROVED';

ANALYZE;