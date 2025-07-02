-- Create database
CREATE DATABASE IF NOT EXISTS restaurant_db;
USE restaurant_db;

-- Create menu categories table
CREATE TABLE menu_categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create menu items table
CREATE TABLE menu_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    category_id INT NOT NULL,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    available BOOLEAN DEFAULT TRUE,
    display_order INT NOT NULL DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES menu_categories(id)
);

-- Create reservations table
CREATE TABLE reservations (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) NOT NULL,
    reservation_date DATE NOT NULL,
    reservation_time TIME NOT NULL,
    guests INT NOT NULL,
    special_requests TEXT,
    status ENUM('pending', 'confirmed', 'cancelled') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create contact messages table
CREATE TABLE contact_messages (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    subject VARCHAR(200) NOT NULL,
    message TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Create admin users table
CREATE TABLE admin_users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Insert sample menu categories
INSERT INTO menu_categories (name, description, display_order) VALUES
('Appetizers', 'Start your meal with our delicious appetizers', 1),
('Main Courses', 'Our signature main dishes', 2),
('Desserts', 'Sweet endings to your meal', 3),
('Drinks', 'Refreshing beverages', 4);

-- Insert sample menu items
INSERT INTO menu_items (category_id, name, description, price, display_order) VALUES
(1, 'Bruschetta', 'Toasted bread topped with tomatoes, garlic, and fresh basil', 8.99, 1),
(1, 'Calamari', 'Crispy fried squid served with marinara sauce', 12.99, 2),
(2, 'Filet Mignon', '8oz tender beef filet with mashed potatoes and seasonal vegetables', 32.99, 1),
(2, 'Grilled Salmon', 'Fresh Atlantic salmon with lemon butter sauce and asparagus', 26.99, 2),
(3, 'Tiramisu', 'Classic Italian dessert with layers of coffee-soaked ladyfingers', 9.99, 1),
(3, 'Chocolate Lava Cake', 'Warm chocolate cake with a molten center, served with vanilla ice cream', 10.99, 2),
(4, 'House Red Wine', 'Glass of our signature red blend', 8.99, 1),
(4, 'Craft Beer', 'Local IPA or Lager', 6.99, 2);

-- Create admin user (password: admin123)
INSERT INTO admin_users (username, password_hash, full_name, email) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'Administrator', 'admin@restaurant.com');
