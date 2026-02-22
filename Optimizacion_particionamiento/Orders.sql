-- Cambio de nombre para preservar la tabla original
ALTER TABLE orders RENAME TO orders_old;

CREATE TABLE orders (
  order_id      BIGINT NOT NULL,
  customer_id   BIGINT NOT NULL REFERENCES customer(customer_id),
  order_date    TIMESTAMPTZ NOT NULL,
  status        order_status NOT NULL,
  total_amount  NUMERIC(12,2) NOT NULL CHECK (total_amount >= 0),
  PRIMARY KEY (order_id, order_date)
) PARTITION BY RANGE (order_date);

CREATE TABLE orders_2020 PARTITION OF orders
FOR VALUES FROM ('2020-01-01') TO ('2021-01-01');

CREATE TABLE orders_2021 PARTITION OF orders
FOR VALUES FROM ('2021-01-01') TO ('2022-01-01');

CREATE TABLE orders_2022 PARTITION OF orders
FOR VALUES FROM ('2022-01-01') TO ('2023-01-01');

CREATE TABLE orders_2023 PARTITION OF orders
FOR VALUES FROM ('2023-01-01') TO ('2024-01-01');

CREATE TABLE orders_2024 PARTITION OF orders
FOR VALUES FROM ('2024-01-01') TO ('2025-01-01');

CREATE TABLE orders_2025 PARTITION OF orders
FOR VALUES FROM ('2025-01-01') TO ('2026-01-01');

-- 1) Crea partición 2026
CREATE TABLE IF NOT EXISTS orders_2026 PARTITION OF orders
FOR VALUES FROM ('2026-01-01') TO ('2027-01-01');

-- 2) (Opcional recomendado) partición default para futuros out-of-range
CREATE TABLE IF NOT EXISTS orders_default PARTITION OF orders DEFAULT;

-- 3) Limpia lo insertado incompleto (si el INSERT alcanzó a meter algo)
TRUNCATE TABLE orders;

-- 4) Inserta de nuevo
INSERT INTO orders (order_id, customer_id, order_date, status, total_amount)
SELECT order_id, customer_id, order_date, status, total_amount
FROM orders_old;

ANALYZE;