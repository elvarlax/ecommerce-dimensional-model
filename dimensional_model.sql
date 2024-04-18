-- Dimensions and Facts

-- Dimension Tables:

-- Dimension Users Table:
CREATE OR REPLACE TABLE analytics.dim_users AS (
  SELECT
    user_id
  FROM staging.orders
);

-- Dimension Products Table:
CREATE OR REPLACE TABLE analytics.dim_products AS (
  SELECT
    product_id,
    product_name
  FROM staging.products
);

-- Dimension Aisles Table:
CREATE OR REPLACE TABLE analytics.dim_aisles AS (
  SELECT
    aisle_id,
    aisle
  FROM staging.aisles
);

-- Dimension Departments Table:
CREATE OR REPLACE TABLE analytics.dim_departments AS (
  SELECT
    department_id,
    department
  FROM staging.departments
);

-- Dimension Orders Table:
CREATE OR REPLACE TABLE analytics.dim_orders AS (
  SELECT
    order_id,
    order_number,
    order_dow,
    order_hour_of_day,
    days_since_prior_order
  FROM staging.orders
);

-- Facts

-- Fact Order Products Table:
CREATE OR REPLACE TABLE analytics.fact_order_products AS (
  SELECT
    op.order_id,
    op.product_id,
    o.user_id,
    p.department_id,
    p.aisle_id,
    op.add_to_cart_order,
    op.reordered
  FROM staging.order_products op
  INNER JOIN staging.orders o ON op.order_id = o.order_id
  INNER JOIN staging.products p ON op.product_id = p.product_id
);