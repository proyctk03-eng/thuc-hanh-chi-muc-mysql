-- =============================================================================
-- BÀI THỰC HÀNH: CHỈ MỤC TRONG MYSQL (INDEX IN MYSQL)
-- File: 02_index_practice.sql
-- Mô tả: Các câu lệnh thực hành tạo chỉ mục, phân tích truy vấn bằng EXPLAIN và xóa chỉ mục
-- =============================================================================

USE classicmodels;

-- -----------------------------------------------------------------------------
-- BƯỚC 1: TRUY VẤN DỮ LIỆU VÀ SỬ DỤNG EXPLAIN KHI CHƯA CÓ CHỈ MỤC (INDEX)
-- -----------------------------------------------------------------------------
-- Truy vấn thông tin của khách hàng có tên là 'Land of Toys Inc.'
SELECT * 
FROM customers 
WHERE customerName = 'Land of Toys Inc.';

-- Sử dụng lệnh EXPLAIN để xem kế hoạch thực thi (Execution Plan) của MySQL:
-- KẾT QUẢ QUAN SÁT:
--   - type: ALL (Full Table Scan - Quét toàn bộ bảng từ đầu đến cuối)
--   - possible_keys: NULL (Không có index nào khả dụng)
--   - key: NULL (Không có index nào được sử dụng)
--   - rows: Quét qua tất cả các dòng hiện có trong bảng
--   - Extra: Using where
EXPLAIN SELECT * 
FROM customers 
WHERE customerName = 'Land of Toys Inc.';


-- -----------------------------------------------------------------------------
-- BƯỚC 2: TẠO CHỈ MỤC ĐƠN (SINGLE-COLUMN INDEX) CHO CỘT customerName
-- -----------------------------------------------------------------------------
-- Tạo Index có tên là idx_customerName cho trường customerName trên bảng customers
ALTER TABLE customers ADD INDEX idx_customerName(customerName);


-- -----------------------------------------------------------------------------
-- BƯỚC 3: KIỂM TRA LẠI KẾ HOẠCH THỰC THI BẰNG EXPLAIN SAU KHI ĐÃ ĐÁNH CHỈ MỤC
-- -----------------------------------------------------------------------------
-- KẾT QUẢ QUAN SÁT:
--   - type: ref (Tra cứu tham chiếu qua index có tốc độ cực nhanh)
--   - possible_keys: idx_customerName (Đã nhận diện được index vừa tạo)
--   - key: idx_customerName (MySQL quyết định sử dụng index này)
--   - rows: 1 (Chỉ quét đúng 1 dòng dữ liệu duy nhất thay vì toàn bộ bảng)
--   - Extra: Không còn quét toàn bảng
EXPLAIN SELECT * 
FROM customers 
WHERE customerName = 'Land of Toys Inc.';


-- -----------------------------------------------------------------------------
-- BƯỚC 4: TẠO CHỈ MỤC PHỨC HỢP (COMPOSITE INDEX) TRÊN NHIỀU CỘT
-- -----------------------------------------------------------------------------
-- Tạo composite index idx_full_name kết hợp giữa contactFirstName và contactLastName
ALTER TABLE customers ADD INDEX idx_full_name(contactFirstName, contactLastName);


-- -----------------------------------------------------------------------------
-- BƯỚC 5: TRUY VẤN VÀ PHÂN TÍCH EXPLAIN VỚI ĐIỀU KIỆN TÌM KIẾM THEO TÊN
-- -----------------------------------------------------------------------------
-- Tìm các khách hàng có tên người liên hệ là 'Jean' hoặc 'King'
SELECT * 
FROM customers 
WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';

-- Phân tích kế hoạch thực thi với EXPLAIN:
-- KẾT QUẢ QUAN SÁT:
--   - type: range (Quét theo dải giá trị trên Index)
--   - possible_keys: idx_full_name
--   - key: idx_full_name
--   - rows: Số lượng dòng được khoanh vùng thu hẹp đáng kể
--   - Extra: Using index condition
EXPLAIN SELECT * 
FROM customers 
WHERE contactFirstName = 'Jean' OR contactFirstName = 'King';


-- -----------------------------------------------------------------------------
-- BƯỚC 6: XÓA CHỈ MỤC (DROP INDEX)
-- -----------------------------------------------------------------------------
-- Khi chỉ mục không còn cần thiết hoặc cần tái cấu trúc để tối ưu hiệu năng ghi:
ALTER TABLE customers DROP INDEX idx_full_name;


-- -----------------------------------------------------------------------------
-- BƯỚC 7: KIỂM TRA LẠI DANH SÁCH CHỈ MỤC HIỆN TẠI CỦA BẢNG
-- -----------------------------------------------------------------------------
SHOW INDEX FROM customers;
