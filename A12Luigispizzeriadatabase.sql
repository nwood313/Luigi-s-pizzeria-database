CREATE DATABASE IF NOT EXISTS luigis_pizzeria;

USE luigis_pizzeria;

-- Drop tables if they already exist to make the script re-runnable
DROP TABLE IF EXISTS Order_Pizzas;
DROP TABLE IF EXISTS Customers;
DROP TABLE IF EXISTS Orders;
DROP TABLE IF EXISTS Pizzas;

-- 1. Customers Table
CREATE TABLE Customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(15) UNIQUE NOT NULL
);

-- 2. Orders Table 
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATETIME NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id) ON DELETE CASCADE
);

-- 3. Pizzas Table
CREATE TABLE Pizzas (
    pizza_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    price DECIMAL(5, 2) NOT NULL
);

-- 4. Order_Pizzas Table 
CREATE TABLE Order_Pizzas (
    order_pizza_id INT AUTO_INCREMENT PRIMARY KEY, 
    order_id INT,
    pizza_id INT,
    quantity INT DEFAULT 1,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (pizza_id) REFERENCES Pizzas(pizza_id) ON DELETE CASCADE
);

-- Insert Customers
INSERT INTO Customers (name, phone_number) 
VALUES ('Trevor Page', '226-555-4982'),
       ('John Doe', '555-555-9498');

-- Insert Orders
INSERT INTO Orders (customer_id, order_date) 
VALUES (1, '2023-09-10 09:47:00'), -- Order #1: Trevor's first order
       (2, '2023-09-10 13:20:00'), -- Order #2: John's first order
       (1, '2023-09-10 09:47:00'), -- Order #3: Trevor's second order
       (2, '2023-10-10 10:37:00'); -- Order #4: John's second order

-- Insert Pizzas
INSERT INTO Pizzas (name, price) 
VALUES ('Pepperoni & Cheese', 7.99),
       ('Vegetarian', 9.99),
       ('Meat Lovers', 14.99),
       ('Hawaiian', 12.99);

-- Insert Pizzas into Order_Pizzas
INSERT INTO Order_Pizzas (order_id, pizza_id, quantity) 
VALUES (1, 1, 1), -- 1x Pepperoni & Cheese
       (1, 3, 1), -- 1x Meat Lovers
       (3, 3, 1), -- 1x Meat Lovers
       (3, 4, 1); -- 1x Hawaiian
INSERT INTO Order_Pizzas (order_id, pizza_id, quantity) 
VALUES (2, 2, 1), -- 1x Vegetarian
       (2, 3, 2); -- 2x Meat Lovers
INSERT INTO Order_Pizzas (order_id, pizza_id, quantity) 
VALUES (4, 2, 3), -- 3x Vegetarian
       (4, 4, 1); -- 1x Hawaiian

-- Query: Total spent by each customer
SELECT c.name AS customer_name, SUM(p.price * op.quantity) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Pizzas op ON o.order_id = op.order_id
JOIN Pizzas p ON op.pizza_id = p.pizza_id
GROUP BY c.customer_id;

-- Query 2: Total spent by each customer per order date
SELECT c.name AS customer_name, 
    DATE(o.order_date) AS order_date, 
    SUM(p.price * op.quantity) AS total_spent
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Pizzas op ON o.order_id = op.order_id
JOIN Pizzas p ON op.pizza_id = p.pizza_id
GROUP BY c.customer_id, DATE(o.order_date)
ORDER BY DATE(o.order_date), c.name;
