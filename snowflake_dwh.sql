CREATE DATABASE IF NOT EXISTS instacart;
CREATE SCHEMA IF NOT EXISTS instacart.staging;
CREATE SCHEMA IF NOT EXISTS instacart.analytics;

-- CSV File Format
CREATE OR REPLACE FILE FORMAT my_csv_format
TYPE = 'CSV'
FIELD_DELIMITER = ','
SKIP_HEADER = 1
FIELD_OPTIONALLY_ENCLOSED_BY='"';

-- Azure Stage
CREATE OR REPLACE STAGE my_azure_stage
URL = 'azure://your_storage_account.blob.core.windows.net/your_storage_container'
CREDENTIALS=(AZURE_SAS_TOKEN='your_sas_token')
FILE_FORMAT = my_csv_format;

-- Staging Tables

-- Aisles Table:
CREATE OR REPLACE TABLE staging.aisles (
    aisle_id INTEGER PRIMARY KEY,
    aisle VARCHAR(255)
);

COPY INTO staging.aisles (aisle_id, aisle)
FROM @my_azure_stage/aisles.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format');

-- Departments Table:
CREATE OR REPLACE TABLE staging.departments (
    department_id INTEGER PRIMARY KEY,
    department VARCHAR(255)
);

COPY INTO staging.departments (department_id, department)
FROM @my_azure_stage/departments.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format');

-- Products Table:
CREATE OR REPLACE TABLE staging.products (
    product_id INTEGER PRIMARY KEY,
    product_name VARCHAR(255),
    aisle_id INTEGER,
    department_id INTEGER
);

COPY INTO staging.products (product_id, product_name, aisle_id, department_id)
FROM @my_azure_stage/products.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format');

-- Orders Table:
CREATE OR REPLACE TABLE staging.orders (
    order_id INTEGER PRIMARY KEY,
    user_id INTEGER,
    eval_set STRING,
    order_number INTEGER,
    order_dow INTEGER,
    order_hour_of_day INTEGER,
    days_since_prior_order INTEGER
);

COPY INTO staging.orders (order_id, user_id, eval_set, order_number, order_dow, order_hour_of_day, days_since_prior_order)
FROM @my_azure_stage/orders.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format');

-- Order Products Table:
CREATE OR REPLACE TABLE staging.order_products (
    order_id INTEGER,
    product_id INTEGER,
    add_to_cart_order INTEGER,
    reordered INTEGER,
    PRIMARY KEY (order_id, product_id)
);

COPY INTO staging.order_products (order_id, product_id, add_to_cart_order, reordered)
FROM @my_azure_stage/order_products.csv
FILE_FORMAT = (FORMAT_NAME = 'my_csv_format');

-- Dimensions and Facts

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

-- Fact Order Products Table:
CREATE TABLE analytics.fact_order_products AS (
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

-- Analytics

-- Query to calculate the total number of products ordered per department:
SELECT
  d.department,
  COUNT(*) AS total_products_ordered
FROM analytics.fact_order_products fop
INNER JOIN analytics.dim_departments d ON fop.department_id = d.department_id
GROUP BY d.department;

-- Query to find the top 5 aisles with the highest number of reordered products:
SELECT
  a.aisle,
  COUNT(*) AS total_reordered
FROM analytics.fact_order_products fop
INNER JOIN analytics.dim_aisles a ON fop.aisle_id = a.aisle_id
WHERE fop.reordered = TRUE
GROUP BY a.aisle
ORDER BY total_reordered DESC
LIMIT 5;

-- Query to calculate the average number of products added to the cart per order by day of the week:
SELECT
  o.order_dow,
  AVG(fop.add_to_cart_order) AS avg_products_per_order
FROM analytics.fact_order_products fop
INNER JOIN analytics.dim_orders o ON fop.order_id = o.order_id
GROUP BY o.order_dow;

-- Query to identify the top 10 users with the highest number of unique products ordered:
SELECT
  u.user_id, 
  COUNT(DISTINCT fop.product_id) AS unique_products_ordered
FROM analytics.fact_order_products fop
INNER JOIN analytics.dim_users u ON fop.user_id = u.user_id
GROUP BY u.user_id
ORDER BY unique_products_ordered DESC
LIMIT 10;