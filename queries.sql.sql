

-- Departments
CREATE TABLE departments (
    department_id INT PRIMARY KEY,
    department VARCHAR(255)
);


-- Products
CREATE TABLE products (
    product_id INT PRIMARY KEY,
    product_name VARCHAR(255),
    aisle_id INT,
    department_id INT
);

-- Orders
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    user_id INT,
    eval_set VARCHAR(20),
    order_number INT,
    order_dow INT,
    order_hour_of_day INT,
    days_since_prior_order FLOAT
);

-- Prior Orders
CREATE TABLE order_products__prior (
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered INT
);

-- Train Orders
CREATE TABLE order_products__train (
    order_id INT,
    product_id INT,
    add_to_cart_order INT,
    reordered INT
);
--check relations--

SELECT o.order_id, p.product_name
FROM orders o
JOIN order_products__prior op
ON o.order_id = op.order_id
JOIN products p
ON op.product_id = p.product_id
LIMIT 10;


select * from order_products__train;
select * from order_products_prior limit 5;
select * from products;
select * from orders ;
select * from aisles

--q1--total orders per user

select user_id ,count (order_id) as total_orders
from orders
group by user_id
order by total_orders desc limit 10;

--q2--average products per order per user

SELECT o.user_id, round(AVG(op_count),2) AS avg_products
FROM (
    SELECT order_id, COUNT(*) AS op_count
    FROM order_products_prior
    GROUP BY order_id
) AS order_counts
JOIN orders o ON o.order_id = order_counts.order_id
GROUP BY o.user_id
ORDER BY avg_products DESC
LIMIT 10;

--q3-- most reordere products per user;

SELECT op.product_id, p.product_name, COUNT(*) AS reorder_count
FROM order_products__prior op
JOIN products p ON op.product_id = p.product_id
WHERE op.reordered = 1
GROUP BY op.product_id, p.product_name
ORDER BY reorder_count DESC
LIMIT 10;

--q4 top 10 products overall;

SELECT p.product_name, COUNT(*) AS total_orders
FROM order_products__prior op
JOIN products p ON op.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_orders DESC
LIMIT 10;

--q5 top products by department;

SELECT d.department, p.product_name, COUNT(*) AS total_orders
FROM order_products__prior op
JOIN products p ON op.product_id = p.product_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department, p.product_name
ORDER BY d.department, total_orders DESC;

--q6--orders per day of week;

SELECT order_dow, COUNT(*) AS total_orders
FROM orders
GROUP BY order_dow
ORDER BY order_dow;

--q7--orders per hour of day;

SELECT order_hour_of_day, COUNT(*) AS total_orders
FROM orders
GROUP BY order_hour_of_day
ORDER BY order_hour_of_day;

--q8--average products per order;

SELECT AVG(product_count) AS avg_products_per_order
FROM (
    SELECT order_id, COUNT(*) AS product_count
    FROM order_products__prior
    GROUP BY order_id
) AS order_counts;

--q9--most popular departments;

SELECT d.department, COUNT(*) AS total_orders
FROM order_products__prior op
JOIN products p ON op.product_id = p.product_id
JOIN departments d ON p.department_id = d.department_id
GROUP BY d.department
ORDER BY total_orders DESC;

--q10--most popular aisles;

SELECT a.aisle, COUNT(*) AS total_orders
FROM order_products__prior op
JOIN products p ON op.product_id = p.product_id
JOIN aisles a ON p.aisle_id = a.aisle_id
GROUP BY a.aisle
ORDER BY total_orders DESC;

