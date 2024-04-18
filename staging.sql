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