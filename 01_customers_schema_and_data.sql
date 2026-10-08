-- =============================================================================
-- BÀI THỰC HÀNH: CHỈ MỤC TRONG MYSQL (INDEX IN MYSQL)
-- File: 01_customers_schema_and_data.sql
-- Mô tả: Tạo cấu trúc bảng customers (theo CSDL classicmodels) và chèn dữ liệu mẫu
-- =============================================================================

CREATE DATABASE IF NOT EXISTS classicmodels CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE classicmodels;

-- 1. Xóa bảng nếu đã tồn tại để thiết lập lại môi trường sạch
DROP TABLE IF EXISTS customers;

-- 2. Tạo bảng customers chuẩn theo cấu trúc của classicmodels
CREATE TABLE customers (
    customerNumber INT NOT NULL,
    customerName VARCHAR(50) NOT NULL,
    contactLastName VARCHAR(50) NOT NULL,
    contactFirstName VARCHAR(50) NOT NULL,
    phone VARCHAR(50) NOT NULL,
    addressLine1 VARCHAR(50) NOT NULL,
    addressLine2 VARCHAR(50) DEFAULT NULL,
    city VARCHAR(50) NOT NULL,
    state VARCHAR(50) DEFAULT NULL,
    postalCode VARCHAR(15) DEFAULT NULL,
    country VARCHAR(50) NOT NULL,
    salesRepEmployeeNumber INT DEFAULT NULL,
    creditLimit DECIMAL(10,2) DEFAULT NULL,
    PRIMARY KEY (customerNumber)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 3. Chèn tập dữ liệu mẫu đại diện (gồm khách hàng 'Land of Toys Inc.' và các liên hệ 'Jean', 'King')
INSERT INTO customers (customerNumber, customerName, contactLastName, contactFirstName, phone, addressLine1, addressLine2, city, state, postalCode, country, salesRepEmployeeNumber, creditLimit) VALUES
(103, 'Atelier graphique', 'Schmitt', 'Carine', '40.32.2555', '54, rue Royale', NULL, 'Nantes', NULL, '44000', 'France', 1370, 21000.00),
(112, 'Signal Gift Stores', 'King', 'Jean', '7025551838', '8489 Strong St.', NULL, 'Las Vegas', 'NV', '83030', 'USA', 1166, 71800.00),
(114, 'Ferguson Antique Cars', 'Ferguson', 'Peter', '03 9520 4555', '636 St Kilda Road', 'Level 3', 'Melbourne', 'Victoria', '3004', 'Australia', 1611, 65800.00),
(119, 'La Rochelle Gifts', 'Labrune', 'Janine', '40.67.8555', '67, rue des Cinquante Otages', NULL, 'Nantes', NULL, '44000', 'France', 1370, 118200.00),
(121, 'Baane Mini Imports', 'Bergulfsen', 'Jonas', '07-98 9555', 'Erling Skakkes gate 78', NULL, 'Stavern', NULL, '4110', 'Norway', 1504, 81700.00),
(124, 'Mini Gifts Distributors Ltd.', 'Nelson', 'Susan', '4155551450', '5677 Strong St.', NULL, 'San Rafael', 'CA', '97562', 'USA', 1165, 210500.00),
(125, 'Havel & Zbyszek Co', 'Piestrzeniewicz', 'Zbyszek', '+48 22 398 4150', 'ul. Filtrowa 68', NULL, 'Warszawa', NULL, '01-012', 'Poland', NULL, 0.00),
(128, 'Blauer See Auto, Co.', 'Keitel', 'Roland', '+49 69 66 90 2555', 'Lyonerstr. 34', NULL, 'Frankfurt', NULL, '60528', 'Germany', 1504, 59700.00),
(129, 'Mini Caravy', 'Leong', 'Wing', '8882555', '567 Stranger St.', NULL, 'Strasbourg', NULL, '67000', 'France', 1370, 53800.00),
(131, 'Land of Toys Inc.', 'Yu', 'Kwai', '2125557818', '897 Long Airport Avenue', NULL, 'NYC', 'NY', '10022', 'USA', 1323, 114900.00),
(141, 'Euro+ Shopping Channel', 'Freyre', 'Diego', '(91) 555 94 44', 'C/ Moralzarzal, 86', NULL, 'Madrid', NULL, '28034', 'Spain', 1370, 227600.00),
(144, 'Volvo Model Replicas, Co', 'Berglund', 'Christina', '0921-12 355', 'Berguvsvägen  8', NULL, 'Luleå', NULL, 'S-958 22', 'Sweden', 1504, 53100.00),
(145, 'Danish Wholesale Imports', 'Petersen', 'Jytte', '31 12 3555', 'Vinbæltet 34', NULL, 'København', NULL, '1734', 'Denmark', 1401, 83400.00),
(146, 'Saveley & Henriot, Co.', 'Saveley', 'Mary', '78.32.5555', '2, rue du Commerce', NULL, 'Lyon', NULL, '69004', 'France', 1337, 123900.00),
(148, 'Dragon Shrine Resorts, Ltd', 'King', 'King', '03 9520 4555', '636 St Kilda Road', 'Level 3', 'Melbourne', 'Victoria', '3004', 'Australia', 1611, 45800.00),
(151, 'Muscle Machine Inc', 'Simpson', 'Allen', '2125552345', '798 West Road', NULL, 'NYC', 'NY', '10022', 'USA', 1286, 138500.00),
(157, 'Diecast Classics Inc.', 'LeSaux', 'Jean', '2155551555', '1808 Douglas Av.', NULL, 'Allentown', 'PA', '18102', 'USA', 1216, 100600.00),
(161, 'Technics Stores Inc.', 'Hirano', 'Juri', '6505556809', '9408 Furth Circle', NULL, 'Burlingame', 'CA', '94217', 'USA', 1165, 84600.00),
(166, 'Handtkopen Shopping Imports', 'King', 'Jean', '+31 71 5236155', 'Bredavägen 7', NULL, 'Leiden', NULL, '2300 AA', 'Netherlands', 1504, 97900.00),
(167, 'Herkku Gifts', 'Oeztan', 'Veysel', '+47 2267 3215', 'Breivika 5', NULL, 'Bergen', NULL, 'N 5807', 'Norway', 1504, 96800.00);
