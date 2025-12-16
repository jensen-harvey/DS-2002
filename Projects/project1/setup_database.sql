-- DS-2002 Project 1 - Database Setup Script
-- E-Commerce Sales Analytics Data Mart

-- Drop databases if they exist (optional - for clean setup)
DROP DATABASE IF EXISTS ecommerce_datamart;
DROP DATABASE IF EXISTS source_customer_db;

-- Create the data mart database
CREATE DATABASE ecommerce_datamart;
USE ecommerce_datamart;

-- Create the source database
CREATE DATABASE source_customer_db;
USE source_customer_db;

-- Create source customer table
CREATE TABLE customers (
    customer_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    email VARCHAR(100),
    country VARCHAR(50),
    city VARCHAR(50),
    customer_segment VARCHAR(20),
    registration_date DATE
);

-- Insert sample customer data
INSERT INTO customers VALUES
(1, 'John', 'Smith', 'john.smith@email.com', 'USA', 'New York', 'Premium', '2023-01-15'),
(2, 'Emma', 'Johnson', 'emma.j@email.com', 'UK', 'London', 'Standard', '2023-02-20'),
(3, 'Michael', 'Brown', 'm.brown@email.com', 'Canada', 'Toronto', 'Premium', '2023-01-10'),
(4, 'Sophia', 'Davis', 'sophia.d@email.com', 'USA', 'Los Angeles', 'Standard', '2023-03-05'),
(5, 'William', 'Garcia', 'w.garcia@email.com', 'Spain', 'Madrid', 'Premium', '2023-01-25'),
(6, 'Olivia', 'Martinez', 'olivia.m@email.com', 'Mexico', 'Mexico City', 'Standard', '2023-04-12'),
(7, 'James', 'Wilson', 'james.w@email.com', 'Australia', 'Sydney', 'Premium', '2023-02-08'),
(8, 'Isabella', 'Anderson', 'isabella.a@email.com', 'USA', 'Chicago', 'Standard', '2023-03-18'),
(9, 'Benjamin', 'Taylor', 'ben.t@email.com', 'Germany', 'Berlin', 'Premium', '2023-01-30'),
(10, 'Mia', 'Thomas', 'mia.thomas@email.com', 'France', 'Paris', 'Standard', '2023-05-02');

-- Verify data
SELECT 'Source Database Setup Complete' AS Status;
SELECT COUNT(*) AS customer_count FROM customers;

-- Switch to data mart for dimension tables
USE ecommerce_datamart;

-- Note: The dimension and fact tables will be created by the Python ETL pipeline
-- This script only sets up the source database

SELECT 'Data mart database created. Run the Jupyter notebook to populate dimensions and facts.' AS Status;
