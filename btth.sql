CREATE DATABASE IF NOT EXISTS btth;
USE btth;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    phone VARCHAR(10) NOT NULL UNIQUE
);

CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL UNIQUE
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    price DECIMAL(10,2) NOT NULL CHECK (price > 0),
    category_id INT NOT NULL,
    CONSTRAINT fk_product_category
        FOREIGN KEY (category_id)
        REFERENCES categories(category_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Completed', 'Cancel') DEFAULT 'Pending',
    CONSTRAINT fk_order_customer
        FOREIGN KEY (customer_id)
        REFERENCES customers(customer_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    product_id INT NOT NULL,
    quantity INT NOT NULL CHECK (quantity > 0),
    CONSTRAINT fk_item_order
        FOREIGN KEY (order_id)
        REFERENCES orders(order_id)
        ON DELETE CASCADE
        ON UPDATE CASCADE,
    CONSTRAINT fk_item_product
        FOREIGN KEY (product_id)
        REFERENCES products(product_id)
        ON DELETE RESTRICT
        ON UPDATE CASCADE
);

INSERT INTO customers (customer_name, email, phone) VALUES
('Nguyễn Văn A', 'a@gmail.com', '0900000001'),
('Trần Thị B', 'b@gmail.com', '0900000002'),
('Lê Văn C', 'c@gmail.com', '0900000003'),
('Phạm Thị D', 'd@gmail.com', '0900000004'),
('Hoàng Văn E', 'e@gmail.com', '0900000005'),
('Võ Thị F', 'f@gmail.com', '0900000006'),
('Đặng Văn G', 'g@gmail.com', '0900000007');

INSERT INTO categories (category_name) VALUES
('Điện thoại'),
('Laptop'),
('Tablet'),
('Phụ kiện'),
('Đồng hồ thông minh');

INSERT INTO products (product_name, price, category_id) VALUES
('iPhone 15 Pro', 29990000, 1),
('Samsung Galaxy S23', 21990000, 1),
('MacBook Air M2', 28990000, 2),
('Dell XPS 13', 25990000, 2),
('iPad Pro M2', 27990000, 3),
('Apple Watch Series 9', 11990000, 5),
('AirPods Pro 2', 5990000, 4),
('Logitech MX Master 3', 2490000, 4);

INSERT INTO orders (customer_id, order_date, status) VALUES
(1, '2025-01-01 10:00:00', 'Completed'),
(1, '2025-01-10 14:30:00', 'Completed'),
(2, '2025-01-12 09:15:00', 'Pending'),
(3, '2025-01-15 20:00:00', 'Completed'),
(4, '2025-01-18 08:45:00', 'Cancel'),
(5, '2025-01-20 16:00:00', 'Completed'),
(6, '2025-01-22 11:30:00', 'Pending');

INSERT INTO order_items (order_id, product_id, quantity) VALUES
(1, 1, 1),
(1, 7, 2),
(2, 3, 1),
(2, 6, 1),
(3, 2, 1),
(3, 8, 1),
(4, 5, 2),
(5, 4, 1),
(6, 1, 1),
(6, 7, 1),
(7, 3, 1);

SELECT *
FROM categories;

SELECT *
FROM orders
WHERE status = 'Completed';

SELECT product_id, product_name, price
FROM products
ORDER BY price DESC;

SELECT product_id, product_name, price
FROM products
ORDER BY price DESC
LIMIT 5 OFFSET 2;

SELECT 
    p.product_id,
    p.product_name,
    p.price,
    c.category_name
FROM products p
JOIN categories c ON p.category_id = c.category_id;

SELECT
    o.order_id,
    o.order_date,
    c.customer_name,
    o.status
FROM orders o
JOIN customers c ON o.customer_id = c.customer_id;

SELECT
    o.order_id,
    SUM(oi.quantity) AS total_quantity
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
LEFT JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name;

SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING COUNT(o.order_id) >= 2;

SELECT
    c.category_name,
    AVG(p.price) AS avg_price,
    MIN(p.price) AS min_price,
    MAX(p.price) AS max_price
FROM categories c
JOIN products p ON c.category_id = p.category_id
GROUP BY c.category_name;

